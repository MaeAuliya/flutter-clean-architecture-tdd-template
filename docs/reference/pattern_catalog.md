# Pattern Catalog

Central index of reusable implementation patterns. Add a row whenever a pattern document is introduced; remove or mark it Legacy when retired.

| Pattern | Problem solved | Status / applicability | Main dependencies | Trade-offs | Document |
|---|---|---|---|---|---|
| Layered feature architecture | Keeps UI, policy, and external mechanisms replaceable | **Mandatory direction; context-dependent layer count** | None | More files at medium scale | [Architecture Overview](../architecture/architecture_overview.md) |
| Modular dependency injection | Separates construction and enables substitution | **Preferred**; medium+ projects | DI container optional | Runtime registration errors; lifecycle discipline | [Dependency Injection](../patterns/dependency_injection.md) |
| Scoped state management | Predictable async/UI state and lifecycle | **Mandatory ownership; library context-dependent** | State library optional | State modeling overhead | [State Management](../patterns/state_management.md) |
| Central routing with typed arguments | Stable navigation contracts and route-scoped state | **Preferred** | Router/framework | Central table grows at scale | [Routing](../patterns/routing.md) |
| Configured network client | Consistent timeouts, auth, and request policy | **Mandatory for networked projects** | HTTP client | Interceptor complexity | [Networking](../patterns/networking.md) |
| Single-flight token refresh | Prevents refresh storms and inconsistent sessions | **Mandatory for refresh-token auth** | Secure storage, HTTP | Concurrency/replay complexity | [Authentication and Tokens](../patterns/authentication_and_tokens.md) |
| Typed error pipeline | Makes expected failure explicit and consistent | **Mandatory at boundaries** | Result/failure types | Mapping boilerplate | [Error Handling](../patterns/error_handling.md) |
| Model/entity mapping | Isolates external schemas from domain | **Preferred; mandatory when shapes diverge** | Serialization | Duplicate field definitions | [Data Mapping](../patterns/data_mapping.md) |
| Typed local/secure storage | Selects persistence by sensitivity and lifecycle | **Optional capability; mandatory sensitivity rules** | Platform storage packages | Migration and platform behavior | [Storage](../patterns/storage.md) |
| Build-time configuration | Separates environments and validates required values | **Mandatory for environment-varying projects** | Build system | Build command discipline | [Configuration](../patterns/configuration.md) |
| Remote configuration | Changes safe operational policy without release | **Optional** | Remote config provider | Staleness, validation, provider dependency | [Configuration](../patterns/configuration.md) |
| Startup gate | Makes prerequisites ordered, visible, retryable | **Preferred for nontrivial startup** | State management, config | Extra initial route/state machine | [Application Bootstrap](../patterns/app_bootstrap.md) |
| Theme-driven shared UI | Makes design, dark mode, accessibility consistent | **Mandatory theme consumption; shared layer preferred** | Flutter theme | Shared API governance | [Shared UI](../patterns/shared_ui.md) |
| Route-scoped form state | Separates input, validation, and async submission | **Preferred** | Notifier/state library | Coordination with submit state | [Forms and Validation](../patterns/forms_and_validation.md) |
| Permission capability | Centralizes platform status and rationale policy | **Optional** | Permission plugin | Platform/version differences | [Permissions and Device](../patterns/permissions_and_device.md) |
| Typed external intents | Safely converts push/deep links to navigation | **Optional** | Messaging/link SDK | Startup/lifecycle complexity | [Notifications and Deep Links](../patterns/notifications_and_deep_links.md) |
| Location/map/media gateway | Isolates native/plugin lifecycle and types | **Optional** | Platform SDKs | Battery, permissions, binary size | [Location, Maps, Media, Files](../patterns/location_maps_media.md) |
| Pagination generation guard | Prevents duplicate/stale incremental results | **Optional** | State/network | More state and cache invalidation | [Pagination and Caching](../patterns/pagination_and_caching.md) |
| Project-owned diagnostics | Vendor-neutral reporting with redaction | **Preferred; redaction mandatory** | Diagnostics SDK optional | Event taxonomy/retention | [Logging and Diagnostics](../patterns/logging_and_diagnostics.md) |
| Generated localization | Typed multi-language UI copy with persisted locale | **Preferred for multilingual apps** | Flutter localizations, intl, ARB | Resource maintenance and longer-copy layout testing | [Localization](../patterns/localization.md) |
| Certificate pinning | Restricts trust beyond system CAs | **Optional, threat-model dependent** | TLS/client, operational rotation | Outage/rotation risk | [Transport Security](../security/transport_security.md) |

## Status notes

- Optional does not mean low quality; it means do not adopt without the requirement.
- Preferred patterns are defaults, not inviolable laws.
- Mandatory rules are limited to boundaries with clear correctness or security consequences.
- Testing foundations exist in this template; consuming projects extend coverage by feature risk. See [Testing Strategy](../quality/testing_strategy.md).

## Adding a pattern

Follow [Documentation Governance](../foundation/documentation_governance.md): verify recurrence, choose the right home, classify honestly, include extension/testing/security guidance, then register and cross-link it here.
