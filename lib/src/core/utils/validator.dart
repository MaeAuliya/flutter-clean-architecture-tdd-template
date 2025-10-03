import '../res/texts.dart';

/// {@template validator}
/// Utility class for handling **form input validation** across the app.
///
/// This class provides static methods to validate:
/// - Passwords
/// - Phone numbers
/// - Email addresses
/// - Confirmed passwords
///
/// Each validator returns a [String] error message (from [Texts])
/// when the input is invalid, or `null` if the input passes validation.
///
/// Usage example:
/// ```dart
/// final error = Validator.emailValidator(userInput);
/// if (error != null) {
///   // Show error message
/// }
/// ```
/// {@endtemplate}
class Validator {
  const Validator._();

  /// {@template password_validator}
  /// Validates a **password** input.
  ///
  /// Rules:
  /// - Must not be empty → returns [Texts.emptyValidator].
  /// - Must contain at least 8 characters → returns [Texts.passwordEightCharValidator].
  /// - Otherwise, returns `null`.
  /// {@endtemplate}
  static String? passwordValidator(String? input) {
    if (input == null || input.isEmpty) {
      return Texts.emptyValidator;
    } else if (input.length < 8) {
      return Texts.passwordEightCharValidator;
    }
    return null;
  }

  /// {@template phone_validator}
  /// Validates a **phone number** input.
  ///
  /// Rules:
  /// - Must not be empty → returns [Texts.emptyValidator].
  /// - Must contain only digits → returns [Texts.phoneDigitsOnlyValidator].
  /// - Must contain at least 10 digits → returns [Texts.phoneMinLengthValidator].
  /// - Must not exceed 15 digits → returns [Texts.phoneMaxLengthValidator].
  /// - Otherwise, returns `null`.
  /// {@endtemplate}
  static String? phoneNumberValidator(String? input) {
    if (input == null || input.isEmpty) {
      return Texts.emptyValidator;
    } else if (!RegExp(r'^[0-9]+$').hasMatch(input)) {
      return Texts.phoneDigitsOnlyValidator;
    } else if (input.length < 10) {
      return Texts.phoneMinLengthValidator;
    } else if (input.length > 15) {
      return Texts.phoneMaxLengthValidator;
    }
    return null;
  }

  /// {@template email_validator}
  /// Validates an **email address** input.
  ///
  /// Rules:
  /// - Must not be empty → returns [Texts.emptyValidator].
  /// - Must match the general email regex → otherwise, returns [Texts.emailInvalidValidator].
  /// - Otherwise, returns `null`.
  /// {@endtemplate}
  static String? emailValidator(String? input) {
    if (input == null || input.isEmpty) {
      return Texts.emptyValidator;
    } else if (!RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@"
      r"[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?"
      r"(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$",
    ).hasMatch(input)) {
      return Texts.emailInvalidValidator;
    }
    return null;
  }

  /// {@template confirm_password_validator}
  /// Validates a **confirm password** input by comparing it to the original password.
  ///
  /// Rules:
  /// - Must not be empty → returns [Texts.emptyValidator].
  /// - Must match the original password → otherwise, returns [Texts.passwordValueValidator].
  /// - Otherwise, returns `null`.
  /// {@endtemplate}
  static String? confirmPasswordValidator(String? input, String password) {
    if (input == null || input.isEmpty) {
      return Texts.emptyValidator;
    } else if (input != password) {
      return Texts.passwordValueValidator;
    }
    return null;
  }
}
