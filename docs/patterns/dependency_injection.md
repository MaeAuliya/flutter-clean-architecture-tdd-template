# Dependency Injection

**Status: Preferred.** Constructor injection is mandatory at layer boundaries; the choice of container is context-dependent.

Dependency injection separates object construction from behavior. It makes dependencies visible, enables test substitution, and keeps package initialization in one composition root.

---

## Recommended shape

Use a small injector per feature or shared module, coordinated by one root container. This template uses `GetIt` as the locator:

```dart
abstract class Injector {
  Future<void> inject(GetIt sl);
}

class ProfileInjector implements Injector {
  const ProfileInjector();

  @override
  Future<void> inject(GetIt sl) async {
    sl
      ..registerFactory(
        () => ProfileBloc(loadProfile: sl(), updateProfile: sl()),
      )
      ..registerLazySingleton(() => LoadProfile(repository: sl()))
      ..registerLazySingleton<ProfileRepository>(
        () => ProfileRepositoryImpl(remoteDataSource: sl(), logger: sl()),
      )
      ..registerLazySingleton<ProfileRemoteDataSource>(
        () => ProfileRemoteDataSourceImpl(client: sl()),
      );
  }
}
```

The root injects infrastructure first, then features:

```dart
await const CoreInjector().inject(sl);
await Future.wait(_injectors.map((i) => i.inject(sl)));
```

Core must finish first because feature injectors resolve its HTTP client, storage, and logging abstractions. Feature injectors may run concurrently only when they do not depend on one another.

**Composition registry.** Each injector is listed in `InjectionContainer._injectors` at a `// GENERATED ... - DO NOT REMOVE` marker. The feature generator inserts the entry there and the deleter removes it — preserve those markers. Never register a feature's dependencies anywhere else.

---

## Registration lifetime

| Type | Lifetime | Reason |
|---|---|---|
| Bloc/cubit/controller | Factory | Mutable state must not leak across routes |
| Stateless use case | Lazy singleton | Immutable and cheap to share |
| Repository | Lazy singleton | Stateless coordinator over sources |
| Data source | Lazy singleton | Wraps shared client/storage |
| HTTP client, storage, logger | Singleton | One configured infrastructure instance |
| Route-scoped UI provider | **Construct at route**, not global DI | Scope should match the UI lifecycle |

**Mandatory.** Never register a mutable feature state holder as a singleton unless the state is intentionally application-global and its reset lifecycle is documented.

---

## Constructor injection

Dependencies are named, required, and assigned to private final fields:

```dart
final class RepositoryImpl implements Repository {
  const RepositoryImpl({
    required RemoteDataSource remote,
    required CacheDataSource cache,
  }) : _remote = remote,
       _cache = cache;

  final RemoteDataSource _remote;
  final CacheDataSource _cache;
}
```

This shape is readable at the call site, immutable, and friendly to tests.

**Mandatory.** Business classes must not call the global service locator from inside methods. The locator belongs at composition boundaries — application setup and route factories. Hidden service location turns dependencies into runtime surprises and makes tests order-dependent.

Composition-root files under `core/services/injection/injectors/` and `core/services/router/registries/` are the exception to the layering matrix: assembling features is their job, so they may import feature blocs, providers, screens, and data sources. No other file under `core/` may. See [Dependency Rules](../architecture/dependency_rules.md).

---

## Extension workflow

When adding a feature:

1. Create one injector beside the other injectors. The feature generator does this for you.
2. Register from outermost state holder inward: bloc → use cases → repository → sources.
3. Use interfaces for repository contracts and sources that need test fakes.
4. Add the injector to the root list at the generated marker.
5. Create route-scoped state holders as factories.
6. Write a container smoke test that resolves the feature's state holder.

When adding an infrastructure dependency:

1. Create the project-owned abstraction if the SDK should not spread.
2. Register the concrete implementation in `CoreInjector`.
3. Inject the abstraction into consumers.
4. Do not call the SDK's singleton getter throughout features.

---

## Common mistakes

- **Global mutable state.** Registering every form provider at application startup causes stale state to survive navigation and forces manual resets.
- **Parallel injector race.** Feature A resolves something Feature B registers while both inject concurrently. Shared dependencies belong in core, which injects first.
- **Duplicate registration.** Two injectors claim the same interface. Containers vary in behavior; some throw, others silently overwrite.
- **Commented registrations.** Disabled registration code left in place implies a capability exists when it does not. Delete dead code and rely on history.
- **Registering a dependency nothing resolves.** A registration with no consumer is dead weight that reads as a live capability. If a client, gateway, or config object is registered but never injected, remove it or wire it.

---

## Testing

- Unit tests instantiate the class directly with fakes; do not initialize the global container.
- Add one composition test per injector that verifies its primary entry point resolves.
- Reset the container between composition tests.
- A dependency cycle should fail at startup, not on the first user action.

---

## Related documents

- [Dependency Rules](../architecture/dependency_rules.md)
- [State Management](state_management.md)
- [Adding a Feature](../workflows/adding_feature.md)
- [Recommended Tech Stack](../reference/recommended_tech_stack.md)
