# Authentication and Token Management

**Status: Optional capability; mandatory safety rules when adopted.**

Authentication spans secure storage, request interception, refresh coordination, retry, session expiry, navigation, and state recovery. Treat it as one coherent subsystem. Implementing each concern independently creates races and contradictory behavior.

---

## Components

```text
SessionManager          owns in-memory token cache + encrypted persistence
AuthInterceptor         attaches access token, detects unauthorized response
RefreshClient           performs refresh without the auth interceptor
RefreshCoordinator      ensures concurrent failures trigger one refresh
SessionCoordinator      handles unrecoverable expiry once
Presentation            leaves loading state; does not navigate independently
```

---

## Session manager

```dart
final class SessionManager {
  SessionManager(this._secureStorage);

  final SecureStorage _secureStorage;
  String? _accessToken;
  String? _refreshToken;

  bool get hasSession => _accessToken?.isNotEmpty == true;

  Future<void> load() async { /* read all keys */ }
  Future<String?> getAccessToken() async { /* cache, then storage */ }
  Future<void> setTokens(TokenPair pair) async { /* memory + storage */ }
  Future<void> clear() async { /* clear every related key */ }
}
```

**Mandatory.** Tokens use encrypted platform storage. They must never be written to plain preferences, logs, crash metadata, analytics, or route arguments.

The in-memory cache avoids an encrypted-storage read on every request. Persistence remains the source across process restarts.

---

## Request attachment

For every protected request:

1. Read the current access token
2. Attach the authorization header
3. Record which token the request used in request metadata
4. Pass through

Public endpoints mark `skipAuth`; features do not manually remove headers.

---

## Single-flight refresh

If ten requests receive an unauthorized response together, they must wait for **one** refresh, not issue ten refresh calls.

```dart
Future<RefreshOutcome> refreshOnce() async {
  final active = _inFlightRefresh;
  if (active != null) return active.future;

  final completer = Completer<RefreshOutcome>();
  _inFlightRefresh = completer;
  try {
    final outcome = await performRefresh();
    completer.complete(outcome);
    return outcome;
  } finally {
    _inFlightRefresh = null;
  }
}
```

Also detect a race where another request already refreshed the token before this unauthorized response was handled:

```text
if token used by failed request != current stored token
  → retry with current token; do not refresh again
```

---

## Refresh outcomes

Do not reduce refresh to boolean success/failure. At minimum:

| Outcome | Meaning | Action |
|---|---|---|
| `success` | New access token accepted | Retry original request once |
| `transient` | Network/timeout/server/malformed temporary response | Preserve session; return retryable failure |
| `invalid` | Refresh token absent or explicitly rejected | Clear session; trigger expiry flow once |

**Mandatory.** A transient failure must not clear the session. Logging users out because a mobile connection dropped is a serious UX and data-loss defect.

**Mandatory.** A refresh response missing a new access token is not success. Whether it is transient or invalid depends on the backend contract; decide and document.

---

## Request replay

Before replay:

- Mark `retried = true`
- Replace the authorization header
- Restore any consumed multipart body from a snapshot
- Use the original method, URL, query, headers, and cancellation policy

The interceptor must reject an unauthorized response from an already-retried request. Otherwise invalid credentials create an infinite loop.

---

## Session expiry

One coordinator owns the user-visible effect:

```text
invalid refresh
  → clear all session material atomically
  → emit one global SessionExpired event
  → coordinator navigates to the recovery entry point
  → coordinator shows one message
```

Guard the effect so concurrent failures do not push the same screen and snackbar repeatedly. Reset the guard only after a new valid session starts.

Presentation state holders still need to leave loading. They should map the typed `SessionExpiredFailure` to a quiet terminal state — but they should **not also navigate**, or session expiry has two owners.

---

## Startup restoration

Load the session before deciding the startup route. A race between rendering and encrypted-storage restoration causes a logged-in user to flash the logged-out flow.

A staged bootstrap may restore session, validate app prerequisites, and then route. See [Application Bootstrap](app_bootstrap.md).

---

## Sign out versus clear session

Define the difference explicitly:

- `signOut()` may remove tokens but retain a non-sensitive identifier used for PIN/biometric re-entry
- `clearSession()` removes all session and recovery material after invalid refresh or account removal

Every related key must be listed centrally. Orphaned recovery keys are a security and behavior defect.

---

## Common mistakes

- Refresh call uses the primary intercepted client and recurses
- Multiple concurrent refreshes overwrite each other's token pairs
- Any refresh error logs the user out
- Original request retries without a guard
- Multipart upload cannot be replayed
- State holders each inspect numeric status codes and navigate independently
- Token values appear in debug logs — **never acceptable**
- Session clear removes only access token but leaves refresh token or cached user identity

---

## Testing

Authentication needs race tests, not just happy-path tests:

1. Token attaches to protected requests, not public ones
2. One unauthorized request refreshes and replays
3. Ten concurrent unauthorized requests perform one refresh and all replay
4. Request that used a stale token retries using an already-refreshed token
5. Transient refresh preserves session
6. Invalid refresh clears every session key
7. Already-retried unauthorized response does not loop
8. Multipart request replays successfully
9. Concurrent invalid responses trigger one navigation effect
10. Session restoration chooses the correct startup state

---

## Related documents

- [Networking](networking.md)
- [Storage](storage.md)
- [Session Security](../security/session_security.md)
- [Routing](routing.md)
- [Error Handling](error_handling.md)
