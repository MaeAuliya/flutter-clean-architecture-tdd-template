# Repository Guidelines

## Required Agent Workflow

Codex must read `AGENTS.md` and all relevant files in `docs/` before planning, coding, or reviewing changes. `docs/patterns/` is the source of truth for implementation consistency. `docs/product/` contains product placeholders and should be updated when this template is used for a real product.

Do not rename architecture folders, replace routing, replace dependency injection, or overwrite unrelated local changes.

## Project Structure

- `lib/main.dart`: app entry point.
- `lib/src/core/`: shared services, routing, injection, modules, widgets, resources, errors, and utilities.
- `lib/src/features/<feature>/`: feature-based Clean Architecture with `data/`, `domain/`, and `presentation/`.
- `test/`: tests mirroring source structure.
- `assets/`: fonts, icons, images, vectors, and animations.
- `tools/`: local feature/module generators.
- `docs/`: Codex-ready architecture, product, and roadmap documentation.

## File Generator Rules

Codex must use the local generator when creating or deleting features/modules. Do not manually create Clean Architecture boilerplate if the generator supports the requested structure. After running a generator, inspect generated files. After deleting a feature or module, inspect registry cleanup.

Create a feature:

```bash
dart run tools/file_gen_main.dart feature <feature_name>
```

Create a module:

```bash
dart run tools/file_gen_main.dart module <module_name>
```

Delete a feature:

```bash
dart run tools/file_gen_main.dart delete feature <feature_name>
```

Delete a module:

```bash
dart run tools/file_gen_main.dart delete module <module_name>
```

The feature generator creates feature files, provider, screen, view, injector, route registry, provider registry entry, route registry entry, and dependency injection registry entry. The module generator creates reusable module structure under `lib/src/core/modules/` and does not create presentation files.

## Implementation Rules

Feature providers must be registered through `lib/src/core/services/providers/app_providers.dart`, not directly inside `main.dart`. Routes must be registered through feature route registries, not switch-cases inside `router.dart`. Dependency injection must use modular injector files under `lib/src/core/services/injection/injectors/`; core shared dependencies stay inside `CoreInjector`.

Use lowercase snake case generator names, for example `user_profile` or `local_storage`. Follow `flutter_lints` and `analysis_options.yaml`: prefer relative imports, `const` constructors, preserved trailing commas, and `snake_case.dart` file names.

## Real Project Cleanup

When this template is used for a real product, the example `template` feature may be removed after the real initial feature, route, provider, and dependency setup are ready.

Suggested command:

```bash
dart run tools/file_gen_main.dart delete feature template
```

Do not delete `template` before replacing app dependencies that still point to it, such as initial route, splash screen, route registry, provider registry, dependency injection, and sample imports. Codex may suggest this cleanup during product conversion but must not delete `template` automatically unless explicitly requested.

## Commands and Reviews

Use `flutter pub get`, `flutter run`, `dart format .`, `flutter analyze`, and `flutter test` for normal development. CI runs dependency fetch, analysis, and tests for pushes and PRs to `master` and `develop`.

Tests use `flutter_test`, `mocktail`, and `bloc_test`. Name tests `_test.dart`, mirror source structure, and prioritize use cases, repositories, data sources, models, and Bloc/Cubit behavior. PRs need a summary, linked issues when relevant, UI screenshots, and analysis/test results.
