# Template Next Steps

Known gaps between what this documentation prescribes and what the template currently implements. Each item names the rule it is measured against, so you can judge whether it matters for your project before acting on it.

This is a list for the template's own maintenance. When you adopt the template for a real product, most of these become your decisions rather than defects — but the security item is worth resolving either way.

---

## High priority

### Token key invites plain-preference credential storage

**Rule:** [Storage](../patterns/storage.md) — Mandatory. Never place tokens, passwords, private keys, or sensitive identity data in plain preferences.

`core/utils/preference_keys.dart` declares an `// Authentication` section with a `kToken` key, and its own doc comment demonstrates writing a token through it. Only `SharedPreferences` is registered; there is no encrypted storage dependency or gateway. Nothing in the template actually stores a token today, so this is a shipped invitation rather than a live leak — but it is the one item here with a security consequence.

**Resolve by** either removing `kToken` from the plain-preference key registry, or adding a `SecureSessionStorage` gateway and pointing the key at it.

### Central transport translation has no production call site

**Rule:** [Error Handling](../patterns/error_handling.md) — Mandatory. Do not reimplement the transport switch in each data source.

`core/services/network/transport_exception_mapper.dart` is complete and tested, but nothing in `lib/` calls it. The template's one remote data source catches broadly instead and throws a `ServerException.rejected`, which also contradicts the rule against catching every `Object`. The generator's remote data source template does not reference the mapper either, so every generated feature starts out bypassing it.

**Resolve by** routing the remote data source's `DioException` through `TransportExceptionMapper.throwMapped`, and adding the same to the generator template.

### Models do not parse, and there is no malformed-response kind

**Rule:** [Data Mapping](../patterns/data_mapping.md) — Mandatory. Parsing validates required fields and reports a typed malformed-response error.

`TemplateVersionModel` has no `fromMap`/`toMap` — only `.empty()` and `.fromEntity()`. `ServerExceptionKind` has no `malformedResponse` variant, and there is no `requireMap`-style validator anywhere. The generator's model template emits a field-less class, so generated features inherit the gap.

**Resolve by** adding the kind, a shared payload validator, and real `fromMap`/`toEntity` in both the template model and the generator template.

---

## Medium priority

### No typed route argument mechanism

**Rule:** [Routing](../patterns/routing.md) — Mandatory for multi-field or semantically important arguments.

`AppRoute` carries only `name` and `builder`. There is no args type, no `requireArgs<T>` helper, and no use of `settings.arguments` anywhere. An unknown or malformed route silently renders `PageUnderConstruction` rather than failing visibly. The template's one feature takes no arguments, so nothing is broken — the mechanism simply does not exist yet.

### One build-time key escapes validation

**Rule:** [Configuration](../patterns/configuration.md) — Mandatory. Validate required keys before application startup.

`API.validate()` correctly checks `BASE_URL` for presence and HTTPS shape, and `CoreInjector` calls it first. But `ExampleAPI.example` reads `EXAMPLE` from the environment and is not included in `missingKeys()`, so a missing value becomes an empty string — the exact failure mode [Networking](../patterns/networking.md) labels a Legacy anti-pattern.

### Endpoint literal outside the endpoint owner

**Rule:** [Networking](../patterns/networking.md) — one owner, no literals in data-source methods.

The template's remote data source reads its URL from `core/utils/constants.dart`, a general constants bag, rather than from `core/services/api/api.dart`, which is the documented endpoint owner and is currently unused.

### Localization is documented but not wired

**Rule:** [Localization](../patterns/localization.md) — Preferred for multi-locale applications.

There is no `lib/l10n/`, no `l10n.yaml`, no `.arb` file, and `pubspec.yaml` declares `intl` but not `flutter_localizations`. User-facing copy lives in `core/res/texts.dart`, and `core/utils/validator.dart` returns final English strings from it — which means domain-adjacent validation owns display text. The pattern document now says plainly that it is not wired; actually adopting it is a separate piece of work.

### Dead registrations and unused primitives

**Rule:** [Dependency Injection](../patterns/dependency_injection.md) — a registration with no consumer reads as a live capability; [Dart and Flutter Style](../conventions/dart_flutter_style.md) — delete stale code.

Registered or declared but never used: the `Dio` client, `API`/`ExampleAPI`, `APIHeaders` (which hand-attaches `Authorization` headers, the approach [Authentication and Tokens](../patterns/authentication_and_tokens.md) explicitly rejects), `DataMap`, `ResultStream` and the two stream use case base types, `PreferenceKeys.kExample`, and `StatusEnums` in `core/enums/`.

