# Notifications and Deep Links

**Status: Optional.**

Push notifications and deep links are both external intents arriving outside the current widget flow. Route both through validated, typed commands and defer navigation until startup and session state are ready.

---

## Notification components

```text
Messaging SDK
  → NotificationGateway (SDK adapter)
    → NotificationParser (untrusted payload → typed intent)
      → NotificationCoordinator (app lifecycle + navigation)
        → Feature route
```

Keep local-notification display separate from remote-message parsing. A foreground message may show in-app UI, while background/terminated messages are handled by platform callbacks.

---

## Lifecycle states

Handle all deliberately:

| State | Delivery | Typical action |
|---|---|---|
| Foreground | stream callback | Update state; optionally show in-app/local banner |
| Background | background callback | Minimal safe processing; system displays notification |
| Terminated | initial-message lookup | Queue intent until app bootstrap completes |
| Tap | open callback | Parse and route once |

Background callbacks may run in a separate isolate with limited initialized dependencies. Keep them top-level/static, fast, and free of UI access.

---

## Typed payload parsing

Treat notification data as untrusted external input:

```dart
sealed class AppIntent { const AppIntent(); }
final class OpenItemIntent extends AppIntent {
  const OpenItemIntent(this.id);
  final ItemId id;
}

AppIntent? parseNotification(Map<String, dynamic> data) {
  return switch (data['type']) {
    'item' when data['id'] is String => OpenItemIntent(ItemId(data['id'])),
    _ => null,
  };
}
```

**Mandatory.** Validate kind, required fields, identifiers, and allowed destinations. Unknown payloads are ignored safely and logged without personal content.

Never let a payload supply an arbitrary route name or external URL.

---

## Deep-link pipeline

```text
URI
  → validate scheme and host
  → parse path/query
  → typed AppIntent
  → access/session check
  → route or queue
```

Support both cold-start links and links received while running. Subscribe once at application scope and dispose the subscription with the app listener.

---

## Readiness queue

External navigation may arrive before the navigator, remote config, or restored session is ready.

```dart
if (!bootstrap.isReady) {
  pendingIntent = intent;
  return;
}
consume(intent);
```

Define queue semantics:

- Usually keep only the latest pending navigation intent
- Consume exactly once
- Clear after logout if destination requires authentication
- Validate again at consumption time; session may have changed

---

## Token registration

Push device tokens are not user credentials but are still sensitive identifiers.

- Refresh token registration on SDK token changes
- Associate/disassociate with session at sign-in/sign-out
- Make server registration idempotent
- Do not log the full token
- Retry transient registration failure without blocking login indefinitely unless required by product policy

---

## Notification preferences

Separate OS authorization from in-app category preferences:

- OS permission decides whether the app may notify
- App preferences decide which categories the server should send

Toggling an in-app preference does not grant OS permission. Show the difference clearly.

---

## Security

- Notification text may appear on a locked screen; avoid sensitive content by default
- Deep-link parameters cannot grant authorization; server checks remain authoritative
- Allowlist external URL schemes and hosts
- Never embed access tokens or personal data in links
- Avoid processing heavy or sensitive data in background handlers

---

## Testing

- Parse every known payload type
- Unknown/malformed payload safely ignored
- Foreground message updates expected state
- Cold-start intent waits for bootstrap, then routes once
- Auth-required intent routes through sign-in and resumes intentionally
- Duplicate tap is idempotent
- Sign-out clears protected pending intent and token association
- Deep links reject wrong scheme/host and malformed identifiers

---

## Related documents

- [Routing](routing.md)
- [Application Bootstrap](app_bootstrap.md)
- [Authentication and Tokens](authentication_and_tokens.md)
- [Adding an Integration](../workflows/adding_integration.md)
