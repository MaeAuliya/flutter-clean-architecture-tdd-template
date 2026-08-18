# Forms and Validation

**Status: Preferred.**

Forms combine immediate UI feedback, domain constraints, and an asynchronous submission. Keep those concerns distinct so validation is reusable and submission remains testable.

---

## Ownership

| Concern | Owner |
|---|---|
| Text controllers, focus nodes | Screen/widget; disposed with it |
| Current field values and touched/submitted flags | Route-scoped form controller/notifier |
| Pure field syntax checks | Validator functions |
| Cross-field/business policy | Domain value object or use case |
| Server rejection | Async state holder/failure mapping |
| Submit navigation/effect | Presentation listener/coordinator |

Do not put network calls in a form provider. It owns input state; the feature bloc/cubit owns submission.

---

## Pure validators

```dart
typedef Validator<T> = String? Function(T value);

String? validateEmail(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) return 'Email is required.';
  if (!emailPattern.hasMatch(trimmed)) return 'Enter a valid email.';
  return null;
}
```

Validators are deterministic and side-effect free. They do not read `BuildContext`, call repositories, or mutate state. This makes them trivial to test.

User-facing messages should be localized through the presentation layer. For fully reusable validation, return error codes/types rather than final strings.

---

## Form controller

```dart
final class SignInFormController extends ChangeNotifier {
  String _email = '';
  String _password = '';
  bool _submitted = false;

  String get email => _email;
  String get password => _password;
  FieldError? get emailError =>
      _submitted ? EmailValidator.validate(_email) : null;
  bool get canSubmit =>
      EmailValidator.validate(_email) == null &&
      PasswordValidator.validate(_password) == null;

  void updateEmail(String value) {
    if (_email == value) return;
    _email = value;
    notifyListeners();
  }

  void markSubmitted() {
    _submitted = true;
    notifyListeners();
  }
}
```

Scope it to the route. Do not register every form globally and rely on `reset()` calls; route disposal is the correct reset mechanism.

---

## Validation timing

Choose deliberately:

- **On submit:** least noisy; errors appear after first attempt
- **On blur:** useful for longer forms
- **As typed after touch:** responsive without showing errors on an untouched form

Avoid showing a wall of errors immediately on screen load.

---

## Domain validation

A password policy, date range, or amount limit may be a domain rule rather than a UI rule. Represent it in domain so imports, background flows, and tests use the same policy.

```dart
sealed class PasswordIssue { const PasswordIssue(); }

Result<Password, PasswordIssue> createPassword(String raw) { /* policy */ }
```

Presentation converts issue types to localized messages.

---

## Submission sequence

```text
user taps submit
  → mark form submitted
  → if client validation fails: focus first invalid field
  → dispatch typed params to async state holder
  → disable or show loading on submit action
  → success: effect/navigation
  → field-level rejection: attach to field
  → general failure: error state/snackbar
  → always leave loading
```

Prevent duplicate submissions while one is in flight.

---

## Sensitive inputs

- Do not persist passwords, PINs, CVVs, or one-time codes
- Clear controllers when the flow completes or is abandoned
- Use appropriate keyboard/autofill hints without exposing values in logs
- Obscure sensitive fields; let the user deliberately reveal when appropriate
- Screenshots/recents protection is context-dependent for high-sensitivity screens
- Never include raw field values in analytics or crash metadata

---

## Common mistakes

- Same field stored in text controller, provider, and bloc simultaneously
- Global form provider leaks values between visits
- Validator contains async network call
- Error messages hardcoded in domain
- `notifyListeners()` called even when value did not change
- Submission continues after client validation fails
- Server field errors shown only as generic snackbar
- Button remains enabled during request, creating duplicate writes

---

## Testing

- Validator boundaries (empty, min/max, Unicode, whitespace)
- Form controller derives `canSubmit` correctly
- Errors appear according to timing policy
- No notification for unchanged value
- Submission sends normalized values once
- Async failure re-enables submit
- Server field errors attach to correct field
- Sensitive state clears on flow disposal

---

## Related documents

- [State Management](state_management.md)
- [Shared UI](shared_ui.md)
- [Data Mapping](data_mapping.md)
- [Adding Presentation](../workflows/adding_presentation.md)
