# Permissions and Device Capabilities

**Status: Optional.** Adopt only for capabilities the project uses. Permission handling itself must be centralized and capability-oriented.

Permissions are a user trust interaction, not just a plugin call. The application must explain why, request at the moment of need, handle denial without a dead end, and remain useful where possible.

---

## Capability module

```text
core/modules/permission/
  domain/
    entities/permission_status.dart
    repositories/permission_repository.dart
    usecases/check_permission.dart
    usecases/request_permission.dart
    usecases/open_settings.dart
  data/
    repositories/permission_repository_impl.dart
    datasources/platform_permission_source.dart
```

Features depend on a domain-safe capability enum, not a plugin enum:

```dart
enum AppPermission { camera, locationWhenInUse, notifications }

enum AppPermissionStatus {
  granted,
  denied,
  permanentlyDenied,
  restricted,
  limited,
}
```

This isolates platform/package changes and gives the project one mapping for iOS and Android differences.

---

## Request flow

```text
user initiates capability
  → check current status
  → if granted: continue
  → if first request: show contextual rationale, then system prompt
  → if denied: explain impact and offer retry where allowed
  → if permanently denied: offer open-settings action
  → if restricted/limited: provide reduced behavior or explanation
```

**Mandatory.** Request at the moment of intent, not in bulk at startup. A user is more likely to understand a camera prompt after tapping "Take photo" than during an unrelated splash screen.

---

## Platform declarations

Runtime requests are only half the implementation. Register:

- Android manifest permissions and SDK-specific behavior
- iOS usage-description strings written in user language
- Background modes only when actually required
- Store privacy disclosures

Keep declarations in sync with code. Asking for a permission that lacks a native declaration may crash or silently fail; declaring unused permissions damages trust and store review.

---

## Location

Distinguish permission from service availability:

```text
permission granted + location service disabled ≠ location available
```

Handle:

- Permission status
- Device service status
- Accuracy/precision mode
- Timeout
- Stale last-known location
- Background restrictions, when applicable

Background location is a separate product and privacy decision. Do not request it because a package supports it.

---

## Camera and media

Check camera permission immediately before opening capture. Keep camera-controller lifecycle inside the capture screen or a dedicated media module, and dispose on route exit or app pause.

Gallery/media-library permission behavior varies by platform and OS version; use platform-appropriate limited-access states rather than assuming binary granted/denied.

---

## Biometrics and device integrity

These are separate capabilities:

- **Biometric authentication** verifies device-user presence against a locally stored credential/key
- **Device integrity** detects rooting/jailbreak or unsafe device properties

Both are optional and policy-dependent. Neither is a replacement for server authorization.

Integrity checks can produce false positives. Support remote enforcement flags, diagnostics, and a user support path. Fail closed only when the threat model justifies it.

---

## Common mistakes

- Requesting all permissions at startup
- Plugin enums crossing into domain and UI
- Treating permanently denied as ordinary denied and looping the prompt
- Assuming granted location permission means services are enabled
- No behavior for limited photo-library access
- Native declarations not matching runtime requests
- Integrity check permanently hardcoded on with no operational override
- Permission rationale that describes implementation instead of user benefit

---

## Testing

For each capability:

- Already granted
- First request granted
- Denied
- Permanently denied → settings path
- Restricted/limited
- Service disabled despite permission
- User returns from settings with changed status
- Platform source throws/unavailable
- Feature degrades gracefully without optional permission

Plugin calls require integration or platform-adapter tests; policy can be unit-tested with a fake repository.

---

## Related documents

- [Location, Maps, Media, and Files](location_maps_media.md)
- [State Management](state_management.md)
- [Secure Coding and Credentials](../security/secure_coding_and_credentials.md)
- [Adding an Integration](../workflows/adding_integration.md)
