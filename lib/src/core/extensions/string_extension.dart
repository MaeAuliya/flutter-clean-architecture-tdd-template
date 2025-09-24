/// {@template string_extension}
/// Extension methods for working with [String].
///
/// Provides common helpers for formatting, parsing,
/// and validation operations on string values.
///
/// Example usage:
/// ```dart
/// final name = "flutter";
/// print(name.capitalize()); // Flutter
///
/// final email = "test@example.com";
/// print(email.isEmail()); // true
///
/// final numStr = "123";
/// print(numStr.toIntOrNull()); // 123
///
/// final piStr = "3.14";
/// print(piStr.toNumOrNull()); // 3.14
///
/// final invalid = "abc";
/// print(invalid.toNumOrNull()); // null
/// ```
/// {@endtemplate}
extension StringExtension on String {
  /// {@macro string_extension}
  ///
  /// Capitalizes the first letter of the string
  /// and converts the rest to lowercase.
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }

  /// {@macro string_extension}
  ///
  /// Returns `true` if the string matches a basic email format.
  bool isEmail() {
    final regex = RegExp(r"^[\w\.\-]+@([\w\-]+\.)+[a-zA-Z]{2,4}$");
    return regex.hasMatch(this);
  }

  /// {@macro string_extension}
  ///
  /// Returns `true` if the string contains only numeric characters.
  bool isNumeric() => RegExp(r'^[0-9]+$').hasMatch(this);

  /// {@macro string_extension}
  ///
  /// Parses the string to an `int` if possible,
  /// otherwise returns `null`.
  int? toIntOrNull() => int.tryParse(this);

  /// {@macro string_extension}
  ///
  /// Parses the string to a `double` if possible,
  /// otherwise returns `null`.
  double? toDoubleOrNull() => double.tryParse(this);

  /// {@macro string_extension}
  ///
  /// Parses the string into a [num] (either `int` or `double`)
  /// depending on its format. Returns `null` if parsing fails.
  ///
  /// Example:
  /// ```dart
  /// print("42".toNumOrNull()); // 42 (int)
  /// print("3.14".toNumOrNull()); // 3.14 (double)
  /// print("abc".toNumOrNull()); // null
  /// ```
  num? toNumOrNull() => num.tryParse(this);
}
