# Template Next Steps

Only open work belongs here. Completed architecture migrations live in code, tests, and pattern docs.

## High priority

### Expand generated capability choices

**Current:** Feature/module generation emits compiling local-read and remote-update seams, DI, routing, and mirrored tests.

**Next:** Allow callers to choose local, remote, read, update, and presentation capabilities so unused abstractions are not generated.

### Add product-level integration coverage

**Current:** Unit, Bloc, repository, mapper, data-source, API, shared-widget, and injector-composition tests run in CI.

**Next:** Add integration tests only after real startup/session/deep-link journeys replace template behavior.

## Context-dependent

### Harden production diagnostics

`DebugAppLogger` is a project-owned seam. Replace it with approved crash reporting when production operations require aggregation, while preserving secret/PII redaction rules.

### Expand responsive and theme coverage

Add dark/light, increased text scale, narrow width, tablet, and landscape widget tests as product screens appear. Keep intrinsic brand treatments explicitly documented.

### Add optional platform capabilities

Secure storage, authentication/token refresh, Dio interceptors, pagination/caching, notifications/deep links, permissions, maps, and media remain opt-in product capabilities. Add only when requirements demand them; follow corresponding pattern docs.

## Human confirmation required

- Which configuration values are intentionally public client keys
- Supported accessibility text-scale range and tablet/landscape targets
- Which state, if any, must intentionally survive route disposal
- Offline/cache requirements before enabling local persistence

## Related documents

- [Testing Strategy](../quality/testing_strategy.md)
- [State Management](../patterns/state_management.md)
- [Dependency Injection](../patterns/dependency_injection.md)
- [Configuration](../patterns/configuration.md)
