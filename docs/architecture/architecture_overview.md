# Architecture Overview

A feature-first, layered architecture for Flutter applications. It scales from a small client to a large application by adding boundaries only when they buy testability, replaceability, or clearer ownership.

---

## The default shape

```text
Presentation          Domain                    Data
──────────────        ───────────────           ───────────────────
Screen / View   ───▶  Use case          ───▶    Repository impl
State holder           Entity                    Remote data source
UI-only provider       Repository contract       Local data source
                                                  Model / mapper
```

The central data flow is:

```text
user action
  → state holder event/method
    → use case
      → repository contract
        → repository implementation
          → data source
            → external system
```

The result flows back as a typed success or failure. Presentation renders the state; it does not interpret transport exceptions.

---

## Layer responsibilities

### Presentation

**Owns:**

- Screens and smaller widget composition
- User events and navigation requests
- Renderable state: initial, loading, content, empty, error
- Ephemeral input state such as selected values and form text
- Translation from domain failures into user-facing state

**Must not own:**

- HTTP calls, storage calls, or transport response parsing
- Business decisions that should be testable without Flutter
- Credentials or token refresh
- Data-model serialization

A screen may call a state holder. A state holder calls a use case. Neither calls a data source directly.

### Domain

**Owns:**

- Entities: stable concepts the application reasons about
- Repository contracts: what data capability the domain needs, independent of mechanism
- Use cases: one meaningful business operation per type
- Domain validation and calculation
- Shared result/failure abstractions

**Must not depend on:**

- Flutter widgets
- HTTP, storage, analytics, or platform packages
- Data-layer models
- A specific state-management library

A domain layer that imports the network client is not a domain layer; it is data access in the wrong folder.

### Data

**Owns:**

- Repository implementations
- Remote and local data sources
- Transport and persistence models
- Mapping between models and domain entities
- Serialization and response validation
- Translation from low-level exceptions into typed failures at the repository boundary

The data layer may depend on domain contracts and entities. Domain must never import back from data.

---

## Contracts at boundaries

Each boundary should be visible in a type signature:

```dart
// Domain contract: says what, not how.
abstract interface class ItemRepository {
  ResultFuture<Item> loadItem(ItemId id);
}

// Use case: one operation.
final class LoadItem {
  const LoadItem(this._repository);
  final ItemRepository _repository;

  ResultFuture<Item> call(ItemId id) => _repository.loadItem(id);
}

// Data implementation: chooses the mechanism.
final class ItemRepositoryImpl implements ItemRepository {
  const ItemRepositoryImpl(this._remote);
  final ItemRemoteDataSource _remote;

  @override
  ResultFuture<Item> loadItem(ItemId id) async {
    try {
      final model = await _remote.loadItem(id.value);
      return Right(model.toEntity());
    } on ServerException catch (error) {
      return Left(FailureMapper.fromException(error));
    }
  }
}
```

The exact result library is replaceable. The non-negotiable part is the contract: callers cannot forget that failure is possible.

---

## Use cases

**Preferred convention.** Use one class per operation when the operation has business meaning, is reused, or deserves isolated tests.

```dart
abstract class UseCaseWithParams<T, P> {
  const UseCaseWithParams();
  ResultFuture<T> call(P params);
}

abstract class UseCaseWithoutParams<T> {
  const UseCaseWithoutParams();
  ResultFuture<T> call();
}
```

**Do not create an empty pass-through type for every repository call mechanically.** In a small feature where a state holder is the only caller and the operation has no policy, calling the repository contract directly may be a reasonable simplification. See [Scalability Guidelines](scalability_guidelines.md).

**Add a use case when at least one is true:**

- The operation coordinates more than one repository or service
- It enforces business rules
- More than one state holder calls it
- It deserves an isolated test name
- It translates parameters or results at a domain boundary

---

## Repository contracts

Repositories model capabilities in domain language, not HTTP resources.

Good:

```dart
Future<Result<User>> loadCurrentUser();
Future<Result<void>> savePreference(Preference preference);
```

Leaky:

```dart
Future<Response> getUsersMe();
Future<Map<String, dynamic>> postPreference(Map body);
```

**Mandatory.** A repository contract returns domain entities or domain-safe primitives, never a transport response, DTO, database row, or untyped map.

---

## Data sources

A data source wraps one external mechanism. Create only the sources the feature actually uses.

```text
data/datasources/
  item_remote_data_source.dart     # HTTP/remote SDK
  item_local_data_source.dart      # cache/database/preferences — only if needed
```

**Optional.** Do not generate a local data source for every feature by ritual. In the reference implementation, 12 of 14 features have one, but several are seven-line stubs. An unused abstraction adds navigation cost without creating a boundary.

Use an abstract contract when the source will be faked in tests or has multiple implementations. Otherwise, a concrete injected type is enough.

---

## State management

The architecture does not mandate a specific state library. It mandates ownership:

- Async domain operations live in a route-scoped state holder
- Ephemeral UI state lives as close to its widget as practical
- Global state is reserved for genuinely global concerns
- State transitions are explicit and testable

The reference implementation uses event-driven blocs for domain operations and `ChangeNotifier` providers for form/UI state. The separation is sound; registering every UI provider globally is not. See [State Management](../patterns/state_management.md).

---

## Shared infrastructure

Cross-cutting capabilities live outside features:

```text
core/
  errors/
  network/
  routing/
  storage/
  logging/
  configuration/
  theme/
  shared_ui/
```

A capability shared by several features and carrying its own data/domain layers may become a **shared module** rather than a loose utility. See [Project Structure and Boundaries](project_structure_and_boundaries.md).

---

## Cross-feature communication

**Mandatory.** A feature must not import another feature's data or presentation layer.

Preferred options, in order:

1. Move the genuinely shared capability to a core module
2. Depend on a domain contract exposed through a shared boundary
3. Coordinate at the application/navigation layer
4. Pass a small domain-safe value as a route argument

Direct feature-to-feature entity imports are a warning sign. They create an implicit shared domain whose ownership is unclear. If two features repeatedly share types, name the shared capability and extract it deliberately.

---

## What is mandatory, recommended, and optional

| Element | Level | Reason |
|---|---|---|
| Dependency direction | **Mandatory** | Prevents framework and transport leakage into domain |
| Typed failure at repository boundary | **Mandatory** | Makes expected failure explicit |
| Repository contract | **Preferred**; mandatory when remote/local implementations or tests need a seam | Small read-only features may not benefit |
| Use case per operation | **Preferred** | Valuable for policy and reuse; can be ceremony for trivial pass-throughs |
| Separate data model and entity | **Preferred**; mandatory when schemas diverge | Avoid duplicate types with identical shape in tiny features |
| Abstract data-source interface | **Context-dependent** | Useful test seam, but unnecessary when the repository itself is the seam |
| Local data source | **Optional** | Only when persistence/caching exists |
| Full three-layer folders | **Context-dependent by project scale** | See scalability guidelines |

---

## Related documents

- [Project Structure and Boundaries](project_structure_and_boundaries.md)
- [Dependency Rules](dependency_rules.md)
- [Scalability Guidelines](scalability_guidelines.md)
- [State Management](../patterns/state_management.md)
- [Error Handling](../patterns/error_handling.md)
- [Data Mapping](../patterns/data_mapping.md)
