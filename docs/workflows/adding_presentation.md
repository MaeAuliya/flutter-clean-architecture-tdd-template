# Workflow: Adding Presentation

Covers a screen, its route, and state management.

## Preconditions

- Domain operation and failure contract exist
- Screen states and actions are defined
- Shared component inventory has been checked
- Route ownership and arguments are known

## 1. Model screen state

List mutually exclusive and coexisting states before writing widgets:

```text
initial → loading → content | empty | failure
                    ↘ submitting → success | field failure | general failure
```

Choose a sealed state hierarchy for mutually exclusive states or one immutable state object with typed async sub-states for independent operations. Do not encode the state machine as several unrelated booleans.

## 2. Create a route-scoped state holder

- Inject use cases through its constructor
- Emit loading before work and a terminal state on every path
- Keep transport exceptions and DTOs out
- Coordinate repeated concerns through shared policy, not manual status checks
- Dispose subscriptions/timers

Register it as a factory and provide it when the route opens.

## 3. Add form/UI state only where needed

For a complex form, use a route-scoped form controller. For one toggle or selected tab, local widget state may be simpler. Do not mirror the same value in bloc, provider, and text controller.

## 4. Build the screen hierarchy

```text
bloc/item_bloc.dart               # async/server state, events, states
providers/item_provider.dart      # route-scoped ChangeNotifier, if needed
extensions/item_context_extension.dart   # typed context accessors for this feature
screens/item_screen.dart          # route shell, providers, listeners
views/item_content_view.dart      # large body
views/item_error_view.dart        # only if shared error state is insufficient
widgets/item_badge.dart           # small local component
```

The split between `screens/` and `views/` is load-bearing: a `Screen` owns `static const routeName`, lifecycle, listeners, and the `Scaffold`; a `View` owns the layout body and nothing else.

Use shared scaffold, buttons, inputs, and loading/empty/error views. Read colors and type from the theme.

## 5. Register the route

- Declare a stable route identifier as `static const routeName` on the screen
- Add the `AppRoute` to the feature's `FeatureRouteRegistry`, not to a shared router file
- Wrap the screen in its `BlocProvider`/`ChangeNotifierProvider` inside that registry entry
- Use a typed immutable args object for meaningful inputs
- Validate required args; do not silently invent identifiers
- Define back behavior and deep-link requirements

See [Routing](../patterns/routing.md) for the registry shape.

## 6. Localization

Classify every new literal. Keep routes, keys, log tags, asset paths, and wire values technical. Context-free validators/state expose semantic message identifiers that presentation resolves.

If the project has adopted localization, put user-facing copy in ARB, access it through `context.l10n`, and run `flutter gen-l10n` after resource edits. This template has not — see [Localization](../patterns/localization.md) — so user-facing copy goes in `core/res/texts.dart` and never inline in a widget.

## 7. Effects

Handle navigation, snackbar, dialog, and external launch through a listener/effect channel. Effects must be consumed once and not replay on rebuild.

For a listener that handles several typed state variants, follow the
[typed listener dispatch](../patterns/state_management.md#typed-listener-dispatch)
convention: group variants that produce the same effect and destructure payloads
in their case patterns. Keep durable rendering in the builder or view rather
than moving it into the listener.

## 8. Verify

- Widget test every major state
- Test at increased text scale and dark mode
- Test back navigation and invalid args
- Check loading blocks duplicate submit
- Check recoverable errors expose retry
- Check state is fresh on route revisit
- Check controllers/subscriptions dispose

## Common mistakes

- I/O in `build` or button callback
- State provider created at app root
- Hardcoded feature colors
- Fixed-height text container
- Navigating from a repository/interceptor for ordinary feature flow
- Missing empty state
- Snackbar flag stored permanently in state

## Related documents

- [State Management](../patterns/state_management.md)
- [Routing](../patterns/routing.md)
- [Shared UI](../patterns/shared_ui.md)
- [Forms and Validation](../patterns/forms_and_validation.md)
