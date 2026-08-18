# Networking

**Status: Mandatory for networked projects.** The client package is replaceable; central configuration, endpoint ownership, and error translation are not.

---

## One configured client

Create the HTTP client once with explicit policy:

```dart
Dio createClient(API api) {
  return Dio(
    BaseOptions(
      baseUrl: api.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );
}
```

**Mandatory.** Every timeout is explicit. Library defaults change and can be unsuitable for mobile networks.

If authentication is later added, use a separate client for token refresh when the primary client carries an auth interceptor. Otherwise the refresh request can intercept itself and recurse.

---

## Endpoint ownership

Group endpoint paths by capability rather than scattering literals through sources:

```dart
class API {
  const API({
    this.baseUrl = const String.fromEnvironment('BASE_URL'),
    this.exampleAPI = const ExampleAPI(),
  });

  final String baseUrl;
  final ExampleAPI exampleAPI;
}

class ExampleAPI {
  const ExampleAPI({
    this.example = const String.fromEnvironment('EXAMPLE'),
  });

  final String example;
}
```

Alternative: static constants for paths that do not vary by environment. The critical rule is one owner and no literals in data-source methods.

**Legacy / anti-pattern.** A missing build-time key resolving to an empty string creates a request to the base URL and often fails misleadingly. Configuration accessors should validate required values at startup. See [Configuration](configuration.md).

---

## Remote data source

```dart
abstract interface class ItemRemoteDataSource {
  Future<ItemModel> load(String id);
}

final class ItemRemoteDataSourceImpl implements ItemRemoteDataSource {
  const ItemRemoteDataSourceImpl(this._dio, this._api);
  final Dio _dio;
  final API _api;

  @override
  Future<ItemModel> load(String id) async {
    try {
      final response = await _dio.get('${_api.exampleAPI.example}/$id');
      final payload = requireMap(response.data, key: 'data');
      return ItemModel.fromMap(payload);
    } on DioException catch (error) {
      TransportExceptionMapper.throwMapped(error);
    }
  }
}
```

The transport handler returns `Never`: it always throws a typed exception. Every Dio-backed data source should use this one mapper rather than repeat status and connection handling.

---

## Response validation

Do not chain unchecked index operations:

```dart
final data = response.data['data'] as Map<String, dynamic>;
```

A malformed backend response then becomes a generic type-cast error with no endpoint context.

Prefer named validation:

```dart
Map<String, dynamic> requireMap(Object? body, {required String key}) {
  if (body case {key: final Map value}) {
    return Map<String, dynamic>.from(value);
  }
  throw const ServerException.rejected(
    diagnosticMessage: 'Response payload is malformed',
  );
}
```

Log endpoint and correlation metadata through the diagnostics abstraction, never credentials or full sensitive payloads.

---

## Request metadata

Use request `extra`/metadata keys for interceptor coordination:

- `skipAuth` — public endpoint, no token
- `retried` — request has already been replayed
- `authToken` — token used by the original request, for refresh-race detection
- Replay snapshot — clone a multipart body before first send

Keep these keys private to the networking layer. A feature data source should request an authenticated or public call without knowing refresh internals.

---

## Multipart replay

Multipart/form bodies are often consumed when sent and cannot be reused. If the request may be retried after token refresh, snapshot or rebuild the body before the first attempt.

```dart
if (request.body is MultipartBody && request.replayBody == null) {
  request.replayBody = request.body.clone();
}
```

Failing to do this produces a subtle bug: ordinary requests recover from expiry, while uploads fail only when the token expires mid-upload.

---

## Retry policy

**Mandatory.** Authentication retry is bounded to one replay. Mark the request before replaying.

General network retries are context-dependent:

- Retry idempotent reads on selected transient failures, with backoff and jitter
- Do not automatically retry non-idempotent writes unless the API supports idempotency keys
- Cancellation is not an error to retry
- A 4xx response is normally not transient

---

## Connectivity

A connectivity plugin reports network interface state, not internet reachability. Treat it as a hint for UX, not proof that a request will succeed. The request remains the authoritative check.

Avoid blocking all requests behind a connectivity pre-check; the network can change between check and call.

---

## Security

- HTTPS only in production
- Never log authorization headers, refresh tokens, card data, or identity documents
- Validate hosts before applying custom certificate behavior
- Certificate pinning is optional and documented in [Transport Security](../security/transport_security.md)
- Keep API keys out of source and committed configuration

---

## Testing

- Data source success with valid response
- Malformed/missing payload
- Timeout, connection loss, cancellation
- 4xx with structured and unstructured error bodies
- 5xx mapped to a stable user message
- Multipart body survives auth replay
- Retried request cannot loop
- Public requests skip authentication

---

## Related documents

- [Authentication and Tokens](authentication_and_tokens.md)
- [Error Handling](error_handling.md)
- [Configuration](configuration.md)
- [Transport Security](../security/transport_security.md)
- [Adding Data Access](../workflows/adding_data_access.md)
