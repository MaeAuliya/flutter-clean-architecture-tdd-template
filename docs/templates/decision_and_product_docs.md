# Decision and Project Documentation Templates

These templates are intentionally empty of product detail. Keep completed product documents separate from the reusable engineering template.

---

## Architecture Decision Record

```markdown
# ADR-[NUMBER]: [DECISION_TITLE]

- Status: [PROPOSED | ACCEPTED | DEPRECATED | SUPERSEDED]
- Date: [YYYY-MM-DD]
- Owners: [OWNERS]
- Supersedes: [ADR_OR_NONE]

## Context
[PROBLEM, CONSTRAINTS, FORCES]

## Decision
[WHAT_WAS_CHOSEN]

## Alternatives considered
### [ALTERNATIVE]
- Benefits:
- Costs:
- Reason not chosen:

## Consequences
### Positive
- [CONSEQUENCE]
### Negative / risks
- [CONSEQUENCE]
### Follow-up
- [ACTION]

## Validation
[HOW_THE_DECISION_WILL_BE_REVIEWED]

## Related documents
- [LINK]
```

---

## Package evaluation

```markdown
# Package Evaluation: [DEPENDENCY]

- Capability: [PROBLEM_SOLVED]
- Proposed version policy: [POLICY]
- Maintainer/activity: [EVIDENCE]
- License: [LICENSE]
- Supported platforms/minimum versions: [DETAIL]
- Transitive dependencies/binary impact: [DETAIL]
- Security/privacy/data collection: [DETAIL]
- API stability/migration history: [DETAIL]
- Testability and wrapping strategy: [DETAIL]

## Alternatives
1. Framework/existing dependency: [ASSESSMENT]
2. [ALTERNATIVE]: [ASSESSMENT]
3. No dependency: [ASSESSMENT]

## Recommendation
[ADOPT | REJECT | SPIKE], because [REASON].

## Removal/exit strategy
[HOW_TO_REPLACE]
```

---

## Product vision

```markdown
# [PRODUCT_NAME] Vision

## Problem
[USER_PROBLEM_WITH_EVIDENCE]

## Target users
[USER_SEGMENTS]

## Value proposition
[OUTCOME, NOT FEATURE_LIST]

## Goals / non-goals
- Goal: [MEASURABLE]
- Non-goal: [BOUNDARY]

## Success measures
[METRICS_AND_TIMEFRAME]

## Constraints and assumptions
[LIST]
```

---

## Information architecture

```markdown
# Information Architecture

## Primary objects
| Object | Meaning | Owner |
|---|---|---|
| [OBJECT] | [MEANING] | [FEATURE] |

## Navigation hierarchy
[NEUTRAL_TREE]

## Cross-links and entry points
[DEEP_LINK_NOTIFICATION_SEARCH]

## Naming glossary
[USER_FACING_TERMS]
```

---

## User flow

```markdown
# User Flow: [FLOW_NAME]

- Trigger: [ENTRY]
- Preconditions: [CONDITIONS]
- Success outcome: [OUTCOME]

## Main path
1. [STEP]

## Alternate/error paths
- [CONDITION] → [BEHAVIOR_AND_RECOVERY]

## State persistence
[WHAT_SURVIVES_EXIT_RESTART]

## Analytics and accessibility
[EVENTS_WITHOUT_SENSITIVE_DATA; ACCESSIBILITY_NOTES]
```

---

## Design direction and visual system

```markdown
# Design Direction

## Principles
- [PRINCIPLE]

## Semantic color roles
| Role | Light | Dark | Use |
|---|---|---|---|
| Primary | [TOKEN] | [TOKEN] | [USE] |

## Typography and spacing
[SCALE_AND_RATIONALE]

## Component inventory
| Component | Variants | States | Accessibility |
|---|---|---|---|
| [COMPONENT] | [VARIANTS] | [STATES] | [REQUIREMENTS] |

## Responsive behavior
[BREAKPOINTS_AND_REFLOW]

## Motion
[DURATION_PURPOSE_REDUCED_MOTION]
```
