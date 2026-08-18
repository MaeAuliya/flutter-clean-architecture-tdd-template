# Engineering Principles

The principles below are the reasoning behind the rest of this documentation. When a specific rule elsewhere seems wrong for your situation, come back here: a rule that no longer serves its principle should be changed, not obeyed mechanically.

---

## 1. Dependencies point inward

Business rules must not depend on delivery mechanisms. A use case should not know whether data arrives over HTTP, from a cache, or from a test fake.

**Why it matters.** Swapping a transport library, adding an offline cache, or writing a test all become local changes instead of a rewrite.

**In practice.** Presentation depends on domain. Data depends on domain. Domain depends on nothing but the language and small shared primitives. See [Dependency Rules](../architecture/dependency_rules.md).

---

## 2. Errors are values, not surprises

Expected failures — a rejected login, a timeout, a validation error — are ordinary outcomes and belong in the return type. Only genuine defects should throw.

**Why it matters.** A signature that returns a result type forces the caller to decide what happens on failure. A signature that returns a bare value lets the caller forget, and the forgetting surfaces as a production crash.

**In practice.** Repository methods return a result type carrying either a typed failure or a value. Boundaries that must throw (transport adapters) do so in exactly one place, which converts them. See [Error Handling](../patterns/error_handling.md).

---

## 3. One concern, one place

When a rule is expressed in several places, the copies drift. The second copy is the bug.

**Why it matters.** In the reference codebase this principle is upheld well in one area and violated in another, and the contrast is instructive. Transport-error translation lives in a single handler used by 12 of 14 remote data sources — changing an error message is a one-line edit. Session-expiry handling, by contrast, is expressed both as a reusable mixin and as hand-written status-code checks scattered across blocs; the two now behave differently, and no one place defines the behavior.

**In practice.** Before writing a check, search for an existing one. If you find a near-duplicate, extend it rather than adding a sibling.

---

## 4. Boring and consistent beats clever and novel

A reader who has understood one feature should be able to predict the shape of the next.

**Why it matters.** Consistency is what makes a codebase navigable and what makes an AI coding agent's output reviewable. Novelty has a cost paid by every future reader.

**In practice.** Match the surrounding code's structure, naming, and idiom. Introduce a new pattern only when the existing one genuinely cannot express the requirement — and when you do, document it and migrate deliberately rather than leaving two competing conventions in place.

---

## 5. Abstract on the second or third case, not the first

Premature abstraction guesses at variation that may never arrive, and the guess is usually wrong.

**Why it matters.** A wrong abstraction is more expensive than duplication, because it must be understood *and* unwound.

**In practice.** Write the concrete thing. When a second case appears, look for the real shared shape. Abstract when the shape is evident from examples, not from imagination. The corollary: do not create an interface for something with exactly one implementation and no test seam.

---

## 6. Make invalid states unrepresentable

Prefer designs where illegal combinations cannot be constructed over designs that detect illegal combinations at runtime.

**Why it matters.** A component taking several independent booleans has a combinatorial state space, most of which is untested and some of which is nonsense. The reference codebase contains a shared error component that branches on multiple independent flags into four near-identical trees — the flags can be combined in ways that were never intended.

**In practice.** Prefer one variant parameter (enum or sealed type) over several booleans. Prefer required constructor parameters over nullable fields that must be set later. Prefer immutable objects with a `copyWith` over mutable ones.

---

## 7. Secure by default

Security should be the path of least resistance, not an added step that can be skipped.

**Why it matters.** Any control that depends on remembering to apply it will eventually be forgotten.

**In practice.** Credentials go to encrypted storage through one gateway, never to plain key-value storage. Authentication headers are attached by a client-level interceptor, not by each call site. Configuration values arrive at build time and are never committed. See [Secure Coding and Credential Handling](../security/secure_coding_and_credentials.md).

---

## 8. Degrade rather than fail

Startup and infrastructure paths should keep the application usable when a non-critical dependency is unavailable.

**Why it matters.** A remote configuration service being briefly unreachable should not brick the application. This is handled well in the reference codebase: configuration initialization falls back to compiled-in defaults, logs the failure, and lets the application boot.

**In practice.** Decide explicitly for each dependency whether failure is fatal or recoverable. Recoverable failures need a fallback and a log entry; they must not be swallowed silently. Distinguish *transient* failure (retry) from *invalid* state (stop) — conflating them either logs users out on a flaky network or retries forever on a genuine rejection.

---

## 9. State belongs to the narrowest scope that needs it

State outliving its screen is a source of bugs that are hard to reproduce, because behavior depends on navigation history.

**Why it matters.** The reference codebase registers a large number of UI-state holders at application scope. Their state survives navigation, so screens must remember to reset it manually — and when a reset is forgotten, a screen opens showing data from a previous visit.

**In practice.** Scope UI state to the route that owns it. Reserve application scope for genuinely global concerns such as session, theme, and connectivity. See [State Management](../patterns/state_management.md).

---

## 10. Read from the design system, not around it

A theme only works if code consumes it. Every hardcoded color is a hole in dark mode and rebranding.

**Why it matters.** This is the sharpest lesson available from the reference codebase. It defines a complete light and dark color scheme, and its shared widget layer reads from it correctly — but feature code overwhelmingly references raw color constants directly. The result is a well-built dark theme that is substantially inert wherever features paint their own surfaces. The infrastructure was never the problem; adoption was.

**In practice.** Read colors and text styles from the theme in widget code. Raw tokens belong in the theme definition and nowhere else. See [Shared UI](../patterns/shared_ui.md).

---

## 11. Changes stay scoped

A change should contain what the task requires and nothing else.

**Why it matters.** Unrelated edits bury the reviewable change, make reverts risky, and turn a one-line fix into a broad-surface risk.

**In practice.** No opportunistic reformatting, renaming, or refactoring inside a feature change. If you spot an unrelated problem, record it rather than fixing it in place. This applies with particular force to AI coding agents, which can produce large diffs cheaply — see [AI Working Agreement](ai_working_agreement.md).

---

## 12. Documentation changes with the code

Documentation that contradicts the code is worse than no documentation, because it is trusted.

**Why it matters.** The `docs/` directory this template replaced described an entirely different application on a different framework. Anyone following it would have been led directly into wrong work.

**In practice.** When a change alters architectural behavior — a new pattern, a changed boundary, a replaced dependency — update the affected document in the same change. See [Documentation Governance](documentation_governance.md).

---

## 13. Evidence over assertion

Claim what you have verified. Distinguish measurement from expectation.

**Why it matters.** A guideline asserting that a codebase "always" does something, when it does so in one place out of fourteen, teaches a falsehood and erodes trust in every neighboring claim.

**In practice.** This documentation classifies each rule by how consistently it is actually practiced — see the levels in the [documentation index](../README.md). When you add guidance, say whether it is established practice, an aspiration, or an untested idea. "We should test this" and "this is tested" are different statements.

---

## Related documents

- [AI Working Agreement](ai_working_agreement.md) — how these principles apply to agent-assisted work
- [Documentation Governance](documentation_governance.md) — how this documentation evolves
- [Architecture Overview](../architecture/architecture_overview.md) — the structure these principles produce
- [Pattern Catalog](../reference/pattern_catalog.md) — the full index of patterns
