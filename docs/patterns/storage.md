# Local and Secure Storage

**Status: Optional capability; mandatory sensitivity rules.**

Choose storage by the data's sensitivity, volume, query needs, and lifecycle. "Local storage" is not one mechanism.

---

## Decision table

| Data | Recommended mechanism | Examples |
|---|---|---|
| Credentials and recovery material | Platform-backed encrypted storage | Access/refresh tokens, sensitive identifiers |
| Small non-sensitive preferences | Key-value preferences | Theme mode, onboarding seen, sort choice |
| Structured/queryable data | Embedded database | Offline records, history, indexed collections |
| Temporary downloaded media | File cache with eviction | Thumbnails, documents, images |
| In-memory transient state | State holder/service | Current tab, unsaved form |

**Mandatory.** Never place tokens, passwords, private keys, sensitive identity data, or payment material in plain preferences.

---

## Storage gateway

Hide package APIs behind capability-focused interfaces when storage is used broadly or carries policy:

```dart
abstract interface class SecureSessionStorage {
  Future<TokenPair?> readTokens();
  Future<void> writeTokens(TokenPair pair);
  Future<void> clear();
}

abstract interface class PreferenceStore {
  Future<ThemePreference> readTheme();
  Future<void> writeTheme(ThemePreference value);
}
```

Avoid a generic `get(String key)` gateway spread throughout features. Typed methods centralize keys, defaults, migrations, and sensitivity classification.

---

## Key ownership

- Define keys in one private location per storage gateway
- Prefix or namespace by capability
- Never reuse a key for a different type
- Document deletion behavior
- Treat key renames as data migrations, not refactors

A persisted key is a public contract with installed application versions.

---

## In-memory cache over secure storage

Encrypted storage can be relatively expensive. A session manager may cache values in memory after load:

```text
read:
  if in-memory value exists → return
  else read encrypted storage → cache → return

write:
  update memory and persistence as one operation

clear:
  clear memory first, then every persisted session key
```

If persistence fails after memory changes, record diagnostics and decide whether to roll back. For credentials, inconsistent state should normally force a clean session rather than continue ambiguously.

---

## Local data source threshold

**Optional.** Create a local data source only when the feature reads or writes local data. Do not generate one for symmetry. The reference implementation shows why: most features have a local-source file, but several are tiny stubs that protect no boundary.

A useful local source owns at least one of:

- Serialization format
- Cache key strategy
- Expiry policy
- Database query
- Migration
- Secure storage interaction

If none applies, no local source is needed.

---

## Cache policy

A repository that combines remote and local sources must make policy explicit:

| Policy | Behavior | Use when |
|---|---|---|
| Cache-first | Return valid cache, refresh later | Fast, tolerates slightly stale data |
| Network-first | Request remote, fall back to cache | Freshness preferred; offline degradation |
| Stale-while-revalidate | Emit cache, then updated remote | Reactive UI, best perceived speed |
| Cache-only | Never request remote | Downloaded/offline content |

Record freshness metadata. A cached value without age or version cannot support a rational expiry decision.

---

## Migration and corruption

- Version structured schemas
- Define migration before changing a persisted shape
- Treat decoding failure as a recoverable storage failure where possible
- Clear only the corrupt capability's data, not all application storage
- Do not silently reinterpret old data under a new schema

For preferences, migrations can be a read-old/write-new/delete-old sequence. Make it idempotent so a crash halfway through can resume safely.

---

## File cache

**Optional.** Use a cache manager for downloaded files when:

- Eviction and age limits matter
- The same URL is requested repeatedly
- Offline viewing is useful

Do not use a file cache as durable user storage. Cached files may be evicted at any time. User-created or paid-for content requires a documented durable location and backup policy.

---

## Testing

- Read/write/delete round-trip
- Missing key returns documented default
- Corrupt value produces typed failure or migration
- Session clear deletes every session-related key
- Cache expiry boundary
- Network-first fallback to cache
- Concurrent writes to the same key
- Migration is idempotent
- No sensitive value is written to the plain preference fake

---

## Related documents

- [Authentication and Tokens](authentication_and_tokens.md)
- [Pagination and Caching](pagination_and_caching.md)
- [Secure Coding and Credentials](../security/secure_coding_and_credentials.md)
- [Adding Data Access](../workflows/adding_data_access.md)
