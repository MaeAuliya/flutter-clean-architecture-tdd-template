# Project Structure and Boundaries

The directory tree communicates ownership. Use feature-first organization for product capabilities and reserve `core/` for infrastructure that is genuinely shared.

---

## Recommended structure

```text
lib/
├── main.dart
└── src/
    ├── core/
    │   ├── errors/
    │   ├── extensions/
    │   ├── modules/
    │   │   └── [shared_capability]/
    │   │       ├── data/
    │   │       ├── domain/
    │   │       └── presentation/      # only when capability has shared UI
    │   ├── services/
    │   │   ├── configuration/
    │   │   ├── injection/
    │   │   ├── logging/
    │   │   ├── network/
    │   │   ├── routing/
    │   │   └── storage/
    │   ├── shared/
    │   │   ├── widgets/
    │   │   ├── views/
    │   │   └── loading/
    │   ├── theme/
    │   ├── usecases/
    │   └── utils/
    └── features/
        └── [feature]/
            ├── data/
            │   ├── datasources/
            │   ├── models/
            │   └── repositories/
            ├── domain/
            │   ├── entities/
            │   ├── repositories/
            │   └── usecases/
            └── presentation/
                ├── state/
                ├── extensions/
                ├── screens/
                ├── views/
                └── widgets/
```

Use this as a direction, not a demand to create every folder. Empty directories and seven-line placeholder interfaces do not make architecture cleaner. Add a directory when it contains a real responsibility.

---

## Feature-first versus layer-first

Layer-first puts all blocs together, all repositories together, and all models together:

```text
lib/blocs/
lib/repositories/
lib/models/
```

This is workable for a small application. At scale it spreads a single change across the entire tree and makes ownership difficult.

Feature-first keeps the files that change together together:

```text
features/profile/
features/search/
features/checkout/
```

**Preferred.** Use feature-first organization once there are several independent capabilities or several contributors. A feature should be comprehensible without browsing unrelated features.

---

## What is a feature?

A feature is a cohesive user-facing capability. It usually:

- Has one or more screens or entry points
- Owns domain rules specific to that capability
- Can change substantially without forcing unrelated features to change
- Has a clear public boundary

A feature is **not** necessarily one screen. Creating one feature per route fragments cohesive workflows and creates artificial cross-feature imports. Group screens that participate in the same capability.

---

## What belongs in core?

Core owns infrastructure and primitives with broad, stable reuse:

- HTTP client configuration and interceptors
- Error/result types
- Dependency injection setup
- Routing infrastructure
- Logging and diagnostics
- Environment and remote configuration
- Secure and plain storage gateways
- Theme tokens and shared components
- Small extensions and formatters used broadly

**Mandatory.** Feature-specific policy must not migrate to `core/` merely because a second feature calls it. Before extracting, ask whether the concept is genuinely shared or whether one feature should expose a contract.

**Warning sign:** a core type named after a business workflow. Core should be reusable in an application from a different domain.

---

## Shared modules

A shared module is larger than a utility and smaller than a product feature. It owns a reusable capability with meaningful domain and data boundaries — for example media acquisition, permissions, location, or payment-method storage.

```text
core/modules/media/
  data/
    datasources/
    repositories/
  domain/
    entities/
    repositories/
    usecases/
```

A module may have presentation UI when that UI is itself shared — a permission rationale sheet, a common picker, a reusable verification flow.

**Preferred extraction test.** Create a shared module only when at least two features use the capability *and* moving it creates a coherent API. Do not extract a folder of unrelated helpers and call it a module.

---

## Presentation subfolders

The mature pattern in the reference implementation is useful and consistent:

| Folder | Responsibility |
|---|---|
| `screens/` | Routed pages: route name, route arguments, state-holder provisioning, page shell |
| `views/` | Large page sections or state-specific bodies; compose widgets, no route registration |
| `widgets/` | Small feature-local reusable elements |
| `state/` | Bloc/cubit/notifier/controller and its events/states |

A practical rule: if it can be navigated to, it is a screen. If it occupies most of a screen but cannot be navigated to independently, it is a view. If it is a small compositional unit, it is a widget.

Do not promote a feature-local widget to core until a second feature needs it and the API is stable.

---

## Public feature boundaries

Dart does not enforce directory-level visibility, so project discipline must.

A feature's externally usable surface should be small:

- Route definition or navigation function
- Route-argument type
- Deliberately shared domain contract, when necessary

Other features should not import its models, repository implementation, data sources, bloc states, or internal widgets.

If the project grows large enough, use barrel exports or Dart packages to make the public surface mechanically visible. See [Scalability Guidelines](scalability_guidelines.md).

---

## Cross-feature dependencies

Direct imports between features are a recurring source of coupling in mature codebases. Common examples include one feature reusing another's entity or widget because it was nearby.

**Mandatory.** No feature may depend on another feature's `data/` or `presentation/` directories.

**Preferred.** Avoid domain-to-domain feature imports too. When two features share a stable concept:

1. Name the shared capability
2. Move the smallest coherent set of entities/contracts to a shared module
3. Keep feature-specific operations in their original owners
4. Update DI so consumers depend on the shared contract

Do not move the entire source feature into core to silence an import warning.

---

## Naming the root

Some projects use `lib/src/`, some start directly under `lib/`. Either is fine. `src/` is useful when the package exposes a small public API from `lib/` and wants internals visually separated. In an application package with no external consumers, it is a convention rather than an access-control mechanism.

**Context-dependent.** Pick one at project creation and keep it consistent; the value lies in predictability, not the particular spelling.

---

## Related documents

- [Architecture Overview](architecture_overview.md)
- [Dependency Rules](dependency_rules.md)
- [Scalability Guidelines](scalability_guidelines.md)
- [Adding a Feature](../workflows/adding_feature.md)
- [Shared UI](../patterns/shared_ui.md)
