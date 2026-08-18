# Scalability Guidelines

Architecture should fit the project. Too little structure creates coupling; too much creates ceremony that the team works around. This guide identifies what to add at each scale and, equally importantly, what not to add yet.

Scale is determined by **independent complexity**, not screen count alone. Three screens with offline sync, background work, and conflict resolution can need more architecture than twenty read-only screens.

---

## Level 1 — Small

Typical shape: one to five screens, one contributor, simple local or read-only remote data, little business policy.

```text
lib/
  main.dart
  core/
    network/
    theme/
    shared_ui/
  features/
    [feature]/
      screen.dart
      controller.dart
      repository.dart
```

### Keep

- Feature-first organization
- One configured network client
- Typed error results at the data boundary
- Theme tokens and shared components
- Scoped state ownership
- Secure storage for any credential

### Simplify

- State holder may call a repository contract directly
- Model and entity may be the same immutable type when wire and domain shapes truly match
- Data source interface may be omitted; repository implementation wraps the client
- DI may be constructor injection assembled manually at the root

### Do not add yet

- A use case class that only forwards one argument to one repository method
- Empty `domain/entities`, `data/models`, or local-data-source folders
- A service locator for three dependencies
- Separate modules with one consumer

The standard is not "all three layers exist"; it is "dependency direction remains clear."

---

## Level 2 — Medium

Typical shape: several independent features, authenticated networking, local persistence, multiple contributors.

Use the full default structure:

```text
feature/
  data/datasources, models, repositories
  domain/entities, repositories, usecases
  presentation/state, screens, views, widgets
```

### Add

- DI container with one registration module per feature
- Use cases for meaningful operations
- Separate data and domain types where schemas diverge
- Central error translation
- Auth interceptor and coordinated token refresh
- Route-scoped state holders
- Unit tests at use case, repository, and state-holder levels
- Automated static analysis and test gate

This is the scale demonstrated by the reference implementation and is the default assumed by most pattern documents.

---

## Level 3 — Large

Typical shape: many teams or release trains, substantial offline behavior, several external integrations, frequent parallel work.

### Add deliberately

- Package-level modules so dependency boundaries are mechanically enforced
- Explicit public APIs per feature/package
- Dedicated application-coordination layer for cross-feature workflows
- Code-generated serialization when schema volume justifies it
- Structured cache policy and offline synchronization
- Integration test suites and test fixtures
- Dependency graph and architectural lint checks in CI
- Feature flags with lifecycle governance
- Observability conventions — event taxonomy, correlation IDs, redaction policy

### Watch for

- A central route file becoming a merge-conflict hotspot — move to feature route registration
- A single DI container file becoming a registry of the entire product — retain per-module injectors
- "Core" becoming a dumping ground — package boundaries help expose this
- Shared entities accumulating unrelated fields for every consumer

---

## Level 4 — Multi-application or platform

Typical shape: several applications share domain capabilities, UI foundations, or SDK integrations.

Extract stable capabilities into versioned Dart packages only after their API is evident from real consumers. A shared package adds release coordination and backward-compatibility obligations; it is not just a folder moved outward.

Candidates:

- Design system
- Network and observability foundation
- Authentication/session capability
- Domain SDK shared by applications
- Test utilities

Do not publish feature-internal models as a shared API. Once consumers compile against a type, changing it becomes a migration.

---

## Decision table

| Question | If yes | If no |
|---|---|---|
| Does the operation contain policy or coordination? | Add a use case | State holder may call repository contract |
| Do wire and domain shapes differ or evolve independently? | Separate model/entity and map | One immutable type may serve both |
| Is there local and remote data? | Data-source abstractions plus repository policy | One source can sit behind repository |
| Do multiple features consume the capability? | Consider shared module | Keep it feature-local |
| Are cross-feature import violations recurring? | Enforce package boundaries | Review convention may be enough |
| Do several state holders need the same state? | Promote to a higher owner | Keep route-local |
| Does configuration change without a release? | Remote config may be warranted | Build-time config is simpler |
| Is a new integration business-critical or security-sensitive? | Add interface, logging, failure policy, tests | Thin adapter may be enough |

---

## Signals that architecture is too heavy

- New features create more empty files than functional ones
- Most use cases are one-line forwards and never reused or tested
- Every concrete class has an interface with one implementation and no test fake
- Developers bypass layers because the approved route is too cumbersome
- A trivial UI change touches every layer

The answer is not to ignore the architecture. It is to remove boundaries that do not protect anything.

---

## Signals that architecture is too light

- Widgets make HTTP or storage calls
- Changing an endpoint shape breaks UI code
- State holders contain response parsing and database logic
- Tests require platform initialization to exercise domain policy
- Features import each other freely
- Every screen handles the same error differently
- A package replacement requires edits across most features

Add the boundary at the point of repeated pain, not everywhere at once.

---

## Migration strategy

Scale incrementally:

1. Add the new boundary for new work
2. Name the target pattern and the legacy one in documentation
3. Migrate touched code opportunistically only when risk is low
4. Create explicit migration work for broad changes
5. Remove the legacy path when no consumers remain

Do not leave two patterns both presented as current. "Mid-migration" is a valid state; "we do both" is not a standard.

---

## Related documents

- [Architecture Overview](architecture_overview.md)
- [Project Structure and Boundaries](project_structure_and_boundaries.md)
- [Documentation Governance](../foundation/documentation_governance.md)
- [Recommended Tech Stack](../reference/recommended_tech_stack.md)
