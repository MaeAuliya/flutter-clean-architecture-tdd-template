# Dependency Rules

The import graph is the architecture. Directory names communicate intent; dependency direction enforces it.

---

## The rule

```text
presentation ─────▶ domain ◀───── data
      │                              │
      └────────▶ core ◀──────────────┘
```

- Presentation may depend on domain and core presentation utilities.
- Data may depend on domain and core infrastructure.
- Domain depends only on Dart and domain-safe core primitives.
- Domain never depends on presentation or data.
- Features never depend on another feature's data or presentation layer.

---

## Dependency matrix

| Source | May import | Must not import |
|---|---|---|
| `feature/presentation` | Same feature domain; shared UI; routing; state library | Data source; repository implementation; transport model; HTTP client |
| `feature/domain` | Domain-safe primitives; result type | Flutter widgets; state library; HTTP/storage SDKs; own data layer; other feature presentation/data |
| `feature/data` | Same feature domain; network/storage infrastructure | Presentation; another feature's implementation |
| `core/shared_ui` | Theme, small core utilities | Any product feature |
| `core/services` | Infrastructure packages and domain-safe interfaces | Product-feature presentation |
| `core/module/domain` | Domain-safe core only | Module data/presentation; product features |

---

## Domain purity

**Mandatory.** Domain code must not import Flutter UI packages, Dio, shared preferences, secure storage, Firebase, or any platform plugin.

Some Dart packages (for example equality or result types) may be acceptable in domain when they are implementation-neutral. The question is not "is this third party?" but "does this tie business policy to a delivery mechanism?"

A domain entity may import a small equality helper. It must not import a JSON annotation package if doing so makes the entity mirror a wire schema.

---

## Dependency inversion

Data needs to fulfill capabilities defined by domain:

```dart
// Domain owns the interface.
abstract interface class SessionRepository {
  ResultFuture<Session> restore();
}

// Data owns the implementation.
final class SessionRepositoryImpl implements SessionRepository {
  const SessionRepositoryImpl(this._storage);
  final SessionStorage _storage;
}
```

The interface belongs beside its consumers in domain, not beside its implementation in data. This makes the dependency point inward: data knows domain, while domain does not know data.

---

## Infrastructure abstraction threshold

Do not put an interface in front of every package by ritual. Add a project-owned abstraction when one or more are true:

- The package appears in domain-facing code and must be hidden
- More than one implementation exists or is expected
- Tests need a small fakeable seam
- Package-specific types would otherwise spread widely
- The integration needs project policy, such as redaction or retry

A logger is a strong candidate: a one-method `AppLogger` prevents the crash-reporting SDK from spreading through the project. A color object is not: wrapping `Color` adds no boundary.

---

## Cross-feature communication

### Preferred mechanisms

1. **Route arguments** for a one-time value handed to a destination
2. **Shared domain contract** for a reusable capability
3. **Application coordinator** for a multi-feature workflow
4. **Event stream** for truly decoupled global events, used sparingly

### Avoid

- Importing another feature's bloc to dispatch its events
- Reusing a feature's repository implementation
- Importing another feature's transport model because its fields happen to match
- A global service locator used ad hoc from widgets to reach any dependency

The dependency container is a composition tool, not a license to ignore boundaries. Composition-root files under `core/services/injection/` and `core/services/router/registries/` may import feature entry points to assemble dependencies and routes. Other core files must not import feature code.

---

## Shared entities

When two features need the same type, first determine ownership:

- If one feature owns the concept, the other should depend on a small contract or receive a value.
- If neither owns it and it is stable across domains, move it to a shared module.
- If the types merely look the same today but have different meanings, keep them separate.

Two `Address` types used for delivery and identity verification may diverge; merging them because the fields match today creates future coupling.

---

## Enforcement

Dart analyzer rules do not natively encode all architectural boundaries. Options as the project scales:

- Review checklist and automated import scan
- Custom lint rules
- Separate Dart packages for core and features, which makes dependencies explicit in manifests
- A dependency graph check in CI

**Preferred.** Start with review and a simple script. Move to package-level enforcement when violations recur or multiple teams contribute.

---

## Review questions

- Does domain import a delivery or platform package?
- Does presentation access data directly?
- Does a repository contract expose a DTO, database row, or untyped map?
- Does one feature import another feature's internals?
- Is the service locator called from deep inside widget code?
- Is a package-specific type crossing more layers than necessary?

A "yes" is not always a defect, but it always requires an explanation.

---

## Related documents

- [Architecture Overview](architecture_overview.md)
- [Project Structure and Boundaries](project_structure_and_boundaries.md)
- [Dependency Injection](../patterns/dependency_injection.md)
- [Data Mapping](../patterns/data_mapping.md)
- [Code Review Checklist](../quality/code_review_checklist.md)
