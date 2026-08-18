# Workflow: Adding an Integration or Dependency

Use for permissions, maps, notifications, analytics, camera, payment SDKs, native bridges, and ordinary packages.

## Preconditions

- Capability cannot be met adequately by the framework or an existing dependency
- Product and platform requirements are explicit
- Security/privacy impact is understood
- Alternatives and maintenance health have been evaluated

## 1. Evaluate before adding

Complete the package-evaluation section in [Decision and Project Documentation Templates](../templates/decision_and_product_docs.md):

- Capability and why existing code is insufficient
- Maintenance activity and issue health
- Platform support and minimum OS/SDK impact
- License
- Transitive dependencies and binary size
- API stability and migration history
- Testability and ability to wrap
- Privacy/data collection
- Reasonable alternatives, including no package

## 2. Define a project-owned boundary

If SDK types would spread or policy is needed, define a small gateway:

```dart
abstract interface class AnalyticsGateway {
  Future<void> track(AppEvent event);
}
```

Features depend on the gateway. The adapter owns SDK initialization and mapping.

A tiny leaf UI utility may not warrant a wrapper; document the reasoning.

## 3. Configure platforms

- Add package using normal dependency workflow
- Add Android/iOS declarations, capabilities, privacy strings, and initialization
- Add build-time keys to ignored environment config and placeholders to example
- Never commit credentials or signing material
- Record minimum platform changes

## 4. Define lifecycle and failure policy

For each integration specify:

- Initialization stage
- Fatal versus recoverable failure
- Offline behavior
- Permission flow
- Resource disposal
- Retry/idempotency
- Data retention and redaction
- Feature behavior when unavailable

## 5. Register and expose

Register adapter in core DI. Expose only domain-safe types. For optional integrations, keep the feature able to render an unavailable/denied state.

## 6. Verify

- Unit-test policy with fake gateway
- Adapter test or integration test against platform boundary
- Test denied/unavailable/offline/malformed cases
- Verify release build configuration on both platforms
- Check logs for sensitive values
- Measure startup/binary/performance impact where material
- Update pattern catalog and tech-stack reference
- Record significant choice as ADR

## Common mistakes

- SDK singleton called directly throughout features
- Package added because it is popular, without a capability need
- Android configured but iOS forgotten
- Integration failure blocks all startup unnecessarily
- Real keys pasted into source
- Optional capability has no unavailable UI
- No package-removal or feature-flag plan

## Related documents

- [Recommended Tech Stack](../reference/recommended_tech_stack.md)
- [Permissions and Device Capabilities](../patterns/permissions_and_device.md)
- [Secure Coding and Credentials](../security/secure_coding_and_credentials.md)
- [Architecture Decision Records](../decisions/README.md)
