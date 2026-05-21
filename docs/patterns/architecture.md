# Architecture Pattern

This project uses Feature-Based Clean Architecture.

## Main Structure

```text
lib/src/
├── core/
│   ├── modules/
│   ├── services/
│   ├── shared/
│   └── utils/
└── features/
    └── feature_name/
        ├── data/
        ├── domain/
        └── presentation/
```

## Layer Rules

### Domain Layer

The domain layer contains:

- Entities
- Repository contracts
- Use cases

The domain layer must not depend on Flutter UI, external SDKs, API clients, or local storage implementations.

### Data Layer

The data layer contains:

- Models
- Data sources
- Repository implementations

The data layer implements repository contracts from the domain layer.

### Presentation Layer

The presentation layer contains:

- Bloc/Cubit
- Providers
- Screens
- Views
- Widgets

Screens should act as route-level wrappers. Views should contain the main UI composition.

## AI Guidance

When creating a new feature, use the file generator first.

Do not manually create boilerplate files unless the generator does not support the requested structure.
