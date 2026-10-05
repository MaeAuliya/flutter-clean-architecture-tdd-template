# Dart and Flutter Style

**Status: Preferred, with mandatory consistency.**

Use the language and framework idioms rather than building a local dialect. Static analysis is the executable baseline; this document covers decisions linters cannot fully express.

## Declarations

- Prefer `final` fields and local variables; use `var` only when the inferred type is obvious and the value is reassigned intentionally.
- Use `const` constructors and instances when every input is compile-time constant.
- Keep constructors named and required when parameters share a type or carry meaning.
- Make implementation classes `final` unless extension is a deliberate API.
- Use sealed classes for closed state/failure variants and exhaustive switches.
- Avoid `dynamic` beyond an external parsing boundary.

```dart
final class LoadItem {
  const LoadItem({required ItemRepository repository})
      : _repository = repository;

  final ItemRepository _repository;
}
```

## Enhanced enums

**Preferred for new or touched code.** Use an enhanced enum when a finite,
closed set of variants owns small immutable metadata or behavior that otherwise
would be repeated across callers. Keep the data declared by each value constant,
and derive variant-specific values with an exhaustive switch expression.

```dart
enum ExampleStep {
  first(MediaRes.exampleFirst),
  second(MediaRes.exampleSecond);

  const ExampleStep(this.assetPath);

  final String assetPath;

  String title(Texts texts) => switch (this) {
    ExampleStep.first => texts.exampleFirstTitle,
    ExampleStep.second => texts.exampleSecondTitle,
  };
}
```

Pass runtime or presentation dependencies — a string source, generated
localizations once adopted — to the method that needs them; do not store
display strings in enum values. An enum that imports string, asset, or color
types is presentation-facing and belongs with the feature or shared
presentation capability that owns it. It must not move into domain, data, or
`core/` merely to make the enum globally reachable.

Enhanced enums are not miniature service objects. Do not use them for mutable
state, I/O, open-ended server data, or behavior that belongs in a use case or
repository. Keep serialized/wire values explicit rather than relying on
`enum.name`, and use `.values` only when declaration order is intentionally part
of the presentation behavior.

## Functions

- One function does one conceptual operation.
- Extract a helper when it gives a block a meaningful name or removes real duplication, not merely to reduce line count.
- Prefer early returns to nested conditionals.
- An asynchronous function returns `Future<T>`, never `void`, except framework callbacks that require it.
- Include a verb in operation names: `loadProfile`, `validateToken`, `mapFailure`.
- Boolean names read as predicates: `isReady`, `hasSession`, `canSubmit`.

## Widgets

- Build methods compose; they do not perform I/O, mutate providers, or navigate.
- Routed pages belong in `screens/`; large sections in `views/`; small local components in `widgets/`.
- Use shared components before introducing a feature-local substitute.
- Read color and typography from the theme. Raw tokens stay in theme construction.
- Keep stateful resources — controllers, focus nodes, subscriptions — with the smallest owning state object and dispose them.
- Prefer composition to subclassing framework widgets.

## Comments

Comments explain **why**, constraints, or non-obvious protocol behavior. Do not narrate syntax.

Useful:

```dart
// Multipart bodies are consumed on send; snapshot before auth retry.
```

Noise:

```dart
// Set loading to true.
isLoading = true;
```

Delete stale and commented-out code. Version control is the archive.

## Formatting and analysis

- Use the standard Dart formatter; do not hand-align code against it.
- Run static analysis before completion.
- Do not suppress a lint globally to fix one site.
- A local suppression includes a reason when the rule's intent is not obvious.
- Do not reformat unrelated files in a scoped change.

Recommended baseline:

```yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    prefer_const_constructors: true
    # choose one import policy and enforce it
```

## Naming and files

Dart files use `lower_snake_case`, types use `UpperCamelCase`, and members use `lowerCamelCase`. Suffixes communicate architectural role:

| Role | Type / file |
|---|---|
| Entity | `Item` / `item.dart` |
| Transport model | `ItemModel` / `item_model.dart` |
| Repository contract | `ItemRepository` / `item_repository.dart` |
| Implementation | `ItemRepositoryImpl` / `item_repository_impl.dart` |
| Data source | `ItemRemoteDataSource` / `item_remote_data_source.dart` |
| Use case | `LoadItem` / `load_item.dart` |
| Routed page | `ItemScreen` / `item_screen.dart` |
| Bloc | `ItemBloc` / `item_bloc.dart` |
| Route-scoped notifier | `ItemProvider` / `item_provider.dart` |

An entity carries no suffix: the domain type is `Item`, not `ItemEntity`. The hand-written code follows this; the generator currently emits `<Name>Entity` in `<name>_entity.dart`, which is tracked in [Template Next Steps](../TODO/next_steps.md) — rename after generating, or leave it consistently and record the deviation.

Pick one noun per concept. Avoid vague suffixes such as `Service` when a capability name (`TokenRefresher`, `LocationGateway`) is clearer. Split files by responsibility rather than a fixed line count. Generated files follow their tool and are never hand-edited.

## Imports

Choose one internal import policy at project bootstrap:

- Relative imports make locality visible in application packages.
- Package imports avoid deep traversal and suit modular packages.

Neither is universally superior; mixing both is. Group SDK, third-party, and project imports. Do not import another feature's data or presentation internals, and do not use barrels that expose an entire feature's private surface.

## Async and immutable code

- Await work whose completion affects the next step.
- Fire-and-forget work must be explicit, best-effort, and handle errors.
- Store and cancel subscriptions, timers, and platform controllers.
- Prevent duplicate submissions, stale search results, and overlapping refreshes through cancellation, generation IDs, or single-flight coordination.
- Run independent work concurrently only when no hidden order exists.
- Use immutable states/entities and immutable collection views.
- Inject clocks, ID generators, and randomness into testable policy.
- Use UTC for persistence/transport and localize time at presentation.

For nullable `copyWith` fields, use a sentinel or generated immutable model so "leave unchanged" and "set null" are distinct.

## Error text and localization

Do not assemble final user-facing copy in data or domain layers. Domain returns typed reasons; presentation localizes them. Technical diagnostics never become UI text through `error.toString()`.

## Legacy / anti-patterns

- Mutable public fields on entities or states
- A `Utils` class that accumulates unrelated capabilities
- Multiple independent booleans encoding a variant/state machine
- Business rules in widget callbacks
- Global text-scale clamp used to hide layout defects
- Empty interfaces and folders generated for symmetry
- Comments that promise future work without an issue or TODO owner

## Related documents

- [Project Structure and Boundaries](../architecture/project_structure_and_boundaries.md)
- [State Management](../patterns/state_management.md)
- [Localization](../patterns/localization.md)
- [Shared UI](../patterns/shared_ui.md)
- [Code Review Checklist](../quality/code_review_checklist.md)
