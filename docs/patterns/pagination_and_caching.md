# Pagination and Caching

**Status: Optional.**

Pagination controls incremental loading of large collections. Caching controls reuse and offline availability. They interact, but a project may need one without the other.

---

## Domain-safe page types

```dart
final class PageRequest {
  const PageRequest({required this.key, required this.size});
  final PageKey key;
  final int size;
}

final class PageResult<T> {
  const PageResult({
    required this.items,
    required this.nextKey,
    required this.hasMore,
  });
  final List<T> items;
  final PageKey? nextKey;
  final bool hasMore;
}
```

Use opaque `PageKey` when the API may switch between page number, offset, and continuation token. Do not let a UI widget assume `nextPage = currentPage + 1` unless the backend contract guarantees it.

---

## State

```dart
final class PaginatedState<T> {
  const PaginatedState({
    this.items = const [],
    this.nextKey,
    this.status = PageStatus.initial,
    this.loadMoreFailure,
  });

  final List<T> items;
  final PageKey? nextKey;
  final PageStatus status;
  final Failure? loadMoreFailure;
}
```

Differentiate initial load failure from load-more failure. An initial failure replaces the content; a load-more failure keeps existing content and offers a retry near the list end.

---

## Concurrency

**Mandatory when adopted.** Prevent duplicate page requests and stale result application.

- Ignore/load-coalesce a second request for the same key while in flight
- On filter/search refresh, increment a generation ID or cancel the old request
- Apply a result only if it belongs to the current generation
- Deduplicate items by stable identity when backend pages can overlap

```text
search "a" starts (generation 4)
search "ab" starts (generation 5)
"ab" returns → apply
"a" returns later → discard, because generation 4 is stale
```

---

## End detection

Prefer an explicit backend signal or next continuation token. Falling back to `items.length < pageSize` is acceptable only when documented by the API.

Never infer end from an empty page while ignoring an accompanying next continuation token.

---

## Refresh

A refresh:

1. Invalidates current generation
2. Resets next key
3. Requests the first page
4. Replaces items only on success, or follows documented stale-content policy

Decide whether a failed refresh preserves old content (often preferable) or clears it.

---

## Cache policy for pages

Caching pages independently can produce gaps after backend mutation. Better options:

- Cache the assembled list plus query/filter key and freshness metadata
- Use continuation token-keyed pages only when the backend guarantees stable ordering
- Invalidate cache when a write changes list membership or ordering

Cache key includes every input that changes the result: query, filter, sort, user/session scope, locale where relevant.

---

## Infinite-scroll trigger

Trigger load-more before the final item to hide latency, but guard by status and `hasMore`:

```dart
if (index >= items.length - prefetchDistance &&
    status != PageStatus.loadingMore &&
    hasMore) {
  loadMore();
}
```

A scroll listener or paging library may own this. Keep the repository's page contract independent of UI package types.

---

## Common mistakes

- Page-number assumption against continuation token API
- Same page requested repeatedly during rapid rebuild/scroll
- Old search result overwrites new query
- Load-more failure replaces the whole list
- Cache key omits filter or user scope
- New write appears twice because pages overlap
- Refresh appends rather than replaces
- Empty first page rendered as generic error instead of empty state

---

## Testing

- First page success/empty/failure
- Next page appends and updates key
- End-of-list stops requests
- Duplicate in-flight request coalesced
- Overlapping IDs deduplicated
- Stale generation discarded
- Load-more failure preserves items and retries
- Refresh replaces items
- Cache key varies for every query input
- Expired cache follows policy

---

## Related documents

- [Storage](storage.md)
- [Networking](networking.md)
- [State Management](state_management.md)
- [Performance and Accessibility](../quality/performance_and_accessibility.md)
