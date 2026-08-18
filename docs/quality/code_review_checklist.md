# Code Review Checklist

Use the relevant sections; do not turn review into a mechanical box-ticking exercise.

## Scope

- Change matches the stated requirement
- No unrelated reformat/refactor/rename
- Public contracts changed only intentionally
- Generated and dependency files changed only when expected

## Architecture

- Dependency direction is valid
- Presentation does not call data sources/client/storage
- Domain is framework and transport independent
- Repository contract exposes domain values, not DTOs/maps/responses
- No feature imports another feature's data/presentation internals
- New abstraction protects a real boundary; no empty ceremony

## State and async

- Mutable state has the narrowest correct scope
- State is immutable and derived values are not duplicated
- Every async path exits loading
- Concurrency, cancellation, disposal, and stale responses handled
- Side effects are consumed once
- No global feature/form provider without explicit lifecycle reason

## Data and errors

- External payload validated before casting
- Models map explicitly to domain
- Client errors use central translation
- Expected failures are typed results
- Cancellation is not shown as generic error
- User messages are safe and actionable

## UI

- Uses shared components and semantic theme roles
- No raw/hardcoded themed colors
- Works in light/dark, increased text scale, and constrained layouts
- Loading, empty, error, disabled, and retry states exist where relevant
- Touch targets and semantics are adequate
- No multi-boolean component variant that permits invalid combinations

## Security/privacy

- No secret, real host, token, pin, certificate, or personal data added
- Sensitive values use encrypted storage
- Logs redact credentials and private payloads
- Permission requested contextually and minimally
- External URI/payload validated
- Authentication retry bounded and transient failure does not clear session

## Quality

- Tests cover behavior and failure boundaries
- Static analysis passes without unjustified suppression
- New dependency justified and wrapped where appropriate
- Documentation updated for architectural change
- Comments explain why, not syntax
- Dead/commented-out code removed

## Reviewer response

Distinguish:

- **Blocking defect** — correctness, security, architecture boundary
- **Requested improvement** — maintainability required before merge
- **Suggestion** — optional alternative, not disguised as a requirement
- **Question** — uncertainty, not an accusation

Anchor feedback to a concrete failure scenario or maintenance cost. "I prefer X" is not a review finding.

## Related documents

- [Definition of Done](definition_of_done.md)
- [Engineering Principles](../foundation/engineering_principles.md)
- [Dependency Rules](../architecture/dependency_rules.md)
