# Testing Strategy

**Status: Preferred standard; partially established.**

This template has unit, Bloc, repository, data-source, mapper, API, shared-widget, and injector-composition tests under `test/`; CI validates generator round trips, then runs analysis and tests. Integration coverage remains product-dependent. Generated features/modules include mirrored test skeletons and `.mock.dart` doubles, but consuming projects must replace placeholder cases with behavior-specific coverage.

## Test pyramid

### Unit tests — majority

Fast, deterministic tests for:

- Validators and formatters
- Entity/value-object invariants
- Use cases
- Model parsing and mapping
- Repository policy and error conversion
- Token refresh coordination
- Bootstrap decision logic

### State-holder tests

Test emitted states/effects for each event/method. Cover loading, success, empty, typed failure, terminal session state, concurrency and cancellation where relevant.

### Widget tests

Focus on shared components and feature states rather than implementation details:

- Loading/content/empty/error
- Form validation and submission
- Retry action
- Dark/light theme
- Increased text scale and constrained width
- Semantic labels

### Integration tests — targeted

Reserve for behavior that crosses real boundaries:

- Startup and restored session routing
- Authentication refresh/replay
- Deep link or notification cold start
- Camera/location permission flow (where practical)
- A small set of critical journeys

## Test doubles

Prefer fakes when a dependency has a small behavioral contract:

```dart
final class FakeItemRepository implements ItemRepository {
  ResultFuture<Item> Function(ItemId)? onLoad;
  @override
  ResultFuture<Item> loadItem(ItemId id) => onLoad!(id);
}
```

Use mocks when verifying a call interaction is itself important or a large third-party surface is impractical to fake. Do not mock value objects or the system under test.

## Fixtures

- Fictional and minimal
- Named by scenario, not opaque number
- No production personal data, host, token, or secret
- Shared only when it reduces real duplication
- JSON fixtures validate external contracts; builders construct domain values

## Coverage priorities

1. Security/session concurrency and invalidation
2. Error translation
3. Business policy in use cases
4. Data mapping at external boundaries
5. State transitions
6. Shared UI/accessibility
7. Critical integration journeys

A raw coverage target can encourage low-value tests. Measure coverage as a diagnostic, then review uncovered risk.

## Determinism

Inject clocks, ID generators, randomness, and platform gateways. Do not sleep in tests or depend on wall time/network. Reset dependency containers and static state between tests.

## Commands

```bash
flutter test test/path/to/file_test.dart   # one file
flutter test                              # all unit/widget tests
flutter test --coverage
flutter analyze
```

Integration-test commands depend on the target/device setup and must be documented by the consuming project.

## Minimum per new feature

```text
[ ] Domain policy tests
[ ] Model parsing/mapping tests
[ ] Repository success and each failure class
[ ] State-holder loading/success/failure/empty
[ ] Critical widget states
[ ] Any security/concurrency edge specific to the feature
```

## Related documents

- [Definition of Done](definition_of_done.md)
- [Code Review Checklist](code_review_checklist.md)
