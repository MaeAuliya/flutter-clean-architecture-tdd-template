# Flutter Engineering Documentation Template

A product-agnostic engineering system for Flutter applications. It defines architecture, implementation patterns, developer workflows, quality standards, security boundaries, and neutral templates that can be adapted to projects of different sizes.

This is not product documentation and does not describe any specific application, company, domain, screen flow, or API. It is designed to remain portable across editors, automation platforms, and AI coding agents.

---

## How to use this documentation

### Starting a new project

1. Read [Engineering Principles](foundation/engineering_principles.md).
2. Choose a scale in [Scalability Guidelines](architecture/scalability_guidelines.md).
3. Follow [Project Bootstrap](foundation/project_bootstrap.md).
4. Use [Recommended Tech Stack](reference/recommended_tech_stack.md) to select capabilities, not packages by habit.
5. Build the first vertical slice with [Adding a Feature](workflows/adding_feature.md).
6. Record significant choices in [Architecture Decision Records](decisions/README.md).

### Joining an existing project

Read in this order:

1. [Architecture Overview](architecture/architecture_overview.md)
2. [Project Structure and Boundaries](architecture/project_structure_and_boundaries.md)
3. [Dependency Rules](architecture/dependency_rules.md)
4. [Pattern Catalog](reference/pattern_catalog.md)
5. The pattern and workflow documents relevant to your task
6. [Definition of Done](quality/definition_of_done.md)

### Implementing a change

- Start from the relevant file in [workflows](workflows/).
- Consult the pattern documents it links to.
- Apply mandatory rules; follow preferred rules unless you can state why not.
- Use optional patterns only when the project actually needs the capability.
- Update documentation when architectural behavior changes.

### AI coding agents

An AI coding agent must read [AI Working Agreement](foundation/ai_working_agreement.md) before making changes. That document is tool-neutral and defines scope discipline, verification, uncertainty, package selection, and documentation responsibilities.

---

## Rule classifications

Every recommendation has one of five strengths:

| Level | Meaning |
|---|---|
| **Mandatory** | A consistent architectural or safety boundary. Violations require explicit architectural approval. |
| **Preferred** | The default approach. Deviation is acceptable with a concrete reason. |
| **Optional** | Adopt only when the capability is required. |
| **Context-dependent** | Choose according to scale, team, and platform constraints. |
| **Legacy / anti-pattern** | Observed in mature code but intentionally excluded from this template. Do not copy. |

Only documents that say **Mandatory** define mandatory rules. A pattern document may contain rules at several levels. The classification method is documented in [Documentation Governance](foundation/documentation_governance.md).

---

## Documentation map

### Foundation

- [Engineering Principles](foundation/engineering_principles.md) — reasoning behind the rules
- [AI Working Agreement](foundation/ai_working_agreement.md) — agent-neutral implementation contract
- [Documentation Governance](foundation/documentation_governance.md) — how this system evolves
- [Project Bootstrap](foundation/project_bootstrap.md) — starting a project from the template

### Architecture

- [Architecture Overview](architecture/architecture_overview.md) — layered feature architecture and data flow
- [Project Structure and Boundaries](architecture/project_structure_and_boundaries.md) — features, core, shared modules, cross-feature rules
- [Dependency Rules](architecture/dependency_rules.md) — permitted imports by layer
- [Scalability Guidelines](architecture/scalability_guidelines.md) — simplifying or expanding the architecture

### Patterns

The central [Pattern Catalog](reference/pattern_catalog.md) lists status, applicability, dependencies, and trade-offs for every pattern.

- [Dependency Injection](patterns/dependency_injection.md)
- [State Management](patterns/state_management.md)
- [Routing](patterns/routing.md)
- [Networking](patterns/networking.md)
- [Authentication and Token Management](patterns/authentication_and_tokens.md)
- [Error Handling](patterns/error_handling.md)
- [Data Mapping and Serialization](patterns/data_mapping.md)
- [Local and Secure Storage](patterns/storage.md)
- [Environment Configuration and Remote Config](patterns/configuration.md)
- [Application Bootstrap](patterns/app_bootstrap.md)
- [Shared UI, Theme, and Responsive Layout](patterns/shared_ui.md)
- [Forms and Validation](patterns/forms_and_validation.md)
- [Permissions and Device Capabilities](patterns/permissions_and_device.md)
- [Notifications and Deep Links](patterns/notifications_and_deep_links.md)
- [Location, Maps, Media, and Files](patterns/location_maps_media.md)
- [Pagination and Caching](patterns/pagination_and_caching.md)
- [Logging and Diagnostics](patterns/logging_and_diagnostics.md)
- [Localization](patterns/localization.md)

### Conventions

- [Dart and Flutter Style](conventions/dart_flutter_style.md) — declarations, widgets, naming, imports, async code, and immutability

### Workflows

- [Adding a Feature](workflows/adding_feature.md)
- [Adding Presentation](workflows/adding_presentation.md) — screen, route, and state
- [Adding Data Access](workflows/adding_data_access.md) — endpoint, repository method, local storage
- [Adding an Integration or Dependency](workflows/adding_integration.md)

### Quality

- [Testing Strategy](quality/testing_strategy.md)
- [Code Review Checklist](quality/code_review_checklist.md)
- [Definition of Done](quality/definition_of_done.md)
- [Performance and Accessibility](quality/performance_and_accessibility.md)

### Security

- [Secure Coding and Credentials](security/secure_coding_and_credentials.md)
- [Transport Security](security/transport_security.md)
- [Session Security](security/session_security.md)

### Templates and reference

- [Feature and Screen Specification](templates/feature_and_screen_spec.md)
- [API Integration and Test Plan](templates/api_and_test_plan.md)
- [Decision and Project Documentation Templates](templates/decision_and_product_docs.md)
- [Recommended Tech Stack](reference/recommended_tech_stack.md)
- [Pattern Catalog](reference/pattern_catalog.md)
- [Architecture Decision Records](decisions/README.md)
- [Improvement Opportunities](TODO/next_steps.md)

---

## Updating the system

A new technical capability may introduce any combination of:

- A pattern document
- An implementation workflow
- A security note
- A reusable template
- An architecture decision
- A catalog entry

Do not force unrelated concerns into an existing document just to preserve the current tree. The tree is an index, not a closed schema. Follow [Documentation Governance](foundation/documentation_governance.md): avoid stubs, broken links, orphan documents, repeated explanations, and rules stated more strongly than evidence supports.

When architecture changes, update the relevant documents in the same change. Documentation drift is an implementation defect.
