# Localization

**Status: Preferred for applications serving more than one locale.** Flutter's generated ARB workflow is the default; do not add a parallel runtime string package without a documented need.

## Architecture

```text
ARB resources
  → Flutter gen-l10n
    → generated AppLocalizations (presentation only)
      → context.l10n

stored locale code
  → local data source
    → repository / use cases
      → application-scoped LanguageBloc
        → MaterialApp.locale
```

Generated localization types belong at presentation boundaries. Domain and data code must not import generated classes or depend on `BuildContext`.

## Resources and generation

```text
lib/l10n/
  app_en.arb       # template and fallback
  app_id.arb
  generated/       # tool-owned; never edit manually
l10n.yaml
```

`pubspec.yaml` includes `flutter_localizations` from the SDK, `intl`, and `flutter.generate: true`.

After editing ARB files:

```bash
flutter gen-l10n
```

## Key naming

Use purpose/feature names, not English sentence text:

```text
commonCancel
settingsLanguageEnglish
authenticationSignInTitle
validationRequiredField
errorNoInternet
```

A renamed translation should not require renaming its key. Use one key for the same meaning across features; use distinct keys where context changes translation.

## Parameters, plurals, dates, and numbers

Never build a translated sentence by concatenating fragments. Add a placeholder:

```json
{
  "welcomeUser": "Welcome, {name}",
  "@welcomeUser": {
    "placeholders": {
      "name": { "type": "String" }
    }
  }
}
```

Use ICU plurals for counts and `intl` locale-aware formatters for user-facing dates/numbers. Date patterns, API values, and storage keys are technical and stay out of ARB.

## Locale state and persistence

Persist only a stable bare language code such as `en` or `id`, never a Flutter `Locale` object. The domain owns the supported-code enum and normalization; malformed, missing, and unsupported values fall back to English.

Locale loading must not block startup. A persistence failure is logged through the existing diagnostics abstraction and leaves a usable fallback locale.

Application locale is intentionally application-scoped. Create the language state holder once above `MaterialApp`; route-level settings blocs remain route-scoped.

## Context-free validation and failures

Validators, repositories, data sources, and domain types cannot access `context.l10n`. They expose semantic identifiers or typed failures:

```text
ValidationIssue.requiredField
NetworkFailure.offline
OrderStatus.reserved
```

Presentation maps the identifier to `context.l10n`. Do not introduce a global localization singleton or inject generated localizations into domain/data.

Dynamic server-provided content remains server-owned. Localize client-owned fallback/error states; arbitrary server text cannot be safely translated on the client.

## Adding a message

1. Classify it as user-facing rather than technical.
2. Add a meaningful key and English template entry.
3. Add a natural translation to every supported ARB.
4. Add metadata for placeholders/plurals.
5. Run `flutter gen-l10n`.
6. Access it through the single project convention (`context.l10n`).
7. Test formatting logic when the message has behavior.

## Adding a language

1. Confirm product/content support and translation ownership.
2. Add the locale to the domain-supported set.
3. Add a complete ARB file with key parity.
4. Update native platform locale declarations where required.
5. Update locale normalization, backend-content mapping, and tests.
6. Verify layouts with longer copy and text scaling.

Do not add a language by creating only an ARB file; state, persistence, API content, and platform metadata must agree.

## Audit rules for AI coding agents

For every new string literal, classify it before writing:

**Localize:** titles, labels, buttons, hints, validation, dialogs, snackbar/toast content, empty/error/loading copy, permission explanations, local notification copy, accessibility labels, tooltips.

**Do not localize:** routes, API/JSON/storage keys, headers, asset paths, environment keys, log tags, analytics identifiers, enum wire values, regexes, MIME types, date patterns, debug-only messages.

New user-facing literals outside ARB are review defects.

## Testing

- Default/fallback locale
- Every supported stored locale
- Unsupported/malformed stored value
- Persistence success/failure
- Locale change rebuilds `MaterialApp` without restart
- ARB key parity and placeholder signatures
- Locale-sensitive plurals/formatting
- Critical widgets in every supported locale

## Common mistakes

- Generated localization imported by domain/data
- Global static localization singleton
- Persisting `Locale.toString()` or display names
- Using one storage key for both app locale and a backend-specific language enum without mapping
- Concatenated translated fragments
- Literal-English keys
- Placeholder translation copied into another language
- Manual edits to generated files
- Backend messages assumed to be localized client copy

## Related documents

- [State Management](state_management.md)
- [Local and Secure Storage](storage.md)
- [Shared UI](shared_ui.md)
- [Adding Presentation](../workflows/adding_presentation.md)
- [Testing Strategy](../quality/testing_strategy.md)
