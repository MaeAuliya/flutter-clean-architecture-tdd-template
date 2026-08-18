# Flutter Clean Architecture TDD Template

[![Flutter](https://img.shields.io/badge/Flutter-3.35.xx-blue?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.9.xx-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

A public Flutter starter template for building scalable, testable mobile apps with Feature-Based Clean Architecture, TDD-friendly structure, and Codex-ready project documentation.

## Overview

This repository provides a ready-to-extend Flutter app foundation with clear boundaries between data, domain, and presentation layers. It includes local file generator tools, modular dependency injection, route-scoped feature providers, route registries, and documentation that helps both humans and AI coding agents follow the same implementation rules.

## Main Features

- Feature-Based Clean Architecture
- TDD-friendly folder structure
- Bloc-based presentation layer
- Route-scoped feature providers; `app_providers.dart` only for app-lifetime state
- Route registry per feature
- Screen + View presentation pattern
- Modular GetIt dependency injection
- Local file generator tools for features and modules
- Codex-ready guidance through `AGENTS.md` and `docs/`

## Tech Stack
### Framework & Language
- Flutter **3.35.xx**
- Dart **3.9.xx**

### Architecture & State Management
- [Bloc](https://pub.dev/packages/flutter_bloc) – primary state management
- [Flutter Bloc](https://pub.dev/packages/flutter_bloc) - Flutter widgets that make it easy to integrate blocs
- [Provider](https://pub.dev/packages/provider) – data binding
- [getIt](https://pub.dev/packages/get_it) – dependency injection
- [Equatable](https://pub.dev/packages/equatable) – value equality
- [Dartz](https://pub.dev/packages/dartz) - Either Success or Failure Handler

### Data & API
- [Dio](https://pub.dev/packages/dio) – HTTP client
- [Shared Preferences](https://pub.dev/packages/shared_preferences) – key-value storage

### Configuration

`BASE_URL` is required at startup. `EXAMPLE` is an optional sample endpoint value. Keep real values in ignored `env.json`; commit placeholders only in `env.example.json`.

### Utilities
- [flutter_svg](https://pub.dev/packages/flutter_svg) – SVG rendering
- [lottie](https://pub.dev/packages/lottie) – animations
- [url_launcher](https://pub.dev/packages/url_launcher) – external URL launcher
- [package_info_plus](https://pub.dev/packages/package_info_plus) – app versioning

### Testing
- [flutter_test](https://api.flutter.dev/flutter/flutter_test/flutter_test-library.html) – unit testing
- [mocktail](https://pub.dev/packages/mocktail) – mocking
- [bloc_test](https://pub.dev/packages/bloc_test) – bloc testing utilities

## Project Structure

```text
project_root/
│
├── android/                # Native Android project
├── ios/                    # Native iOS project
├── assets/
│   ├── animations/         # Lottie animations
│   ├── fonts/              # Custom fonts
│   ├── icons/              # App icons
│   ├── images/             # PNG/JPG images
│   └── vectors/            # SVG vector files
│
├── lib/
│   └── main.dart           # Main Program
│   └── src/
│       ├── core/                   
│       │   ├── enums/              # App-wide enumerations
│       │   ├── errors/             # Error handling & exceptions
│       │   ├── extensions/         # Dart extensions
│       │   ├── res/                # Resources (colors, typography, etc.)
│       │   ├── services/           # External services (API, Firebase, etc.)
│       │   ├── shared/             # Shared widgets/components
│       │   ├── usecases/           # Contract Abstraction for usecase pattern
│       │   ├── utils/              # Utility helpers
│       │   └── modules/            # Reusable domain/data modules
│       │
│       └── features/
│           └── feature_a/
│               ├── data/
│               │   ├── datasources/
│               │   │   ├── feature_a_remote_data_source.dart
│               │   │   └── feature_a_local_data_source.dart
│               │   ├── models/
│               │   │   └── feature_a_model.dart
│               │   └── repositories/
│               │       └── feature_a_repository_impl.dart
│               │
│               ├── domain/
│               │   ├── entities/
│               │   │   └── feature_a_entity.dart
│               │   ├── repositories/
│               │   │   └── feature_a_repository.dart
│               │   └── usecases/
│               │       └── get_feature_a_items.dart
│               │
│               └── presentation/
│                   ├── bloc/
│                   │   ├── feature_a_bloc.dart
│                   │   ├── feature_a_event.dart
│                   │   └── feature_a_state.dart
│                   ├── providers/
│                   │   └── feature_a_provider.dart
│                   ├── screens/
│                   │   └── feature_a_screen.dart
│                   ├── views/
│                   │   └── feature_a_list_view.dart
│                   └── widgets/
│                       └── feature_a_card.dart
│
├── test/
│   ├── core/
│   │   ├── errors/
│   │   ├── services/
│   │   └── shared/
│   │
│   └── features/
│       └── feature_a/
│           ├── data/
│           │   ├── datasources/
│           │   │   └── feature_a_remote_data_source_test.dart
│           │   ├── models/
│           │   │   └── feature_a_model_test.dart
│           │   └── repositories/
│           │       └── feature_a_repository_impl_test.dart
│           │
│           ├── domain/
│           │   ├── entities/
│           │   │   └── feature_a_entity_test.dart
│           │   ├── repositories/
│           │   │   └── feature_a_repository_test.dart
│           │   └── usecases/
│           │       └── get_feature_a_items_test.dart
│           │
│           └── presentation/
│               └── bloc/
│                   └── feature_a_bloc_test.dart
│
└── pubspec.yaml
```

Features live in `lib/src/features/<feature_name>/` and are split into `data`, `domain`, and `presentation`. Reusable modules live under `lib/src/core/modules/<module_name>`. Tests should mirror the source structure.

## Codex-ready Workflow

Before planning, coding, or reviewing, Codex must read `AGENTS.md` and the relevant files under `docs/`. Codex should use the local generator for supported feature/module changes, inspect generated files after creation, and inspect registry cleanup after deletion.

## Documentation System

- `AGENTS.md`: contributor and Codex operating rules.
- `docs/README.md`: documentation map.
- `docs/patterns/`: source of truth for implementation consistency.
- `docs/product/`: product placeholders to update when this template becomes a real app.
- `docs/TODO/next_steps.md`: roadmap ideas and future improvements.

## File Generator Tools

The generator creates and deletes Clean Architecture boilerplate consistently. Use lowercase snake case names, for example `user_profile` or `local_storage`.

## Creating a Feature

```bash
dart run tools/file_gen_main.dart feature <feature_name>
```

A generated feature includes:

- data layer
- domain layer
- presentation layer
- provider
- screen
- view
- injector
- route registry
- route registry entry
- dependency injection registry entry
- mirrored unit/Bloc test skeletons and `.mock.dart` doubles

Feature providers are created inside their feature route registry so state ends with the route. `lib/src/core/services/providers/app_providers.dart` is reserved for app-lifetime state such as session, theme, locale, or connectivity. Routes must be registered through feature route registries, not switch-cases inside `router.dart`.

## Creating a Module

```bash
dart run tools/file_gen_main.dart module <module_name>
```

Generated modules are placed under:

```text
lib/src/core/modules/<module_name>
```

Modules are reusable core structures and do not include presentation layer files.

## Deleting a Feature

```bash
dart run tools/file_gen_main.dart delete feature <feature_name>
```

The delete command removes generated feature/tests and cleans related route and dependency injection registry entries. Inspect the cleanup afterward.

## Deleting a Module

```bash
dart run tools/file_gen_main.dart delete module <module_name>
```

The delete command removes generated module files and related registry entries when applicable. Inspect the cleanup afterward.

## Turning This Template Into a Real Project

Update `docs/product/` with the product vision, target users, information architecture, user flows, design direction, and visual system. Replace template copy, app naming, routes, providers, and initial feature setup as needed.

When this template is used for a real product, the example `template` feature may be removed after the real initial feature, route, provider, and dependency setup are ready.

Suggested command:

```bash
dart run tools/file_gen_main.dart delete feature template
```

Do not delete the `template` feature before replacing app dependencies that still point to it, such as:

- initial route
- splash screen
- route registry
- route-scoped provider
- dependency injection
- sample imports

Codex may suggest this cleanup when converting the repository into a real project, but must not delete `template` automatically unless explicitly requested.

## Run and Verification Commands

Copy placeholder configuration before running locally, then replace only values needed by your app. `env.json` stays ignored.

```bash
cp env.example.json env.json
flutter pub get
flutter run --dart-define-from-file=env.json
dart format .
flutter analyze
flutter test
flutter test --concurrency=4
```

CI runs dependency fetch, feature/module generator round-trip validation, static analysis, and tests for pushes and pull requests to `master` and `develop`.

## Upcoming Features

Planned updates for this template:

- [x] **CI/CD Workflow** using GitHub Actions (generator round-trip + Flutter analyze + test)
- [x] **AI Integration** using Codex
- [x] Add **File generator** tools for creating features or modules
- [ ] Example implementation of a **core module** (e.g., error handling, app theme)
- [ ] Pre-configured **Firebase setup guide**
- [ ] Automation Deploy to **Play Store** or **App Store** with **Fastlane**  
