# Session Security

**Status: Mandatory for authenticated projects.**

## Storage and memory

- Access and refresh tokens in platform encrypted storage
- In-memory copies private to session manager
- No tokens in preferences, URLs, route args, logs, analytics, or crash keys
- Clear every session and recovery key on unrecoverable expiry/account removal
- Keep only explicitly documented non-sensitive recovery metadata on ordinary sign-out

## Token lifecycle

- Attach tokens centrally in an interceptor
- Refresh through a separate non-intercepted client
- Coordinate concurrent refresh as single-flight
- Bound original request replay to once
- Distinguish transient refresh failure from invalid token
- Rotate refresh token when backend provides a replacement
- Restore multipart bodies before replay

See [Authentication and Token Management](../patterns/authentication_and_tokens.md).

## Authorization

Authentication proves a session; authorization decides access. The client may hide or disable UI, but server-side checks remain authoritative. Never infer authorization from a deep-link destination, notification payload, or locally stored role alone.

## Session expiry

One coordinator handles invalid session exactly once:

```text
invalid refresh
  → clear secure session atomically
  → global typed expiry event
  → reset protected navigation stack
  → recovery/sign-in entry point
  → one user-facing message
```

Feature state holders leave loading but do not independently navigate. Numeric unauthorized checks scattered across features create inconsistent expiry behavior and are prohibited.

## Re-authentication

Sensitive operations may require recent authentication even within a valid session. Model this explicitly with a server-enforced re-auth window. Biometrics may unlock a local credential or confirm user presence, but do not replace server authorization.

## Session fixation and switching

- Clear previous user caches before establishing another user's session
- Namespace local caches by user where needed
- Do not carry pending protected intents across user switch
- Set the complete new token pair atomically where possible
- Reset any "expiry handled" guard after successful new session

## Network and offline

A network outage does not invalidate a session. Preserve encrypted credentials on timeout/connection/server transient failure. Offline access to cached protected data requires an explicit product/security policy and local data protection.

## Diagnostics

Safe events include: refresh outcome kind, retry count, session state transition, and whether secure clear succeeded. Never include token values or sensitive user data.

## Testing

- Secure restore and complete clear
- One refresh for concurrent unauthorized responses
- Transient failure preserves session
- Invalid refresh clears all keys and protected cache
- Replay bounded to once
- User switch clears previous state
- Session-expiry effect emitted once
- Re-auth required operation rejects stale authentication
- Deep link cannot bypass authorization

## Related documents

- [Authentication and Tokens](../patterns/authentication_and_tokens.md)
- [Storage](../patterns/storage.md)
- [Transport Security](transport_security.md)
- [Routing](../patterns/routing.md)
