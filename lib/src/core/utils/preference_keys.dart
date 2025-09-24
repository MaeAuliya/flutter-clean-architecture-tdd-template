/// {@template preference_keys}
/// A central place to define all the keys used in local storage
/// (e.g., `SharedPreferences`, secure storage).
///
/// Keeping all keys in one class:
/// - Avoids typos caused by hardcoded strings.
/// - Makes it easier to refactor or update keys later.
/// - Improves code readability and maintainability.
///
/// Example usage:
/// ```dart
/// // Save a token
/// await storage.write(key: PreferenceKeys.kToken, value: token);
///
/// // Read a token
/// final token = await storage.read(key: PreferenceKeys.kToken);
///
/// // Use example key
/// await storage.write(key: PreferenceKeys.kExample, value: "123");
/// ```
/// {@endtemplate}
class PreferenceKeys {
  /// {@macro preference_keys}
  const PreferenceKeys._();

  // ---------------------------------------------------------------------------
  // Authentication
  // ---------------------------------------------------------------------------

  /// Key for storing the authentication token.
  static const kToken = 'token';

  // ---------------------------------------------------------------------------
  // Example
  // ---------------------------------------------------------------------------

  /// Example key used for demonstration or testing purposes.
  static const kExample = 'example';
}
