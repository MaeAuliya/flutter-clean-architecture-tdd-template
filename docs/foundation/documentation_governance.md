# Documentation Governance

How this documentation set changes over time. The structure is deliberately open: new technical capabilities are expected to introduce new documents rather than being forced into existing ones.

---

## Rule levels

Every normative statement in this documentation carries one of five levels. Applying the right level is the single most important editorial decision, because a rule stated too strongly teaches a falsehood and a rule stated too weakly gets ignored.

| Level | Wording | When to use |
|---|---|---|
| **Mandatory** | must, must not, always, never | A boundary whose violation causes real harm — broken layering, leaked credentials, unhandled failures. Requires both strong reasoning **and** evidence of consistent practice. |
| **Preferred** | should, prefer, normally, recommended | The sensible default. Deviation is allowed with a stated reason. |
| **Optional** | may, when the project requires | A capability only some projects need — push notifications, maps, certificate pinning, biometrics. Never imply these are baseline requirements. |
| **Context-dependent** | depends on | The right answer varies with team size, scale, or platform. Present the trade-off; do not pick for the reader. |
| **Legacy / anti-pattern** | do not copy | Present in a reference implementation but not to be reproduced. Must explain *why*, or it reads as arbitrary. |

**Promoting a rule to Mandatory requires evidence, not conviction.** Before writing "must", establish that the pattern is genuinely dominant in practice and that violating it causes concrete harm. A pattern used in one place out of fourteen is an aspiration, and must be documented as Preferred with its adoption status stated plainly.

---

## Adding a new pattern document

1. **Confirm it is a pattern, not an instance.** A pattern recurs, or is a deliberate reusable decision. A single clever solution is not yet a pattern.
2. **Check whether it belongs in an existing document.** Prefer extending a related document over creating a thin new one. Split only when a document covers two genuinely separate concerns.
3. **Write it** using the standard pattern structure (below).
4. **Classify every rule** it contains.
5. **Register it** in the [Pattern Catalog](../reference/pattern_catalog.md).
6. **Cross-link** it from related documents, and link outward from it. An unlinked document will not be found.

### Standard pattern document structure

Adapt where another shape communicates better; do not pad to fill sections.

```text
Purpose                  — what this solves, in one or two sentences
Problem                  — what goes wrong without it
Applicability            — when to use, and when not to
Architecture role        — which layer owns it
Recommended structure    — files, types, directories
Mandatory conventions    — with justification
Preferred conventions    — with reasoning
Optional variations      — clearly marked optional
Extension workflow       — how to add another instance
Common mistakes          — observed failure modes
Testing considerations   — how to verify it
Security considerations  — when relevant
Example                  — generic pseudocode
Related documents        — links
```

---

## Deprecating a pattern

Do not delete a pattern document the moment it falls out of favor — existing code still follows it, and a reader who encounters that code needs to know its status.

1. Mark it **Legacy** at the top, with the date and the reason.
2. Point to the replacement.
3. State whether existing code should be migrated, or left until it is touched for other reasons.
4. Update the catalog entry.
5. Remove the document only once no code follows it.

Leaving two active patterns for one concern without declaring which is current is the failure mode to avoid. If the codebase is mid-migration, say so explicitly and name the target.

---

## Replacing a package

1. Record the decision as an ADR — see [decisions](../decisions/README.md) — covering what is being replaced, why, what alternatives were weighed, and the migration approach.
2. Update the affected pattern documents.
3. Update [Recommended Tech Stack](../reference/recommended_tech_stack.md), including its package-selection criteria.
4. If both packages will coexist during migration, say which is the target and which is being retired.

---

## Keeping the documentation honest

**No broken links.** Every relative link must resolve to a file that exists. Broken links are the first sign of documentation drift and the reason the predecessor of this set became untrustworthy.

**No orphan documents.** Every document is reachable from [`README.md`](../README.md) or from a document that is.

**No stubs.** Do not create a placeholder file to complete a directory tree. An empty document is worse than a missing one: it implies coverage that does not exist.

**No contradictions.** Before adding a rule, check whether another document already says something different about the same topic. When two documents overlap, one owns the topic and the other links to it.

**One home per topic.** Repeating an explanation in several documents guarantees the copies will diverge. Link instead.

---

## Review triggers

Revisit this documentation when any of the following occur:

- A significant refactor changes a layer boundary or module structure
- A core dependency is replaced
- A new integration is added — payments, maps, notifications, background work
- A recurring code-review comment reveals an undocumented or unclear rule
- Onboarding reveals a gap — the first questions a newcomer asks are the gaps
- A documented rule is repeatedly ignored in practice, which means either the rule or its level is wrong

---

## Keeping template and project documentation separate

This set is a **reusable template**. Documentation about a specific product — its domain, users, flows, and business rules — must not be mixed into it.

- Template content: architecture, patterns, conventions, workflows, quality, security.
- Product content: vision, domain model, user journeys, business rules, release specifics.

Keep product documentation in its own location, or derive it from the forms in [templates](../templates/). When a template document starts accumulating product nouns, that is a signal it has drifted and should be generalized.

The practical test: **could this document be dropped into an unrelated project in the same technology and still be correct?** If not, it contains product detail that belongs elsewhere.

---

## Related documents

- [Engineering Principles](engineering_principles.md) — the reasoning this documentation encodes
- [AI Working Agreement](ai_working_agreement.md) — documentation duties during implementation
- [Pattern Catalog](../reference/pattern_catalog.md) — the index every pattern registers in
- [Architecture Decision Records](../decisions/README.md) — how decisions are recorded
