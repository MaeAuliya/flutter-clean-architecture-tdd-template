# AI Working Agreement

This document defines how an AI coding agent should work in a project using this template. It is deliberately tool-neutral: it applies to any agent, assistant, or automated contributor, and mentions no specific vendor or product.

Human contributors benefit from most of these rules too. They are written for agents because agents produce large volumes of plausible-looking code quickly, which makes the failure modes below both more likely and more expensive.

---

## Before writing code

**Read the relevant documentation first.** At minimum: [Engineering Principles](engineering_principles.md), the [Architecture Overview](../architecture/architecture_overview.md), and the pattern document covering the area you are changing. The [Pattern Catalog](../reference/pattern_catalog.md) maps topics to documents.

**Inspect the existing code before introducing anything new.** Search for an existing implementation of what you are about to write. Most tasks in a mature codebase are extensions of an existing pattern, not new inventions. A new helper that duplicates an existing one is a net loss even if it is individually well written.

**Understand the layer you are working in.** Know whether the file you are editing belongs to presentation, domain, or data, and what that layer is permitted to depend on. See [Dependency Rules](../architecture/dependency_rules.md).

**Ask when the requirement is ambiguous.** State the ambiguity and your proposed interpretation. Do not invent a requirement and build on it silently — an incorrect assumption discovered after implementation is far more expensive than a question asked before it.

---

## While writing code

**Follow the documented structure.** Place files where the structure says they go. Do not introduce a parallel organizational scheme.

**Prefer the existing pattern over a better one.** If the codebase consistently does something in a reasonable way, match it. Introducing a competing approach — even a superior one — leaves the project with two conventions and no clear default. If you believe the established pattern is genuinely wrong, say so and let a human decide; do not resolve it unilaterally mid-task.

**Keep the change scoped to the request.** Do not reformat untouched files, rename unrelated symbols, reorder imports outside your edit, or refactor adjacent code you happened to read. These changes inflate the diff and obscure the reviewable content.

**Do not add dependencies without justification.** A new package is a long-term maintenance and security commitment. Check whether the capability already exists in the project or the framework. If a package is genuinely warranted, state what it does, why existing tools are insufficient, and what it costs. See [Adding an Integration or Dependency](../workflows/adding_integration.md).

**Preserve public contracts.** Do not change a method signature, route name, storage key, or serialized field name unless the task requires it. These have callers you cannot see — persisted data, deep links, other layers.

**Reuse the shared component layer.** Buttons, text fields, dialogs, and loading, empty, and error states already exist. A bespoke local reimplementation is a defect, not a shortcut.

**Never hardcode secrets.** No API keys, tokens, certificates, passwords, or private URLs in source, tests, or documentation — including as examples. Use configuration and placeholders. See [Secure Coding and Credential Handling](../security/secure_coding_and_credentials.md).

**Read from the theme.** Do not hardcode colors or text styles in widget code. See [Shared UI](../patterns/shared_ui.md).

---

## Verifying your work

**Run the project's quality checks before declaring completion.** At minimum, static analysis; tests where they exist. See [Definition of Done](../quality/definition_of_done.md).

**Report results honestly.** If tests fail, say so and include the output. If you skipped a step, say which. If a change is unverified, label it unverified. Never describe work as complete and tested when it is neither — this is the single most damaging thing an agent can do, because it transfers a false belief to someone who will act on it.

**Distinguish what you verified from what you expect.** "The analyzer passes" and "this should work" are different claims and must be phrased differently.

---

## Boundaries

**Do not perform destructive or outward-facing actions without explicit instruction.** No committing, pushing, force-pushing, branch deletion, history rewriting, dependency installation, or publishing unless asked. Approval for one such action does not extend to the next.

**Do not delete or overwrite work you did not create** without first examining it and confirming the intent. If what you find contradicts how it was described, surface the discrepancy instead of proceeding.

**Do not disable a failing check to make it pass.** A skipped test, a suppressed lint, or a loosened assertion hides the problem rather than solving it. If a check is genuinely wrong, say why.

**Do not expand scope because a rewrite looks easier.** Rewriting a component you find inelegant is not within the scope of a bug fix.

---

## Documentation duties

**Update documentation when architectural behavior changes.** A new pattern, a changed layer boundary, a replaced dependency, or a new integration all require a documentation change in the same task. See [Documentation Governance](documentation_governance.md).

**Record problems you decline to fix.** When you notice a defect outside your scope, add it to the improvement log rather than fixing it silently or discarding the observation.

**Respect the rule levels.** This documentation distinguishes mandatory rules from preferred conventions and optional patterns. Do not treat an optional integration as required, and do not silently downgrade a mandatory rule. The levels are defined in the [documentation index](../README.md).

---

## Uncertainty

State uncertainty rather than resolving it with a confident guess. Useful phrasings:

- "The codebase does this two different ways; I followed the more common one. The other appears in [location]."
- "This requires a decision I cannot make from the code: [decision]. I assumed [assumption]."
- "I could not verify this because [reason]."

An agent that reports genuine uncertainty is more useful than one that is always confident, because its confidence carries information.

---

## Related documents

- [Engineering Principles](engineering_principles.md) — the reasoning behind these rules
- [Documentation Governance](documentation_governance.md) — how to extend this documentation
- [Code Review Checklist](../quality/code_review_checklist.md) — what a reviewer will check
- [Definition of Done](../quality/definition_of_done.md) — completion criteria
