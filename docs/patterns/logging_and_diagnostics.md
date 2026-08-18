# Logging and Diagnostics

**Status: Preferred; mandatory redaction rules.**

Diagnostics should make production failures understandable without coupling the project to a vendor or exposing private data.

---

## Project-owned logger

```dart
abstract interface class AppLogger {
  void debug(String message, {Map<String, Object?> context = const {}});
  void nonFatal(
    Object error,
    StackTrace stack, {
    required String reason,
    Map<String, Object?> context = const {},
  });
  void fatal(Object error, StackTrace stack, {required String reason});
}
```

The production implementation may send to crash reporting; development may print. Features inject `AppLogger`, not the SDK.

This is a mature pattern in the reference implementation: a narrow logger abstraction wraps crash diagnostics and supports custom context without spreading the provider type.

---

## Levels and intent

| Level | Use |
|---|---|
| Debug | Local development detail; compiled out or disabled in release |
| Info | Significant lifecycle/operation milestones, used sparingly |
| Warning/non-fatal | Recoverable unexpected condition worth investigation |
| Fatal | Application cannot safely continue or unhandled crash |

Expected business rejection is usually not a crash event. Recording every validation error as non-fatal creates noise that hides defects.

---

## Structured context

Prefer bounded key/value context to interpolated paragraphs:

```dart
logger.nonFatal(
  error,
  stack,
  reason: 'remote configuration refresh failed',
  context: {
    'source': 'bootstrap',
    'usingFallback': true,
  },
);
```

Useful context:

- Operation/capability name
- App version and environment (usually SDK-provided)
- Safe state enum
- Correlation/request ID
- Whether a fallback was used
- Retry count

Never attach the full request body "for debugging."

---

## Redaction

**Mandatory. Never log:**

- Access or refresh tokens
- Passwords, PINs, one-time codes
- Authorization headers
- Payment/card data
- Identity document content or paths
- Full addresses or precise location
- Push registration tokens
- Presigned upload URLs
- Private API keys or certificate material

Identifiers should be omitted, irreversibly hashed, or reduced to a non-sensitive internal correlation value according to policy. A short token prefix is still credential material and must not be logged.

Diagnostic metadata is data collection. Apply retention and privacy requirements to it.

---

## Flutter error boundaries

Wire framework and platform errors before application startup:

```dart
FlutterError.onError = (details) {
  logger.fatal(details.exception, details.stack ?? StackTrace.empty,
      reason: 'Flutter framework error');
};

PlatformDispatcher.instance.onError = (error, stack) {
  logger.fatal(error, stack, reason: 'Uncaught platform error');
  return true;
};
```

Test initialization order: the logger must be available before handlers use it, and logger failure must not recursively crash.

---

## Analytics versus diagnostics

Keep separate APIs and taxonomies:

- **Diagnostics** explain failures and technical state
- **Analytics** measure user/product behavior

Do not repurpose crash custom keys as analytics. Consent, retention, and sampling requirements differ.

An analytics abstraction should use event types or a controlled event catalog, not arbitrary strings scattered through widgets.

---

## Remote-config and security events

Security-sensitive configuration should emit diagnostics when:

- Fallback is active
- Remote value fails validation
- Pin set is near expiry
- Refresh is stale
- Integrity enforcement changes state

Do not include the pin values or raw security payload.

---

## Common mistakes

- Printing session tokens during development and accidentally shipping logs
- `debugPrint(error.toString())` without stack or operation context
- Every repository logs the same exception, producing duplicate events
- Generic reason "API error" with no operation
- Full remote response attached to crash report
- Crash SDK imported directly by every feature
- Expected validation failures recorded as crashes
- Fatal handler initialized after risky startup work

---

## Testing

- Fake logger receives expected reason and safe context
- Sensitive fields are redacted/omitted
- Fallback paths record one non-fatal event
- Same error is not recorded at multiple layers
- Release configuration suppresses debug detail
- Framework/platform error handlers forward errors with stacks
- Logger implementation failure does not recurse

---

## Related documents

- [Error Handling](error_handling.md)
- [Configuration](configuration.md)
- [Secure Coding and Credentials](../security/secure_coding_and_credentials.md)
- [Application Bootstrap](app_bootstrap.md)
