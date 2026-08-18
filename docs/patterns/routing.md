# Routing

**Status: Preferred pattern.** The routing package is context-dependent; typed arguments and centralized route ownership are mandatory.

Routing translates a destination and its arguments into a page and its dependencies. It should not contain business policy.

---

## Central route table

For a medium application, one route generator is simple and visible:

```dart
final class AppRouter {
  static final navigatorKey = GlobalKey<NavigatorState>();

  static Route<dynamic> generate(RouteSettings settings) {
    return switch (settings.name) {
      ProfileScreen.routeName => page(
          settings,
          (_) => BlocProvider(
            create: (_) => locator<ProfileBloc>(),
            child: ProfileScreen(
              args: requireArgs<ProfileArgs>(settings),
            ),
          ),
        ),
      _ => unknownRoute(settings),
    };
  }
}
```

This is the composition boundary: it creates route-scoped state and hands typed arguments to the screen.

As the application grows, split registrations by feature while retaining one router interface. See [Scalability Guidelines](../architecture/scalability_guidelines.md).

---

## Typed arguments

**Mandatory.** Multi-field or semantically important arguments use a dedicated immutable type:

```dart
final class DetailArgs {
  const DetailArgs({required this.itemId, this.openInEditMode = false});
  final ItemId itemId;
  final bool openInEditMode;
}
```

Avoid passing untyped maps. A map moves a compile-time contract to runtime and makes refactoring unsafe.

Decide whether missing args are recoverable:

```dart
T requireArgs<T>(RouteSettings settings) {
  final args = settings.arguments;
  if (args is! T) throw StateError('Expected route arguments of type $T');
  return args;
}
```

Do not silently default a required identifier; that turns a navigation defect into a downstream data defect.

---

## Route ownership

Each routed screen declares its route name (or typed route object) near the screen. The root router registers it.

```dart
final class ProfileScreen extends StatelessWidget {
  static const routeName = '/profile';
}
```

**Mandatory.** Route identifiers are stable public contracts. Deep links, notifications, analytics, and persisted navigation may reference them. Rename deliberately and update every producer.

---

## State provisioning

Create mutable state when the route opens:

```dart
BlocProvider(
  create: (_) => locator<DetailBloc>()..add(LoadDetail(args.id)),
  child: DetailScreen(args: args),
)
```

This ties state disposal to the route and prevents stale content on revisits.

For state shared across nested routes in one flow, provide it above the nested navigator or flow shell, not application-wide.

---

## Navigation outside widgets

A global navigator key is sometimes required for truly global infrastructure events — unrecoverable session expiry, a push notification tap, or a deep link received before a screen is ready.

**Preferred constraint.** Hide the key behind a narrow `NavigationService` or coordinator. Infrastructure code should request `showSessionExpired()` rather than know a login route string.

**Do not use a global key as a shortcut** for ordinary feature navigation. Local UI navigation belongs in presentation where lifecycle and context are visible.

---

## Nested navigation

**Optional.** Use a nested navigator when a feature owns a multi-step flow whose internal history should not pollute the application history — onboarding, checkout, or setup wizard.

The flow defines its own internal routes. Exiting the flow produces one application-level result. Do not introduce nested navigation for two adjacent screens; it adds back-button and deep-link complexity.

---

## Deep links and notifications

Route incoming external intents through a parser:

```text
raw URI / notification payload
  → validate source and shape
  → convert to typed AppLink
  → check session/startup readiness
  → navigate to typed destination
```

Never pass an external payload directly to the router. See [Notifications and Deep Links](notifications_and_deep_links.md).

---

## Common mistakes

- Casting nullable arguments to a required type without a useful failure
- Creating blocs globally because the router cannot resolve them
- Business branching in the route table (fetching, validation, access policy)
- Route strings scattered through widgets
- Navigating during `build`
- Clearing the whole stack without documenting the intended back behavior
- Using another feature's screen directly instead of navigating through its public entry point

---

## Testing

- Unit-test route argument parsing and deep-link conversion
- Widget-test that important routes resolve with valid args
- Test invalid/missing args produce the documented failure screen or controlled exception
- Integration-test back-stack behavior for authentication and nested flows
- Test global effects only navigate once under concurrent events

---

## Related documents

- [State Management](state_management.md)
- [Notifications and Deep Links](notifications_and_deep_links.md)
- [Application Bootstrap](app_bootstrap.md)
- [Adding Presentation](../workflows/adding_presentation.md)
