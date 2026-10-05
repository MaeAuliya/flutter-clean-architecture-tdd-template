# Environment Configuration and Remote Config

**Status: Build-time configuration is mandatory for environment-specific values. Remote configuration is optional.**

These mechanisms solve different problems:

- **Build-time configuration** selects values fixed for a binary: environment name, API host, application identifiers.
- **Remote configuration** changes safe operational policy without releasing a new binary: maintenance mode, minimum version, staged feature flags, certificate pin rotation.

Do not use remote config to deliver secrets. Values received by a client are not secret.

---

## Build-time configuration

Expose environment definitions through one validated accessor:

```dart
class API {
  const API({
    this.baseUrl = const String.fromEnvironment('BASE_URL'),
  });

  final String baseUrl;

  List<String> missingKeys() => [
    if (baseUrl.trim().isEmpty) 'BASE_URL',
  ];

  void validate() {
    final missing = missingKeys();
    if (missing.isNotEmpty) {
      throw StateError('Missing build configuration: ${missing.join(', ')}');
    }

    final uri = Uri.tryParse(baseUrl);
    if (uri == null || uri.scheme != 'https' || uri.host.isEmpty) {
      throw StateError('Invalid build configuration: BASE_URL must be HTTPS.');
    }
  }
}
```

In this template the accessor is `API` under `core/services/api/`, and `CoreInjector` calls `validate()` as its first step — before any other dependency is constructed.

**Mandatory.** Validate required keys before application startup. `String.fromEnvironment` returns an empty string by default; an app that builds successfully with missing configuration and fails every call later is a preventable failure mode.

**Mandatory.** Validation is structural, not just presence. A `BASE_URL` that is present but not an absolute HTTPS URL must fail at startup too — collect every missing key before throwing so one run reports all of them, then check the shape of the values you got.

---

## Environment files

This template uses a single ignored `env.json`, copied from the committed `env.example.json`:

```text
env.example.json    # committed, placeholders only
env.json            # ignored, real values
```

Split it per target — `env.development.json`, `env.staging.json`, `env.production.json` — once the project has more than one environment.

Commit `env.example.json` with every required key and obvious placeholders:

```json
{
  "BASE_URL": "https://api.example.invalid",
  "EXAMPLE": "/v1/example"
}
```

No real API key, token, certificate fingerprint, internal host, or application credential belongs in examples or documentation.

Document the run/build command in the project root instructions. Configuration omission should fail early and visibly.

---

## Flavors

**Optional.** Use native flavors when environments need different:

- Bundle/application identifiers
- Signing or entitlements
- Firebase projects
- Display names/icons
- Native SDK configuration

Build-time definitions alone are simpler when only API URLs and safe flags differ. Flavors add native project maintenance; do not adopt them merely to represent a string called `APP_ENV`.

---

## Remote configuration service

Hide the provider SDK behind a project interface:

```dart
abstract interface class RemoteConfigService {
  Future<void> initialize();
  Future<void> refresh();
  bool get maintenanceMode;
  Version get minimumSupportedVersion;
  bool get featureEnabled;
}
```

The implementation owns provider keys, parsing, defaults, refresh interval, and diagnostics. Callers consume typed getters, not raw strings.

---

## Two-phase startup

A strong remote-config startup pattern:

```text
Phase 0 — before app renders
  load compiled-in safe defaults
  initialize provider's last activated local values
  never block on network

Phase 1 — bootstrap flow
  fetch and activate fresh values
  validate each value
  update cached typed values atomically
  continue with prior/default values on recoverable failure
```

This lets the app boot offline while still refreshing operational policy quickly.

---

## Defaults and trust anchors

Every remotely controlled value needs a safe local default. Some values — notably certificate pins — also need a compiled-in trust anchor; otherwise the client may need a valid pinned connection to fetch the pin required to make that connection.

**Mandatory when remote values affect security.** Validate structure, expiry, and safe bounds before activation. Keep the previous known-good value if validation fails. Log non-fatally with no sensitive content.

---

## Flags and lifecycle

Every feature flag has:

- Owner
- Default
- Intended removal date or condition
- Safe behavior when fetch fails
- Analytics/diagnostics plan if rollout needs measurement

Flags are temporary branching infrastructure, not permanent configuration. Remove both branches once rollout is complete.

---

## Common mistakes

- Build succeeds with missing keys that become empty strings
- Secrets committed in an environment JSON file
- Exact real values copied into documentation
- Features call the remote-config SDK directly
- App blocks at splash waiting for a remote fetch
- No safe default for maintenance or minimum version
- A stale config is trusted indefinitely without expiry policy
- Remote config used for values that require secrecy
- Feature flag has no removal plan

---

## Testing

- Missing build-time key fails startup with its name
- Example environment file contains placeholders only
- Remote-config initialization works offline using defaults
- Invalid remote payload preserves previous known-good value
- Fetch timeout does not brick startup
- Typed getters parse boundary values
- Feature flag default is safe
- Security-sensitive config honors expiry and fallback

---

## Related documents

- [Application Bootstrap](app_bootstrap.md)
- [Transport Security](../security/transport_security.md)
- [Secure Coding and Credentials](../security/secure_coding_and_credentials.md)
- [Project Bootstrap](../foundation/project_bootstrap.md)
