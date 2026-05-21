# Testing Pattern

This project follows TDD-friendly Clean Architecture.

## Test Structure

Tests should mirror the source structure.

```text
test/
├── core/
└── features/
    └── feature_name/
        ├── data/
        ├── domain/
        └── presentation/
```

## Recommended Test Targets

Prioritize tests for:

- Use cases
- Repositories
- Data sources
- Models
- Bloc/Cubit behavior

## Commands

Run all tests:

```bash
flutter test
```

Run static analysis:

```bash
flutter analyze
```

Format code:

```bash
dart format .
```

## AI Guidance

AI agents should add or update tests when changing business logic.

For UI-only template files, tests may be deferred unless the change affects behavior.
