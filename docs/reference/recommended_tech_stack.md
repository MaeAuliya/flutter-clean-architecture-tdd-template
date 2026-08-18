# Recommended Technology Stack

A capability reference, not a package advertisement. Select the smallest stack that meets project requirements; evaluate current package health at adoption time rather than copying versions from a template.

## Core stack

| Category | Recommended approach | Observed implementation category | Alternatives / selection criteria |
|---|---|---|---|
| UI | Flutter Material 3 with semantic `ColorScheme` and project components | Framework theme + token classes | Cupertino/adaptive component layer where platform fidelity is primary |
| State | Event/method-driven immutable state holder, route-scoped | Bloc plus provider/notifier | Riverpod, ValueNotifier, other reactive libraries; choose team fit and lifecycle clarity |
| DI | Constructor injection; modular composition root | GetIt with per-feature injectors | Manual root composition for small apps; provider-based DI; compile-time DI at large scale |
| Networking | One configured client, interceptors, explicit timeouts | Dio-style client | Standard HTTP client or generated API client; require cancellation, interceptors, testability |
| Results | Typed success/failure return | Functional `Either` | Sealed project-owned `Result`; choose readability over functional novelty |
| Equality | Immutable value equality | Equality helper package | Generated immutable models or native equality methods |
| Persistence | Typed gateway selected by sensitivity/query needs | Preferences + encrypted storage + file cache | Embedded SQL/key-value databases for structured/offline data |
| Testing | Framework tests, state-library utilities, fakes/mocks | Test framework plus mock and bloc-test packages declared | Prefer fakes for stable small contracts |
| Configuration | Build-time definitions + typed accessor | Compile-time environment values | Flavors when native identity/config differs |

## Optional integration stack

| Capability | Approach | Adopt when | Avoid when |
|---|---|---|---|
| Remote configuration | Provider SDK behind typed service, safe defaults | Operational flags/minimum version/pin rotation change without release | Values are fixed per binary or claimed secret |
| Push notifications | Messaging SDK + local display + typed intent parser | Timely external events are required | Polling/local reminders suffice |
| Crash diagnostics | SDK behind `AppLogger` with redaction | Production diagnostics justify data collection | Project policy prohibits third-party reporting |
| Analytics | Typed event gateway and controlled taxonomy | Product decisions require measured behavior | Events have no owner/purpose or consent basis |
| Maps | Map SDK behind map presentation module | Interactive maps/annotations required | Static image or external map launch suffices |
| Geolocation | Platform gateway + permission capability | Feature genuinely needs current/background location | Approximate/manual location suffices |
| Camera/media | Platform camera/picker + image processor | Custom capture/quality/preview workflow | Simple system picker meets requirements |
| Permissions | Platform permission adapter with domain statuses | Any protected device capability | Capability requires no runtime permission |
| Biometrics | Local-auth adapter | Convenient re-auth/local unlock is justified | Treated as server authorization replacement |
| Device integrity | Integrity adapter + remote enforcement | Threat model justifies false-positive/support cost | Added as generic security theater |
| Deep links | Link SDK/platform API + typed parser | External entry routes required | No external route contract |
| URL/file launch | Narrow gateway | Opening external apps/files | Package types would be used only once and safely |
| Payments | Provider SDK behind capability module | Payment flow required | Never add speculatively |

## Serialization and generation

**Handwritten mapping** is recommended for modest model count and custom validation. **Generated serialization** becomes useful when DTO volume creates repetitive defects. Generation introduces build steps, version coupling, generated output policy, and migration work; record the choice.

A project scaffold generator is useful when it creates the entire working skeleton *and* states/automates registration. A generator that emits empty local sources and leaves DI commented out accelerates inconsistency rather than development.

## Package selection criteria

For every major package assess:

1. Maintenance and recent releases
2. Issue response and migration quality
3. Supported Flutter/Dart and native platform ranges
4. License
5. Transitive dependencies and binary impact
6. Security/privacy and network behavior
7. API surface spread — can it be wrapped?
8. Testability
9. Exit/replacement cost
10. Existing team knowledge

Use the selection criteria above, the evaluation form in [Decision and Project Documentation Templates](../templates/decision_and_product_docs.md), and the [Adding an Integration](../workflows/adding_integration.md) workflow.

## What is intentionally not fixed here

- Exact dependency versions
- One universal state-management package
- One router package
- A local database when none is required
- Code generation by default
- Optional platform SDKs

A reusable template should preserve decisions, not freeze an ecosystem snapshot.

## Related documents

- [Pattern Catalog](pattern_catalog.md)
- [Scalability Guidelines](../architecture/scalability_guidelines.md)
- [Project Bootstrap](../foundation/project_bootstrap.md)
