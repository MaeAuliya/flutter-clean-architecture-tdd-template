# Data Mapping and Serialization

**Status: Preferred; mandatory when external and domain schemas can evolve independently.**

Models represent external schemas. Entities represent the application's concepts. Mapping prevents an API rename, nullable wire field, or database migration from leaking into presentation and business rules.

---

## Recommended types

```dart
// Stable domain type.
final class User extends Equatable {
  const User({required this.id, required this.displayName});
  final UserId id;
  final String displayName;
}

// Wire/storage type.
final class UserModel {
  const UserModel({required this.id, required this.name});
  final String id;
  final String name;

  factory UserModel.fromMap(Map<String, dynamic> map) { /* validate */ }
  Map<String, dynamic> toMap() => {'id': id, 'name': name};
  User toEntity() => User(id: UserId(id), displayName: name);
  factory UserModel.fromEntity(User entity) { /* convert */ }
}
```

The reference implementation frequently uses `Model extends Entity`. That reduces duplication, but couples wire fields to domain inheritance and lets models cross boundaries unnoticed. Composition with explicit `toEntity()` is preferred for new projects because the boundary stays visible.

**Context-dependent.** Model-extends-entity can be acceptable for simple immutable read models whose wire and domain shapes are intentionally identical. Stop using it as soon as either side diverges.

---

## Parsing

**Mandatory.** Parsing validates required fields and reports a typed malformed-response error. Avoid unchecked casts.

```dart
factory UserModel.fromMap(Map<String, dynamic> map) {
  final id = map['id'];
  final name = map['name'];
  if (id is! String || id.isEmpty || name is! String) {
    throw const DataFormatException('Invalid user payload');
  }
  return UserModel(id: id, name: name);
}
```

Treat nullability as part of the schema, not a convenience. A required domain value should not become `String?` merely because the backend sometimes omits it; either reject the malformed response or define a deliberate fallback at the mapping boundary.

---

## Request parameters

Domain parameter types express intent:

```dart
final class UpdateUserParams {
  const UpdateUserParams({required this.displayName});
  final String displayName;
}
```

Data converts them to a request model or map:

```dart
final body = UpdateUserRequest.fromDomain(params).toMap();
```

This prevents transport key names from spreading into use cases and state holders.

---

## Equality and immutability

- Entity and state fields are final
- Constructors are const when possible
- Collection fields are defensively immutable
- Equality includes every semantically relevant field
- `copyWith` preserves omitted values unambiguously

For nullable fields, a naïve `copyWith({String? value})` cannot distinguish "leave unchanged" from "set null." Use a sentinel or generated immutable model when null assignment is required.

---

## Serialization strategy

| Approach | Use when | Trade-off |
|---|---|---|
| Handwritten `fromMap`/`toMap` | Small schemas, custom validation, few models | Transparent; repetitive and typo-prone |
| Generated JSON serialization | Many stable DTOs | Less boilerplate; build step and annotations |
| Generated immutable unions | Rich state/domain models | Strong exhaustiveness; more tooling |
| Untyped maps throughout | Never beyond the parsing boundary | No compile-time contract |

Do not adopt code generation merely because it exists. Adopt it when model volume and maintenance cost exceed the build-tooling cost.

---

## Data-source versus repository mapping

Recommended ownership:

- Data source parses raw body → model
- Repository maps model → entity and exception → failure
- Presentation sees entity/failure only

This makes data source tests focus on protocol shape and repository tests focus on policy.

---

## Common mistakes

- Transport model imported by a bloc or widget
- Entity owns `fromJson` and mirrors backend field names
- `dynamic` survives beyond parsing
- `DateTime.parse` without timezone policy
- Monetary value represented as `double`
- Enum parser throws when backend introduces an unknown value — define an `unknown` case when forward compatibility matters
- Model inheritance used after domain and transport requirements diverge
- Request map assembled in a state holder

---

## Testing

For each model:

- Minimal valid payload
- Full payload
- Missing required field
- Null and wrong-type field
- Unknown enum value
- Round-trip only when round-trip is a real contract
- Entity/model mapping preserves every field and applies defaults intentionally
- Date, number, and locale edge cases

Use fixtures with fictional values; never copy production personal data or credentials into tests.

---

## Related documents

- [Architecture Overview](../architecture/architecture_overview.md)
- [Dependency Rules](../architecture/dependency_rules.md)
- [Error Handling](error_handling.md)
- [Adding Data Access](../workflows/adding_data_access.md)
