# State Management

**Status: Context-dependent library choice; mandatory ownership rules.**

State management has two distinct jobs: coordinating asynchronous domain operations, and holding ephemeral UI state. Conflating them produces either bloated business state machines or untestable widget-local logic.

---

## State categories

| Category | Examples | Owner | Lifetime |
|---|---|---|---|
| Domain operation | load, submit, refresh, upload | Bloc/cubit/controller | Route or feature |
| Form input | text, selection, validation visibility | Form notifier or widget controller | Screen/form |
| UI interaction | tab, expanded section, wizard step | Widget/provider | Smallest owning subtree |
| Application | session, theme, locale, connectivity | App-level service/provider | Process/session |
| Derived | filtered list, can-submit, total | Compute from source state | No separate mutable state |

**Mandatory.** State belongs to the narrowest lifecycle that needs it. Application scope is not a convenience scope.

---

## Async feature state

Represent state transitions explicitly:

```dart
sealed class ItemState {
  const ItemState();
}

final class ItemInitial extends ItemState {}
final class ItemLoading extends ItemState {}
final class ItemLoaded extends ItemState {
  const ItemLoaded(this.item);
  final Item item;
}
final class ItemEmpty extends ItemState {}
final class ItemFailure extends ItemState {
  const ItemFailure(this.message);
  final String message;
}
```

For a single operation, a sealed hierarchy is clear. For a screen with several independent operations, one state object with explicit fields may avoid a combinatorial explosion:

```dart
final class ExampleScreenState {
  const ExampleScreenState({
    this.example = const AsyncValue.initial(),
    this.items = const AsyncValue.initial(),
  });

  final AsyncValue<Example> example;
  final AsyncValue<List<Item>> items;
}
```

Choose based on whether operations replace one another or coexist.

---

## Event-driven versus method-driven

**Event-driven bloc** is useful when:

- Events need transformation (debounce, restart, sequential handling)
- Transitions form a meaningful state machine
- The event log helps debugging
- Several UI sources trigger the same operation

**Method-driven cubit/notifier** is useful when:

- Operations are simple commands
- Event types add no semantic value
- The state holder has a small surface

The architecture does not require events. It requires explicit state and testable operations.

---

## UI-only providers

A notifier for a multi-field form is reasonable:

```dart
final class ProfileFormController extends ChangeNotifier {
  String _name = '';
  bool _submitted = false;

  String get name => _name;
  String? get nameError => _submitted ? validateName(_name) : null;
  bool get canSubmit => validateName(_name) == null;

  void updateName(String value) {
    if (_name == value) return;
    _name = value;
    notifyListeners();
  }
}
```

Provide it at the screen or route:

```dart
ChangeNotifierProvider(
  create: (_) => ProfileFormController(),
  child: const ProfileScreen(),
)
```

**Legacy / anti-pattern.** Registering all feature form providers in the application root makes every form application-global. Manual `init...()` and reset methods are then needed to clear stale state, and a forgotten reset shows the user data from a previous visit. Scope the provider correctly and lifecycle performs the reset for free.

### The two provider registries

This template keeps the distinction structural, not conventional:

| Registry | File | What belongs there |
|---|---|---|
| Route-scoped | the feature's `FeatureRouteRegistry` under `core/services/router/registries/` | Every mutable feature provider. Created when the route is pushed, disposed when it is popped. |
| Application-scoped | `core/services/providers/app_providers.dart` | Only intentionally app-lifetime state — session, theme, connectivity. |

**Mandatory.** Create mutable feature providers inside their route/flow registry. Never register feature state in `main.dart`, and do not add it to `AppProviders` to make it reachable. `AppProviders.providers` is wired once into the root `MultiProvider`; an entry there lives for the whole process.

`app_providers.dart` carries a `// GENERATED APP PROVIDERS - DO NOT REMOVE` marker. No generator path writes to it today, so entries are added by hand — the marker reserves the insertion point. See [Template Next Steps](../TODO/next_steps.md).

---

## Failure handling

State holders consume typed failures and emit renderable states. They must not parse HTTP responses or catch client exceptions.

