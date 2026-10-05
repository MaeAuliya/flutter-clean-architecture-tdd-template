# Routing

**Status: Preferred pattern.** The routing package is context-dependent; typed arguments and centralized route ownership are mandatory.

Routing translates a destination and its arguments into a page and its dependencies. It should not contain business policy.

---

## Central route table

A single `switch` over route names is the simplest visible form, but it becomes a merge-conflict hotspot as soon as several features are added to it. This template instead splits registration per feature behind one router interface from the start:

```dart
class AppRoute {
  const AppRoute({required this.name, required this.builder});
  final String name;
  final AppRouteBuilder builder;   // Widget Function(BuildContext, RouteSettings)
}

abstract interface class FeatureRouteRegistry {
  List<AppRoute> get routes;
}
```

Each feature implements the registry, and this is where route-scoped state is created:

```dart
class ProfileRouteRegistry implements FeatureRouteRegistry {
  const ProfileRouteRegistry();

  @override
  List<AppRoute> get routes => [
    AppRoute(
      name: ProfileScreen.routeName,
      builder: (context, settings) => MultiProvider(
        providers: [
          BlocProvider(create: (_) => sl<ProfileBloc>()),
          ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ],
        child: const ProfileScreen(),
      ),
    ),

    // GENERATED PROFILE FEATURE ROUTES - DO NOT REMOVE
  ];
}
```

Registries are listed in `AppRoutes._registries`, which flattens them into a name→builder map. `generateRoute` is then only a lookup:

```dart
Route<dynamic> generateRoute(RouteSettings settings) {
  final route = AppRoutes.routeMap[settings.name];
  if (route == null) {
    return _page(settings, (_) => const PageUnderConstruction());
  }
  return _page(settings, (context) => route.builder(context, settings));
}
```

**Mandatory.** `generateRoute` performs a map lookup and nothing else. No switch-cases, no conditional logic, no bloc or provider construction — that belongs in the feature's registry. Adding a route means editing one feature registry, not a shared file.

The `PageUnderConstruction` fallback is a development affordance, not an error screen. A production application should distinguish "route not registered" (a defect) from a user-facing not-found page.

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

This template's `AppRoute` passes `RouteSettings` through to the builder but ships no argument type or `requireArgs` helper yet — its one feature takes no arguments. Add both when the first screen needs them; see [Template Next Steps](../TODO/next_steps.md).

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
