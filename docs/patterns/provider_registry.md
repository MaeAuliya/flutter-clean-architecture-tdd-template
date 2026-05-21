# Provider Registry Pattern

This project uses a centralized provider registry to keep `main.dart` clean.

## Structure

```text
lib/src/core/services/providers/
└── app_providers.dart
```

Feature providers are generated under:

```text
lib/src/features/<feature_name>/presentation/providers/
```

## Rules

- Feature providers extend `ChangeNotifier`.
- Feature providers are registered in `AppProviders`.
- `main.dart` should not manually list all providers.
- New feature providers should be added through the file generator.

## Example

```dart
MultiProvider(
  providers: AppProviders.providers,
  child: MaterialApp(...),
)
```

## AI Guidance

When creating a feature, do not manually edit `main.dart` to add a provider.

Use the file generator so the provider is registered in `app_providers.dart`.
