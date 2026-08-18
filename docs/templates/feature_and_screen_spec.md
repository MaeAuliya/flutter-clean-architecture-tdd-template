# Feature and Screen Specification Templates

Copy the relevant section into product documentation. Replace every bracketed placeholder; remove sections that do not apply.

---

## Feature specification

### Identity

- **Feature:** `[FEATURE_NAME]`
- **Owner:** `[TEAM_OR_OWNER]`
- **Status:** `[PROPOSED | ACTIVE | DEPRECATED]`
- **Related decision:** `[ADR_LINK]`

### Purpose

`[ONE_PARAGRAPH_USER_OR_SYSTEM_OUTCOME]`

### Scope

**Owns**

- `[RESPONSIBILITY]`

**Does not own**

- `[BOUNDARY_OR_ADJACENT_FEATURE]`

### Entry points

- `[ROUTE_OR_EXTERNAL_INTENT]`

### Domain

| Type/operation | Responsibility |
|---|---|
| `[ENTITY]` | `[MEANING]` |
| `[USE_CASE]` | `[POLICY_OR_OPERATION]` |
| `[REPOSITORY_METHOD]` | `[CAPABILITY]` |

### Data sources

| Source | Purpose | Offline/cache policy |
|---|---|---|
| `[REMOTE_DATA_SOURCE]` | `[PURPOSE]` | `[POLICY]` |
| `[LOCAL_DATA_SOURCE]` | `[PURPOSE]` | `[POLICY]` |

### States and failures

- Initial: `[BEHAVIOR]`
- Loading: `[BEHAVIOR]`
- Content: `[BEHAVIOR]`
- Empty: `[BEHAVIOR]`
- Recoverable failure: `[MESSAGE_AND_RETRY]`
- Terminal failure: `[BEHAVIOR]`
- Session expiry: `[GLOBAL_AND_LOCAL_BEHAVIOR]`

### Dependencies and integrations

- `[DEPENDENCY]` — `[WHY_REQUIRED]`
- Permissions: `[NONE_OR_LIST]`
- Configuration keys: `[PLACEHOLDER_KEYS_ONLY]`
- Sensitive data: `[CLASSIFICATION_AND_RETENTION]`

### Acceptance and tests

- `[ACCEPTANCE_CRITERION]`
- Unit: `[POLICY_MAPPING_FAILURE_CASES]`
- State: `[TRANSITIONS]`
- Widget: `[STATES_AND_ACCESSIBILITY]`
- Integration: `[BOUNDARY_JOURNEY]`

### Documentation impact

- `[PATTERN_WORKFLOW_SECURITY_OR_ADR_TO_UPDATE]`

---

## Screen specification

### Identity

- **Screen:** `[SCREEN_NAME]`
- **Route:** `[ROUTE_NAME]`
- **Arguments:** `[TYPED_ARGUMENTS]`
- **State owner:** `[STATE_MANAGER]`

### Purpose

`[USER_GOAL]`

### Layout hierarchy

```text
[SCREEN_SCAFFOLD]
  [APP_BAR]
  [PRIMARY_SECTION]
    [COMPONENT]
  [SECONDARY_SECTION]
  [PRIMARY_ACTION]
```

### States

| State | Visible UI | Actions |
|---|---|---|
| Initial | `[UI]` | `[ACTION]` |
| Loading | `[UI]` | `[ACTION]` |
| Content | `[UI]` | `[ACTION]` |
| Empty | `[UI]` | `[ACTION]` |
| Error | `[UI]` | `[RETRY]` |

### Input and validation

| Field | Input | Validation | Sensitive? |
|---|---|---|---|
| `[FIELD]` | `[TYPE]` | `[RULE]` | `[YES_NO]` |

### Navigation/effects

- `[EVENT]` → `[DESTINATION_OR_EFFECT]`
- Back behavior: `[BEHAVIOR]`
- Deep-link behavior: `[BEHAVIOR_OR_NA]`

### Design and accessibility

- Shared components: `[LIST]`
- Theme roles: `[SEMANTIC_ROLES]`
- Text scale behavior: `[REFLOW]`
- Semantics/focus: `[REQUIREMENTS]`
- Empty/error copy: `[PRODUCT_DOC_REFERENCE]`

### Verification

- `[LIGHT_DARK_TEXT_SCALE_CONSTRAINT_STATES_INTERACTIONS]`
