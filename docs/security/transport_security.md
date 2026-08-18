# Transport Security

**Status: HTTPS mandatory. Certificate pinning optional and threat-model dependent.**

## Baseline

- HTTPS for every production endpoint
- System trust store validation
- Hostname validation
- Sensible timeouts
- No blanket bad-certificate acceptance
- Cleartext transport disabled in native configuration except explicit development cases

## Certificate pinning

Pinning verifies a server certificate or public key against a value shipped or securely configured by the application. It can reduce exposure to a compromised CA or hostile trust store, but introduces rotation and outage risk.

Adopt only when the threat model and operational maturity justify it — for example, sensitive financial or identity traffic with an infrastructure team able to manage overlap and emergency rotation.

## Safe validation shape

```text
TLS connection
  → normal host check
  → certificate exists and is valid by time
  → derive SHA-256 fingerprint/public-key pin
  → constant comparison against active pin set
  → reject if no match
```

**Mandatory when pinning:** never implement pinning by returning `true` from a bad-certificate callback alone. A custom trust context may deliberately defer trust to the explicit pin validator, but host, time, and pin must all be checked.

## Rotation

Ship at least two pins where the pinning strategy supports it:

- Current
- Backup/next

A robust remote-rotation design has:

1. Compiled-in fallback trust anchor(s)
2. Last known-good remotely activated pin set
3. Validated remote updates with expiry/TTL
4. Overlap during certificate rotation
5. Diagnostics when fallback is active or expiry approaches
6. Emergency release plan

There is a bootstrap paradox: the app cannot rely solely on a pinned network connection to fetch the pin needed to make that connection. Hence the compiled-in fallback.

Remote configuration is not automatically trusted merely because it is remote. Validate schema, pin format, non-empty set, and expiry; preserve last known-good on failure.

## Pin choice

| Pin | Advantage | Cost |
|---|---|---|
| Leaf certificate fingerprint | Straightforward | Changes on certificate renewal |
| Public key (SPKI) | Survives renewal with same key | More complex extraction/tooling |
| Intermediate CA | Easier rotation | Broader trust, weaker restriction |

Choose with infrastructure. Document exact procedure outside this reusable template without embedding production values.

## Failure behavior

Pin mismatch is not a normal retryable network error. Fail closed for protected production traffic, show a generic connectivity/security message, and record redacted diagnostics. Never silently disable pinning after failure.

Development environments may use separate pins or an explicit debug-only client; the bypass must be impossible in release builds.

## Testing and operations

- Active and backup pins accepted
- Unknown, wrong-host, expired certificate rejected
- Invalid remote config preserves known-good pins
- Fallback permits bootstrap
- Rotation exercised before production expiry
- Release build cannot use debug bypass
- Monitoring alerts before pin/config expiry
- Runbook identifies owners and emergency release steps

## Related documents

- [Networking](../patterns/networking.md)
- [Configuration](../patterns/configuration.md)
- [Secure Coding and Credentials](secure_coding_and_credentials.md)
