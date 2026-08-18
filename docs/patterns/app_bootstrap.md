# Application Bootstrap

**Status: Preferred for applications with startup prerequisites; optional for simple apps.**

Bootstrap is the explicit sequence that turns process start into a routable application state. It prevents startup policy from accumulating inside a splash screen or `main()` as an untestable chain.

---

## Two stages

### Infrastructure initialization

Runs before the widget tree:

```text
1. Ensure framework bindings
2. Set platform orientation/system UI
3. Initialize crash reporting
4. Initialize dependency injection; core injector validates build configuration first
5. Load safe local defaults
6. Restore session material
7. Start application
```

Only true prerequisites belong here. Do not make first paint wait for network calls that can happen in the bootstrap feature.

### Startup gate

A dedicated route/state holder evaluates application policy:

```text
connectivity hint
  → remote configuration refresh
    → minimum-version check
      → maintenance check
        → device-integrity policy (optional)
          → session routing
```

Each check emits an explicit state the screen can render and retry.

---

## Fatal versus recoverable

Classify every initialization dependency:

| Failure | Typical policy |
|---|---|
| Dependency registration defect | Fatal; developer error |
| Invalid compiled-in security fallback | Fatal in debug/CI; release behavior documented |
| Remote configuration fetch timeout | Recoverable; use cached/default values |
| Crash-reporting initialization failure | Recoverable; log locally if possible |
| No connectivity | Recoverable screen with retry; cached path if supported |
| Minimum version unsupported | Blocking state with update action |
| Maintenance mode | Blocking state with retry/recheck |
| Device integrity rejected | Blocking only if project policy requires it |

A blank splash is never an acceptable failure state.

---

## Bootstrap state machine

```dart
sealed class BootstrapState { const BootstrapState(); }
final class Checking extends BootstrapState {}
final class Offline extends BootstrapState {}
final class UpdateRequired extends BootstrapState { /* store URL/version */ }
final class Maintenance extends BootstrapState {}
final class DeviceRejected extends BootstrapState {}
final class Ready extends BootstrapState { /* destination */ }
final class BootstrapFailure extends BootstrapState { /* retry */ }
```

Each retry restarts from the narrowest safe checkpoint. Avoid several independent booleans (`isOffline`, `isMaintenance`, `needsUpdate`) that permit impossible combinations.

---

## Ordering

Ordering is policy and must be documented. For example:

- Minimum version before authentication avoids running incompatible calls
- Maintenance before session restoration may reduce work, but if config refresh needs authenticated transport the order changes
- Device integrity before loading sensitive local data reduces exposure
- Deep links wait until bootstrap reaches `Ready`, then route

There is no universal order. There must be an intentional one.

---

## Background revalidation

**Optional.** Recheck operational policy when returning from background if the app has been inactive longer than a threshold. Avoid doing so on every brief app switch.

Use a monotonic elapsed-time source where possible; wall-clock changes can distort thresholds.

---

## Common mistakes

- Network fetch before first paint with no timeout or fallback
- Initialization work scattered between `main`, splash widget, and several providers
- `main()` silently catches an error and launches a partially configured app
- Several startup checks run concurrently despite ordering dependencies
- Startup state represented by unrelated booleans
- Session loaded after the initial route decision, causing a route flash
- Notification/deep-link navigation occurs before navigator and session are ready
- Startup gate has no retry path

---

## Testing

Test the state machine as pure coordination:

- All checks succeed → expected destination
- Offline → offline state → retry succeeds
- Remote config failure uses safe default
- Update required blocks later checks
- Maintenance blocks navigation
- Optional integrity check disabled by config skips cleanly
- Session state selects authenticated or public destination
- Deep link is queued until ready, then consumed once
- Background threshold revalidates only when exceeded

---

## Related documents

- [Configuration](configuration.md)
- [Authentication and Tokens](authentication_and_tokens.md)
- [Routing](routing.md)
- [Logging and Diagnostics](logging_and_diagnostics.md)
- [Project Bootstrap](../foundation/project_bootstrap.md)
