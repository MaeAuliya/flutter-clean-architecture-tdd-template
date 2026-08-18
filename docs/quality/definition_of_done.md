# Definition of Done

A change is done when it is implemented, verified, documented where required, and safe to integrate — not when the happy path compiles.

## Every change

```text
[ ] Requirement and acceptance behavior satisfied
[ ] Change contains no unrelated edits
[ ] Architecture boundaries respected
[ ] Static analysis passes
[ ] Relevant tests pass
[ ] Failure, loading, empty, and cancellation states handled as applicable
[ ] No secrets or sensitive diagnostics introduced
[ ] Accessibility and theme impact checked for UI changes
[ ] Documentation updated when behavior/architecture/workflow changed
[ ] Verification results reported accurately
```

## Feature/API change

```text
[ ] Typed domain contract
[ ] External data validated and mapped
[ ] Central error translation used
[ ] DI and route registrations complete
[ ] State scoped correctly
[ ] Success and failure tests
[ ] Environment example updated for new keys (placeholders only)
```

## UI change

```text
[ ] Light and dark modes
[ ] Increased text scale
[ ] Narrow and expected wide constraints
[ ] Loading/empty/error/disabled states
[ ] Touch targets, semantics, focus order
[ ] No raw design tokens in feature code
[ ] Screenshot/golden updated if project uses them
```

## Integration/security change

```text
[ ] Threat/privacy impact considered
[ ] Android and iOS configured
[ ] Denied/unavailable/offline behavior
[ ] Credentials and logs reviewed
[ ] Resource lifecycle/disposal verified
[ ] Significant dependency/architecture decision recorded
```

## Verification reporting

Completion summary states:

- What changed
- Which checks were run and their result
- What was not run and why
- Any remaining risk or human confirmation needed

Never use "all tests pass" when tests were not run. Never use "done" for a partially implemented path without naming the gap.

## Automated gate

Recommended minimum CI for every change:

```text
format check
static analysis
unit + widget tests
secret scan
documentation link check (when docs change)
```

Build and integration tests may run on protected branches or release workflows depending on cost. This template's CI gate runs dependency fetch, feature/module generator round-trip validation, static analysis, and tests on pushes and pull requests to `master` and `develop`. Format enforcement, secret scanning, and documentation-link checks are not currently automated.

## Related documents

- [Testing Strategy](testing_strategy.md)
- [Code Review Checklist](code_review_checklist.md)
- [AI Working Agreement](../foundation/ai_working_agreement.md)
