# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A Flutter starter template (not a product): Feature-Based Clean Architecture, TDD-friendly, Bloc + Provider, GetIt DI, plus a local Dart code generator and a large agent-facing doc system under `docs/`.

## Commands

```bash
flutter pub get
flutter run --dart-define-from-file=env.json          # copy env.example.json first; env.json stays ignored
dart format .
flutter analyze
flutter test
flutter test --concurrency=4                      # what CI runs
flutter test test/features/template/domain/usecases/get_current_template_version_test.dart
flutter test --name "returns Failure"             # single test by name
```

CI (`.github/workflows/flutter-ci.yml`): `pub get` → `analyze` → `test --concurrency=4`, on push/PR to `master` and `develop`. Format check is commented out; run `dart format .` anyway.

### Generator (use it — do not hand-write boilerplate)

```bash
dart run tools/file_gen_main.dart feature <feature_name>
dart run tools/file_gen_main.dart module <module_name>
dart run tools/file_gen_main.dart delete feature <feature_name>
dart run tools/file_gen_main.dart delete module <module_name>
```

Names are lowercase snake_case. Feature generation also patches three registry files; module generation skips presentation. Always inspect generated files after create, and registry cleanup after delete.

## Architecture

Layers per feature under `lib/src/features/<feature>/`: `data/` (datasources, models, repositories impl) → `domain/` (entities, repository abstractions, usecases) → `presentation/` (bloc, providers, screens, views, widgets). Reusable cross-feature domain/data lives in `lib/src/core/modules/<module>/` (no presentation).

Error flow: datasources throw `Exception` subtypes (`core/errors/exception.dart`); repository impls catch and return `Left(Failure.fromException(e))`; everything above works on `ResultFuture<T> = Future<Either<Failure, T>>` (`core/utils/typedef.dart`, also `ResultStream`, `ResultVoid`, `DataMap`). Usecases extend one of the four bases in `core/usecases/` (`UseCaseWithParams`, `UseCaseWithoutParams`, and stream variants) and are callable objects.

Presentation split: `Screen` owns route name (`static const routeName`), lifecycle, listeners, and `Scaffold`; `View` owns the layout body. Bloc handles async/server state; route-scoped `ChangeNotifier` Provider handles ephemeral UI/data binding. Core `context_extension.dart` exposes only generic theme/media helpers. Feature-specific typed accessors belong in each feature's `presentation/extensions/` directory.

### Composition registries — never bypass them

Generated files contain `// GENERATED ... - DO NOT REMOVE` marker comments; the generator inserts and the deleter removes entries at those markers. Preserve them.

1. **Providers** — create mutable feature providers inside their route/flow registry. `core/services/providers/app_providers.dart` is only for intentionally app-lifetime state; never register feature state in `main.dart`.
2. **Routes** — each feature implements `FeatureRouteRegistry` under `core/services/router/registries/`, listed in `app_routes.dart::_registries`. `router.dart::generateRoute` only does a map lookup and falls back to `PageUnderConstruction`; no switch-cases there. Bloc/provider wrapping happens inside the registry.
3. **DI** — one `Injector` implementation per feature/module in `core/services/injection/injectors/`, listed in `InjectionContainer._injectors`. `CoreInjector` runs first (SharedPreferences, Dio, API, PackageInfo, gateways, logging) and holds shared deps only; feature injectors then run concurrently via `Future.wait`.

Bootstrap: `main.dart` → orientation lock → `InjectionContainer.init(sl)` → `MyApp` with `MultiProvider(AppProviders.providers)` + `onGenerateRoute: generateRoute`.

## Conventions

`flutter_lints` plus enforced `prefer_relative_imports` and `prefer_const_constructors`; formatter uses `trailing_commas: preserve`. Files `snake_case.dart`. Package imports only for third-party.

Tests mirror source paths, named `*_test.dart`, using `flutter_test` + `mocktail` + `bloc_test`. Priority order: usecases, repositories, datasources, models, Bloc behavior.

## Docs

`AGENTS.md` is the contributor/agent operating contract. `docs/README.md` is the map; `docs/foundation/ai_working_agreement.md` is the agent contract; `docs/patterns/` is the source of truth for implementation consistency; `docs/workflows/` are step-by-step task recipes; `docs/architecture/dependency_rules.md` defines permitted imports per layer. Docs classify every rule as Mandatory / Preferred / Optional / Context-dependent / Legacy — only Mandatory is a hard boundary. Update the relevant doc in the same change when architectural behavior changes.

Do not rename architecture folders, replace routing, or replace DI.

## The `template` feature

`lib/src/features/template/` is the live example (splash screen, initial route, version usecase, GitHub link). Initial route, route-scoped provider, route registry, DI, and feature context extension still point at it. Suggest `dart run tools/file_gen_main.dart delete feature template` when converting to a real product, but never delete it unasked or before those dependencies are replaced.
