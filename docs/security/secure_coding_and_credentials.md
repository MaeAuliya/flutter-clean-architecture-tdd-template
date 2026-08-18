# Secure Coding and Credential Handling

**Status: Mandatory.**

Security controls must be defaults enforced by shared infrastructure, not reminders repeated at call sites.

## Secrets

Never commit or document real:

- API keys or client secrets
- Access/refresh tokens
- Passwords, PINs, one-time codes
- Signing keys/profiles
- Certificate private material or production pin sets
- Private/internal hosts
- Service-account files

Client applications cannot keep a value secret from the device owner. Provider "public" keys may be build configuration, but must still be scoped, restricted, and separated by environment. Backend secrets never ship in the app.

## Configuration files

- Ignore every real environment file
- Commit an example with placeholders and required key names
- Validate missing keys at startup
- Scan repository history as well as current files when a secret is discovered
- Rotate exposed credentials; deleting the current line is not remediation

## Sensitive storage

Use platform-backed encrypted storage for session and recovery material. Plain preferences are for non-sensitive settings only. Define one typed gateway and one list of keys so clearing is complete.

Do not persist passwords, PINs, CVVs, one-time codes, or decrypted identity documents.

## Input and external data

Treat as untrusted:

- HTTP responses
- Deep links and notification payloads
- User-selected files and filenames
- Remote configuration
- Platform-channel results
- QR/barcode content

Validate shape, size, allowed scheme/host/type, and identifiers at the boundary. Client validation improves UX; server authorization remains authoritative.

## Logging and analytics

Apply explicit redaction. Never log authorization headers, tokens, sensitive fields, exact location, document paths/content, upload URLs, or push tokens. Do not send these to analytics or crash custom keys.

Record safe operation names, failure kinds, app version, and non-sensitive correlation IDs.

## Dependencies

- Review maintenance, license, data collection, advisories, and transitive packages
- Pin according to project version policy; review lockfile changes
- Remove unused dependencies and native permissions
- Do not bypass integrity/signing checks to resolve build failures

## Device security

Root/jailbreak and biometric checks are optional defense-in-depth, not authorization. Document false-positive handling, remote enforcement policy, and recovery/support path. Sensitive decisions remain server-side.

## Files and media

- Sanitize filenames and never join untrusted paths directly
- Verify content where MIME spoofing matters
- Strip unnecessary metadata
- Store durable versus temporary files in correct directories
- Delete temporary sensitive captures according to policy
- Avoid sensitive notification text on lock screen

## Security review triggers

Require explicit security review for:

- Authentication/session changes
- Payment or identity data
- New remote SDK or native bridge
- Deep links and external intent handling
- Background location or media
- Certificate/TLS behavior
- Cryptography
- Data export/deletion

## Related documents

- [Transport Security](transport_security.md)
- [Session Security](session_security.md)
- [Configuration](../patterns/configuration.md)
- [Logging and Diagnostics](../patterns/logging_and_diagnostics.md)
