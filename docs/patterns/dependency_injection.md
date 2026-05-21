# Dependency Injection Pattern

This project uses GetIt with modular injector files.

## Structure

```text
lib/src/core/services/injection/
├── injection_container.dart
└── injectors/
    ├── core_injector.dart
    ├── template_injector.dart
    └── feature_name_injector.dart
```

## Rules

- Core dependencies must be registered in `CoreInjector`.
- Feature-specific dependencies must be registered in a feature injector.
- Module-specific dependencies must be registered in a module injector.
- Bloc/Cubit classes should use `registerFactory`.
- Use cases should use `registerLazySingleton`.
- Repository implementations should be registered by their interface.
- Data sources should be registered by their interface when possible.
- Do not place all dependencies in a single large injection file.

## Execution Rule

`CoreInjector` must run before other injectors.

After core dependencies are registered, other injectors may be executed in parallel as long as they only register dependencies and do not eagerly resolve dependencies during the injection phase.

## AI Guidance

When adding a new feature or module, use the file generator so the injector file and registry entry are created consistently.