`StatusEnums` is worth a second look on its own: it is a static helper class in `core/` that imports `Colours` and returns `Color`, which is the presentation-facing-enum-in-core shape that [Dart and Flutter Style](../conventions/dart_flutter_style.md) forbids.

---

## Generator

The generator is how features get created, so a gap here propagates into every future feature. See [Adding a Feature](../workflows/adding_feature.md).

- **Emits by ritual rather than need.** Every feature gets a local data source and stub, an empty `presentation/widgets/` directory, two pass-through use cases, and a `ChangeNotifier` provider — regardless of whether the feature uses them. This contradicts [Architecture Overview](../architecture/architecture_overview.md), [Storage](../patterns/storage.md), and the Legacy rule against folders generated for symmetry. The repository implementation template *requires* the local source, so removing it means changing three templates together.
- **No `Empty` state.** The bloc state template emits Initial/Loading/GetSuccess/UpdateSuccess/Error. [Adding a Feature](../workflows/adding_feature.md) requires an empty state, and [Definition of Done](../quality/definition_of_done.md) checks for one.
- **States are not sealed.** The template emits `abstract class ... extends Equatable`, so the generated screen must write `case _:` — which [State Management](../patterns/state_management.md) permits only for open hierarchies, not for a closed set the listener owns.
- **Entity carries an `Entity` suffix**, against the naming table in [Dart and Flutter Style](../conventions/dart_flutter_style.md).
- **Tests are partial.** Domain, data, and bloc tests are generated; model parsing, critical widget states, and the DI resolution smoke test are not, though [Testing Strategy](../quality/testing_strategy.md) and [Dependency Injection](../patterns/dependency_injection.md) call for them.
- **Repository update takes a raw entity** rather than a `...Params` type ([Data Mapping](../patterns/data_mapping.md), Preferred).
- **Generated screens import `CoreUtils`** for snackbars, propagating the `Utils`-grab-bag shape that [Dart and Flutter Style](../conventions/dart_flutter_style.md) marks Legacy.
- **A stray `// ponytail:` marker** appears in two data source templates — an ownerless deferral comment, and most likely a corrupted `TODO:`.
- **The app-provider marker is dead.** `core/services/providers/app_providers.dart` carries a `// GENERATED APP PROVIDERS - DO NOT REMOVE` marker, but no generator path writes to it. Either wire it or document it as a manual insertion point.

---

## Lower priority, context-dependent

### Composition root versus the layering matrix

The route registries and DI injectors under `core/services/` import feature presentation by design — that is what a composition root does. [Dependency Rules](../architecture/dependency_rules.md) now states the carve-out explicitly, so the documentation and the code agree. The open question is placement: a dedicated `lib/src/app/` composition layer would need no exemption at all. Changing it would move files the generator writes to, so it is a deliberate decision rather than a cleanup.

### No ADRs recorded

[Architecture Decision Records](../decisions/README.md) lists the decisions worth recording; `docs/decisions/` contains only its README. This template has already frozen several — Bloc plus Provider, GetIt, `dartz` `Either` as the result type, relative imports, the `lib/src/` layout, the registry-based router. None are written down, so a consuming project inherits them without their reasoning.

### Bootstrap has no failure states

[Application Bootstrap](../patterns/app_bootstrap.md) describes a bootstrap state machine with offline, update-required, maintenance, and retry states. The splash screen fires one event and navigates on success. There is no error path, which the same document calls out: a blank splash is never an acceptable failure state.

### No global error boundary

[Logging and Diagnostics](../patterns/logging_and_diagnostics.md) asks for `FlutterError.onError` and `PlatformDispatcher.instance.onError` wired before startup. Neither appears in `main.dart`.

### Navigator key is a bare global

[Routing](../patterns/routing.md) prefers a `NavigationService` over an exposed global key. `main.dart` declares `navigatorKey` as a top-level final.

### Shared button has eleven nullable overrides

[Shared UI](../patterns/shared_ui.md) prefers explicit variants over many independent style overrides. `CoreButton` takes 17 constructor parameters including two independent booleans and no variant or size enum. `ErrorView` already uses the variant shape and is the model to follow.

---

## Related documents

- [Testing Strategy](../quality/testing_strategy.md)
- [Shared UI](../patterns/shared_ui.md)
- [Authentication and Tokens](../patterns/authentication_and_tokens.md)
- [Project Structure and Boundaries](../architecture/project_structure_and_boundaries.md)
