# Flutter Clean Architecture TDD Template

A public Flutter starter template for building scalable, testable mobile apps with Feature-Based Clean Architecture, TDD-friendly structure, and Codex-ready project documentation.

## Overview

This repository provides a ready-to-extend Flutter app foundation with clear boundaries between data, domain, and presentation layers. It includes local file generator tools, modular dependency injection, provider and route registries, and documentation that helps both humans and AI coding agents follow the same implementation rules.

## Main Features

- Feature-Based Clean Architecture
- TDD-friendly folder structure
- Bloc/Cubit-ready presentation layer
- Provider registry through `app_providers.dart`
- Route registry per feature
- Screen + View presentation pattern
- Modular GetIt dependency injection
- Local file generator tools for features and modules
- Codex-ready guidance through `AGENTS.md` and `docs/`

## Project Structure

```text
lib/
  main.dart
  src/
    core/
      modules/
      services/
        injection/
          injection_container.dart
          injectors/
        providers/app_providers.dart
        router/
          app_route.dart
          app_routes.dart
          router.dart
          registries/
      shared/
      utils/
    features/
      template/
        data/
        domain/
        presentation/
test/
  features/
assets/
docs/
tools/
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
- provider registry entry
- route registry entry
- dependency injection registry entry

Feature providers must be registered through `lib/src/core/services/providers/app_providers.dart`, not directly in `main.dart`. Routes must be registered through feature route registries, not switch-cases inside `router.dart`.

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

The delete command removes generated feature files and cleans related provider, route, and dependency injection registry entries. Inspect the cleanup afterward.

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
- provider registry
- dependency injection
- sample imports

Codex may suggest this cleanup when converting the repository into a real project, but must not delete `template` automatically unless explicitly requested.

## Verification Commands

```bash
flutter pub get
dart format .
flutter analyze
flutter test
flutter test --concurrency=4
```

CI runs dependency fetch, static analysis, and tests for pushes and pull requests to `master` and `develop`.

## Upcoming Features

Planned updates for this template:

- [x] **CI/CD Workflow** using GitHub Actions (Flutter analyze + test)
- [x] **AI Integration** using Codex
- [ ] Example implementation of a **core module** (e.g., error handling, app theme)
- [ ] Pre-configured **Firebase setup guide**
- [ ] Automation Deploy to **Play Store** or **App Store** with **Fastlane**  