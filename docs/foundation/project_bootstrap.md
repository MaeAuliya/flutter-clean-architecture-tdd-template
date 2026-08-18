# Project Bootstrap

How to start a new project from this template. The goal is a working skeleton with the infrastructure decisions already made, so feature work can begin without re-litigating structure.

**Scale first.** Not every project needs every layer. Read [Scalability Guidelines](../architecture/scalability_guidelines.md) before adopting the full structure — a three-screen utility application saddled with the complete layered architecture will be slower to build and no more correct.

---

## Phase 1 — Skeleton

**Create the project and set the package name.** The package identifier is expensive to change once published; choose it deliberately.

**Establish the directory structure.** See [Project Structure and Boundaries](../architecture/project_structure_and_boundaries.md). At minimum:

```text
lib/
  main.dart
  src/
    core/          # shared infrastructure and cross-cutting capabilities
    features/      # feature slices
```

**Configure static analysis.** Enable the standard lint set for the framework, then add project rules. Two worth adopting immediately, because retrofitting them later means touching every file:

- Enforce a single import style project-wide (relative or absolute — pick one).
- Require const constructors where possible.

See [Dart and Flutter Style](../conventions/dart_flutter_style.md).

**Set up version control hygiene.** Ignore build output, generated files, IDE state, and — critically — every environment and secret file. See [Secure Coding and Credential Handling](../security/secure_coding_and_credentials.md).

---

## Phase 2 — Configuration and environments

Decide how build-time configuration enters the application before writing code that needs it. See [Environment Configuration](../patterns/configuration.md).

Establish at this stage:

- The environment mechanism (build-time definitions, flavors, or both)
- One configuration accessor type rather than scattered lookups
- An environment file per target, all excluded from version control
- A committed example file listing required keys with placeholder values

**The example file matters more than it appears.** It is the only thing telling the next contributor — or an agent — which keys are required. Without it, a missing key surfaces as a silent runtime failure.

---

## Phase 3 — Core infrastructure

Build these before the first feature. Each is documented separately.

| Concern | Document | Notes |
|---|---|---|
| Dependency injection | [Dependency Injection](../patterns/dependency_injection.md) | Container plus one registration module per feature |
| Result and failure types | [Error Handling](../patterns/error_handling.md) | Define before any repository |
| Use case contracts | [Architecture Overview](../architecture/architecture_overview.md) | Small base abstractions |
| HTTP client | [Networking](../patterns/networking.md) | One configured instance, timeouts set |
| Transport error translation | [Error Handling](../patterns/error_handling.md) | Single conversion point |
| Endpoint declarations | [Networking](../patterns/networking.md) | Grouped, not scattered as literals |
| Logging | [Logging and Diagnostics](../patterns/logging_and_diagnostics.md) | Interface first, implementation behind it |
| Navigation | [Routing](../patterns/routing.md) | Route table and a navigator handle |
| Theme and tokens | [Shared UI](../patterns/shared_ui.md) | Full light and dark schemes from the start |
| Shared components | [Shared UI](../patterns/shared_ui.md) | Button, input, app bar, loading, empty, error |

**Define the theme fully before building screens.** Retrofitting dark mode after feature code has hardcoded its colors is one of the most expensive corrections available, and one the reference implementation demonstrates clearly: it has a complete dark scheme that feature code largely bypasses. Establishing the habit early costs nothing; reversing it later costs a sweep of every widget.

---

## Phase 4 — Session and authentication

Only if the project has authenticated users.

1. Encrypted storage for credentials — never plain key-value storage. See [Local and Secure Storage](../patterns/storage.md).
2. A session holder owning tokens and their lifecycle. See [Session Security](../security/session_security.md).
3. An interceptor attaching credentials to outgoing requests.
4. Token refresh with single-flight coordination. See [Authentication and Token Management](../patterns/authentication_and_tokens.md).
5. **One** defined path for unrecoverable session expiry — one place that decides, one place that navigates.

Point 5 is worth insisting on. When expiry handling is duplicated across state holders, the copies drift and behavior becomes unpredictable. Decide the mechanism now and route every case through it.

---

## Phase 5 — Startup sequence

Determine what must succeed before the first screen renders, and what may fail without blocking. See [Application Bootstrap](../patterns/app_bootstrap.md).

Typical ordering:

```text
1. Framework binding initialization
2. Platform services (crash reporting, configuration)
3. Dependency registration
4. Configuration load — with a compiled-in fallback if it fails
5. Session restore
6. Run application
7. Gated startup checks (connectivity, minimum version, maintenance, device integrity)
```

For each dependency, decide explicitly: **fatal or recoverable?** Recoverable failures need a fallback and a log entry. Silent failure is not an option.

---

## Phase 6 — First feature

Build one feature end to end before building several. The first is where the conventions get settled and the friction gets found — and it is far cheaper to adjust the pattern once than to correct it across five features.

Follow [Adding a Feature](../workflows/adding_feature.md). Then review honestly: was anything awkward? Fix the pattern now.

---

## Phase 7 — Quality gate

Establish the gate before the codebase grows. Retrofitting tests onto an established codebase is substantially harder than writing them alongside. This template starts with CI plus focused unit, Bloc, repository, mapper, data-source, API, and shared-widget tests; consuming projects must keep extending them with behavior.

- Static analysis clean, enforced
- Test structure mirroring the source tree
- First tests written with the first feature — use cases and error mapping are the highest-value starting point
- Automated checks on every change

See [Testing Strategy](../quality/testing_strategy.md) and [Definition of Done](../quality/definition_of_done.md).

---

## Phase 8 — Documentation

Copy this documentation set into the new project and adapt it:

1. Remove pattern documents for capabilities the project does not have.
2. Adjust rule levels to match decisions actually taken.
3. Record the significant initial choices as ADRs — see [decisions](../decisions/README.md).
4. Keep product documentation separate from this template. See [Documentation Governance](documentation_governance.md).

---

## Checklist

Use the checklist below together with the implementation workflows linked from this document.

```text
[ ] Package identifier chosen deliberately
[ ] Directory structure established
[ ] Static analysis configured and passing
[ ] Secrets and environment files excluded from version control
[ ] Example environment file committed with placeholders
[ ] Configuration accessor in place
[ ] DI container and registration pattern working
[ ] Result and failure types defined
[ ] HTTP client configured with timeouts
[ ] Transport error translation centralized
[ ] Logging abstraction in place
[ ] Navigation structure established
[ ] Theme complete — light and dark
[ ] Shared components available (button, input, loading, empty, error)
[ ] Session and token handling (if authenticated)
[ ] Startup sequence with explicit fatal/recoverable decisions
[ ] One feature built end to end and reviewed
[ ] Test structure and first tests
[ ] Documentation adapted; initial ADRs recorded
```

---

## Related documents

- [Project Structure and Boundaries](../architecture/project_structure_and_boundaries.md) — directory layout
- [Scalability Guidelines](../architecture/scalability_guidelines.md) — which layers to skip at small scale
- [Recommended Tech Stack](../reference/recommended_tech_stack.md) — capability choices
- [Adding a Feature](../workflows/adding_feature.md) — the first feature