For concerns repeated across many state holders — such as unrecoverable session expiry — use one reusable policy:

```dart
mixin SessionAware<S> {
  S sessionExpiredState();

  void emitFailure(Failure failure, Emitter<S> emit) {
    if (failure is SessionExpiredFailure) {
      emit(sessionExpiredState());
    } else {
      emit(genericFailureState(failure.userMessage));
    }
  }
}
```

**Preferred.** The failure mode this avoids is partial adoption: a mixin that exists but is used by one state holder while the rest inspect status codes by hand. Two mechanisms then define the same behavior differently and neither is authoritative. Choose one at the beginning and apply it everywhere.

Represent session expiry as a typed failure rather than a numeric status check in presentation. This template already does the first half — `FailureMapper` turns a `401`/`403` into `UnauthorizedFailure`, so presentation never sees a status code.

---

## Side effects

Navigation, dialogs, snackbars, and launching an external app are effects, not durable screen state.

Options:

- State listener consumes a one-shot transition and immediately clears it
- Separate effect stream
- Coordinator handles global effects such as session expiry

Do not store `showSnackbar: true` indefinitely in state; rebuilding the widget can replay it.

### Typed listener dispatch

**Preferred for new or touched multi-branch listeners.** When a listener reacts
to several typed state variants, use a switch statement instead of a long
`if`/`else if` chain. Object patterns keep payload extraction beside the state
that provides it, while consecutive case labels make identical effects explicit.

```dart
BlocListener<ItemBloc, ItemState>(
  listener: (context, state) {
    switch (state) {
      case SaveItemLoading():
      case RetrySaveItemLoading():
        context.showLoading();

      case SaveItemFailure(:final message):
      case RetrySaveItemFailure(:final message):
        context.hideLoading();
        context.showError(message);

      case SaveItemSuccess(:final item):
        context.hideLoading();
        context.openItem(item.id);

      case SaveItemCancelled():
        context.hideLoading();
    }
  },
  child: const ItemView(),
)
```

Keep a direct `if` for one or two simple branches; a switch is useful when it
makes a real state dispatch table easier to scan. Group cases by the effect they
produce, use short comments only for meaningful groups, and extract a private
handler when a branch or repeated effect sequence becomes long.

For a sealed state hierarchy owned by the listener, cover every variant and
omit a wildcard so the analyzer reports newly added states. A listener attached
to a broader or open hierarchy may use `case _` to ignore states that are
deliberately irrelevant to that screen, but that fallback is not exhaustive
checking. Consider a narrower state/effect type or `listenWhen` when unrelated
transitions dominate the listener.

This convention is being adopted gradually. Existing `if`/`else if` listeners
do not require migration unless they are being changed and the switch form is
clearer for the states in scope.

---

## Mandatory conventions

- Mutable state holders are route-scoped unless explicitly global.
- Every async path leaves loading — success, failure, cancellation, and session expiry.
- State objects are immutable.
- Derived values are computed, not synchronized manually in second mutable fields.
- UI state does not contain transport models or exceptions.
- Dispose text controllers, camera controllers, subscriptions, and timers with their owner.

## Preferred conventions

- Equality-aware immutable state to suppress redundant renders
- Separate independent async sub-states on complex screens
- Selectors/build filters for small rebuild surfaces
- One source of truth; avoid mirroring the same value in bloc and provider

---

## Testing

For each operation test:

1. Initial state
2. Loading before awaiting
3. Success state and payload
4. Typed failure state
5. Session-expired/terminal path where relevant
6. Overlapping requests if concurrency is possible
7. Disposal/cancellation for long-running streams

Use the state library's test utilities where useful, but the assertions should remain understandable without them.

---

## Related documents

- [Architecture Overview](../architecture/architecture_overview.md)
- [Dependency Injection](dependency_injection.md)
- [Dart and Flutter Style](../conventions/dart_flutter_style.md)
- [Error Handling](error_handling.md)
- [Forms and Validation](forms_and_validation.md)
- [Adding Presentation](../workflows/adding_presentation.md)
