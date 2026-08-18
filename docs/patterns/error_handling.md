# Error Handling

**Status: Mandatory for layer boundaries.**

Expected failures are typed values. Low-level exceptions are translated once. UI receives a stable, safe message and a failure kind — never a client-library exception or arbitrary backend object.

---

## Error taxonomy

Use three levels:

```text
Transport/storage layer    throws typed exceptions
Repository boundary        catches and returns typed failures
Presentation               maps failures to renderable state
```

```dart
sealed class Failure {
  const Failure({required this.userMessage, this.cause});
  final String userMessage;
  final Object? cause;
}

final class NetworkFailure extends Failure { /* offline/timeout */ }
final class UnauthorizedFailure extends Failure { /* session invalid */ }
final class ValidationFailure extends Failure { /* rejected input */ }
final class ServerFailure extends Failure { /* remote 5xx */ }
final class StorageFailure extends Failure { /* local read/write */ }
final class UnexpectedFailure extends Failure { /* defect boundary */ }
```

Prefer semantic kinds over exposing numeric HTTP codes upward. Presentation should ask `failure is UnauthorizedFailure`, not `failure.statusCode == 401`.

---

## Central transport translation

```dart
abstract final class TransportExceptionMapper {
  static Never throwMapped(DioException error) {
    if (error.type == DioExceptionType.cancel) {
      throw const RequestCancelledException();
    }

    final statusCode = error.response?.statusCode;
    if (statusCode == 401 || statusCode == 403) {
      throw const ServerException.unauthorized();
    }
    if (statusCode == 400 || statusCode == 422) {
      throw const ServerException.validation();
    }
    if (statusCode != null && statusCode >= 500) {
      throw const ServerException.server();
    }
    if (error.type == DioExceptionType.connectionError) {
      throw const ServerException.network();
    }
    throw const ServerException.rejected();
  }
}
```

Returning `Never` tells both compiler and reader that execution cannot continue. **Mandatory.** Do not reimplement this switch in each data source.

---

## Repository translation

```dart
@override
ResultFuture<Item> loadItem(ItemId id) async {
  try {
    final model = await _remote.load(id.value);
    return Right(model.toEntity());
  } on ServerException catch (error, stack) {
    _logger.nonFatal(error, stack, reason: 'load item failed');
    return Left(FailureMapper.fromException(error));
  }
}
```

Repository catches only failures it knows how to translate. Do not catch every `Object` and label programming defects as server errors; type errors and invariant violations should remain visible in development and diagnostics.

If a final safety boundary catches unexpected errors, return a generic safe failure and log the original with stack trace.

---

## User messages versus diagnostics

One error has two representations:

- **User message:** safe, concise, actionable, localizable
- **Diagnostic context:** original error, stack, operation, non-sensitive identifiers, correlation ID

Never show `error.toString()` to the user. Never send sensitive payloads to diagnostics.

Backend-provided messages may contain implementation detail or inconsistent wording. Allowlist or normalize them before display.

---

## Failure status in presentation

Every asynchronous operation must exit loading on every path:

```dart
emit(const Loading());
final result = await loadItem(id);
result.fold(
  (failure) => emit(failure.toState()),
  (item) => emit(Loaded(item)),
);
```

A session-expired branch is still a state transition even when navigation is handled globally; otherwise the old screen remains stuck in loading behind the destination.

---

## Validation errors

Client-side validation failures do not travel through the network exception path. They are domain or presentation validation results, tied to fields where possible.

Server-side validation is translated into a stable typed failure. If field errors are supported, model them explicitly rather than parsing strings.

---

## Cancellation

Cancellation is expected control flow when a route closes or a search query changes. It should normally:

- Stop work
- Avoid user-facing error UI
- Avoid error-level diagnostics
- Leave state in an intentional state

Do not map cancellation to "Something went wrong."

---

## Common mistakes

- Numeric status-code checks scattered across blocs
- `catch (e) => Left(ServerFailure(message: e.toString()))`
- Full response logging on endpoints carrying personal data
- Treating malformed response as offline
- Returning null for failure, erasing its cause
- Catching `Object` in every layer
- Duplicate user messages hardcoded in data sources and widgets
- Error state with no retry path for recoverable operations

---

## Testing

- Every client exception type maps to the expected remote exception
- Repository maps each typed exception to the correct failure
- Unknown/malformed error body never crashes the mapper
- Sensitive backend content is not exposed
- Cancellation does not emit failure UI
- Every state-holder operation leaves loading on all outcomes
- Session expiry maps consistently across features

---

## Related documents

- [Networking](networking.md)
- [State Management](state_management.md)
- [Logging and Diagnostics](logging_and_diagnostics.md)
- [Testing Strategy](../quality/testing_strategy.md)
