# Workflow: Adding a Feature

A vertical-slice sequence that keeps the feature usable and reviewable at each step.

## Preconditions

- Feature boundary and name are clear
- Required integrations and permissions are known
- Similar features have been inspected
- Relevant architecture and pattern docs have been read

## Sequence

### 1. Define the capability

Write the feature's responsibilities and non-responsibilities. Identify entities, operations, inputs, outputs, failure states, and routed screens. Use the [Feature Specification](../templates/feature_and_screen_spec.md).

### 2. Create domain contracts

```text
features/[feature]/domain/
  entities/
  repositories/
  usecases/
```

- Define immutable entities
- Define repository capabilities in domain language
- Add use cases only for meaningful policy/coordination
- Reuse the project result/failure type

No Flutter, HTTP, storage, or SDK imports in domain.

### 3. Implement data access

```text
features/[feature]/data/
  datasources/      # only sources actually used
  models/
  repositories/
```

- Parse external data into models
- Map models to entities explicitly
- Route client exceptions through central translation
- Return typed failures at the repository boundary
- Do not create an empty local source for symmetry

Follow [Adding Data Access](adding_data_access.md).

### 4. Register dependencies

Create one feature injector and register:

```text
state holder (factory)
  → use cases (lazy singleton)
    → repository contract → implementation
      → actual data sources
```

Add the injector to the root registry. Add a resolution smoke test.

### 5. Build presentation

- Define immutable state and events/methods
- Cover initial, loading, content, empty, error, and terminal session states
- Create the route-scoped state holder
- Build feature-local widgets using shared UI and theme roles
- Add route arguments and registration

Follow [Adding Presentation](adding_presentation.md).

### 6. Test the vertical slice

Minimum:

- Use case success and failure
- Repository mapping and exception conversion
- State transitions
- Critical widget states
- Route argument contract

See [Testing Strategy](../quality/testing_strategy.md).

### 7. Document

- Add/update a pattern only if the feature introduces reusable technical behavior
- Record a significant new architectural decision as an ADR
- Update environment example and integration docs for new configuration
- Add user-facing copy to every supported ARB and run `flutter gen-l10n`
- Update the catalog when adding a pattern

## Registration checklist

```text
[ ] Feature injector added to root
[ ] State holder registered as factory/route-scoped
[ ] Route name and typed args registered
[ ] Environment keys added to example file, if any
[ ] Native permissions/config added on both platforms, if any
[ ] Analytics/diagnostic event names registered, if any
```

## Common mistakes

- Starting with screens before defining data/failure contracts
- One feature per screen instead of one cohesive capability
- Direct feature-to-feature imports
- Creating every scaffold file even when unused
- Global UI provider instead of route scope
- New shared component that has only one consumer
- Happy path implemented without empty, error, and retry states

## Related documents

- [Architecture Overview](../architecture/architecture_overview.md)
- [Dependency Injection](../patterns/dependency_injection.md)
- [Feature and Screen Specification](../templates/feature_and_screen_spec.md)
