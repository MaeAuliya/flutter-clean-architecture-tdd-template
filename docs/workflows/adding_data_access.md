# Workflow: Adding Data Access

Covers a new API endpoint, repository method, or local persistence operation.

## Preconditions

- External contract is known: method, path, auth, request, response, errors
- Domain result and operation are defined
- Cache/offline policy is explicit
- Sensitive fields are identified

## 1. Extend the domain contract

Add a repository method returning domain entities or primitives in the project result type. Do not expose client responses, maps, DTOs, or status codes.

```dart
ResultFuture<Item> loadItem(ItemId id);
```

Add a use case if the operation has policy, coordination, reuse, or independent test value.

## 2. Define models and mapping

- Request model maps domain params to wire keys
- Response model validates external shape
- Explicit mapping converts response model to entity
- Unknown enums and nullable fields have documented policy

## 3. Declare the endpoint

Add the path to the central endpoint owner. Add any build-time key to the ignored environment file and placeholder example. Validate required configuration at startup.

## 4. Implement the data source

- Use the injected configured client
- Mark public calls to skip auth explicitly
- Set request cancellation/timeout policy where special
- Parse with shape validation
- Route client errors through the central exception mapper
- Never log payloads containing credentials or personal data

## 5. Implement repository policy

- Convert entity params to request models
- Call source
- Map model to entity
- Convert known source exception to typed failure
- Apply cache policy explicitly if local and remote sources coexist

## 6. Register and test

- Register source and repository implementation
- Data-source test: request shape, valid/malformed response, transport errors
- Repository test: mapping, source failure, cache behavior
- Use-case test: policy
- Auth integration: expired token/replay where applicable

## Local storage addition

1. Classify sensitivity and select encrypted storage, preferences, database, or file cache
2. Centralize keys/schema
3. Define typed gateway methods
4. Define missing/corrupt/migration behavior
5. Document retention and clear behavior
6. Test migration and deletion

## Common mistakes

- Path literal in data-source method
- Untyped map returned upward
- Empty local source generated but unused
- Any `catch` converted to server failure
- Write auto-retried without idempotency
- Cache key omits user/filter scope
- Real endpoint or key copied into docs/tests

## Related documents

- [Networking](../patterns/networking.md)
- [Error Handling](../patterns/error_handling.md)
- [Data Mapping](../patterns/data_mapping.md)
- [Storage](../patterns/storage.md)
- [API Integration and Test Plan](../templates/api_and_test_plan.md)
