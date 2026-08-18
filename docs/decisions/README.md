# Architecture Decision Records

Architecture Decision Records (ADRs) preserve why a durable technical choice was made, which alternatives were considered, and what consequences were accepted.

## When to write one

Write an ADR for choices that are expensive to reverse or shape many features:

- State-management or DI approach
- Layer/module boundaries
- Router or serialization strategy
- Authentication/token lifecycle
- Offline/cache model
- Certificate pinning
- Major external SDK/provider
- Persistence technology
- Deliberate deviation from a mandatory convention

Do not write an ADR for routine implementation details already covered by a pattern.

## Naming

```text
decisions/
  0001-use-layered-feature-architecture.md
  0002-centralize-transport-error-mapping.md
```

Numbers are sequential; filenames remain stable. Use the template in [Decision and Project Documentation Templates](../templates/decision_and_product_docs.md).

## Status

- **Proposed** — under discussion
- **Accepted** — active decision
- **Deprecated** — no longer recommended but still present
- **Superseded** — replaced; link to successor

Never rewrite history to make an old decision look current. Add a new ADR and supersede the old one.

## Review

An ADR includes measurable validation or a review trigger where possible — for example, "revisit if injector count exceeds X" or "validate token coordination with concurrency tests."

## Initial decisions worth recording in a consuming project

This template recommends evaluating and recording:

1. Project scale and layer simplification
2. Import policy
3. State-management approach and state scope
4. DI composition mechanism
5. Result/failure representation
6. Serialization strategy
7. Environment/flavor strategy
8. Authentication/session lifecycle, if applicable
9. Optional security integrations such as pinning

## Related documents

- [Documentation Governance](../foundation/documentation_governance.md)
- [Architecture Overview](../architecture/architecture_overview.md)
- [Recommended Tech Stack](../reference/recommended_tech_stack.md)
