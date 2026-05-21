# Routing Pattern

This project uses a centralized route engine with feature route registries.

## Structure

```text
lib/src/core/services/router/
├── app_route.dart
├── app_routes.dart
├── router.dart
└── registries/
    └── feature_name_route_registry.dart
```

## Responsibilities

### `app_route.dart`

Defines route contracts:

- `AppRoute`
- `AppRouteBuilder`
- `FeatureRouteRegistry`

### `app_routes.dart`

Collects all feature route registries.

### `router.dart`

Contains `generateRoute` and fallback routing.

### `registries/`

Contains one route registry per feature.

## Rules

- Do not add route switch-cases directly to `router.dart`.
- Do not use `part` files for routing.
- Each feature should have a route registry.
- New feature routes should be added through the file generator.
- Unknown routes should fall back to `PageUnderConstruction`.

## AI Guidance

When creating a feature, use the file generator so the route registry is created and registered automatically.
