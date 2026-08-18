# API Integration and Test Plan Templates

---

## API integration plan

### Contract

- **Capability:** `[CAPABILITY_NAME]`
- **Method/resource:** `[HTTP_METHOD] [API_RESOURCE]`
- **Authentication:** `[PUBLIC | SESSION | REAUTH_REQUIRED]`
- **Idempotency:** `[POLICY]`
- **Timeout/retry:** `[POLICY]`

### Request

| Domain field | Wire field | Type | Required | Sensitive |
|---|---|---|---|---|
| `[FIELD]` | `[WIRE_KEY]` | `[TYPE]` | `[YES_NO]` | `[YES_NO]` |

### Response

| Wire field | Model field | Domain field | Null/unknown policy |
|---|---|---|---|
| `[WIRE_KEY]` | `[MODEL_FIELD]` | `[DOMAIN_FIELD]` | `[POLICY]` |

### Errors

| External condition | Typed exception | Domain failure | User behavior |
|---|---|---|---|
| `[CONDITION]` | `[EXCEPTION]` | `[FAILURE]` | `[STATE_OR_EFFECT]` |

### Caching/offline

- Strategy: `[NONE | CACHE_FIRST | NETWORK_FIRST | STALE_WHILE_REVALIDATE]`
- Cache key: `[ALL_RESULT_INPUTS]`
- Freshness: `[TTL_VERSION_POLICY]`
- Invalidation: `[EVENTS]`

### Security/privacy

- Sensitive request/response fields: `[LIST]`
- Redaction: `[RULE]`
- Retention: `[RULE]`
- Transport requirements: `[HTTPS_PINNING_OR_OTHER]`

### Implementation sequence

```text
[ ] Domain repository contract
[ ] Params/entity types
[ ] Endpoint declaration/config placeholder
[ ] Request/response models and mapping
[ ] Remote/local source
[ ] Repository implementation and error conversion
[ ] Use case
[ ] DI registration
[ ] State and UI
[ ] Tests below
```

---

## Test plan

### Unit tests

| Layer | Scenario | Expected |
|---|---|---|
| Validator/domain | `[BOUNDARY]` | `[RESULT]` |
| Model parser | `[PAYLOAD]` | `[MODEL_OR_ERROR]` |
| Mapper | `[INPUT]` | `[ENTITY]` |
| Repository | `[SOURCE_RESULT]` | `[TYPED_RESULT]` |
| Use case | `[POLICY_CASE]` | `[RESULT]` |

### State tests

```text
[ ] Initial
[ ] Loading
[ ] Success/content
[ ] Empty
[ ] Recoverable failure + retry
[ ] Terminal/session failure
[ ] Duplicate/concurrent operation
[ ] Cancellation/disposal
```

### Widget tests

```text
[ ] All visual states
[ ] Primary interaction
[ ] Validation and focus
[ ] Light/dark
[ ] Increased text scale
[ ] Narrow constraints
[ ] Semantics and touch targets
```

### Integration tests

- `[CRITICAL_CROSS_BOUNDARY_JOURNEY]`
- Platforms/devices: `[MATRIX]`
- Environment/fakes: `[SETUP]`

### Non-functional

- Performance threshold: `[MEASURE_AND_LIMIT]`
- Accessibility requirement: `[REQUIREMENT]`
- Security assertion: `[ASSERTION]`
- Diagnostics assertion: `[SAFE_EVENT_WITHOUT_SENSITIVE_DATA]`

### Exit criteria

`[WHAT_MUST_PASS_AND_WHAT_RISK_REMAINS]`
