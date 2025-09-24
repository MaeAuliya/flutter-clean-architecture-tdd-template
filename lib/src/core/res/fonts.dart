/// {@template fonts}
/// A central place to define and manage font family names used in the app.
///
/// Instead of hardcoding font family strings (e.g. `'Roboto'`) across
/// multiple widgets, reference them through this class:
///
/// ```dart
/// Text(
///   'Hello',
///   style: TextStyle(
///     fontFamily: Fonts.roboto,
///     fontSize: 16,
///   ),
/// )
/// ```
///
/// This ensures consistency and makes it easier to swap out fonts in the
/// future. For example, changing from `Roboto` to `Inter` only requires
/// updating this file, not every `TextStyle`.
///
/// Extend this class by adding more constants for additional font families,
/// e.g.:
///
/// ```dart
/// class Fonts {
///   static const String roboto = 'Roboto';
///   static const String robotoMono = 'RobotoMono';
///   static const String poppins = 'Poppins';
/// }
/// ```
///
/// Make sure the fonts you add are declared properly in `pubspec.yaml` under
/// the `fonts` section.
/// {@endtemplate}
class Fonts {
  /// The default Roboto font family.
  ///
  /// Include it in your `pubspec.yaml`:
  ///
  /// ```yaml
  /// flutter:
  ///   fonts:
  ///     - family: Roboto
  ///       fonts:
  ///         - asset: assets/fonts/Roboto-Regular.ttf
  ///         - asset: assets/fonts/Roboto-Medium.ttf
  ///           weight: 500
  ///         - asset: assets/fonts/Roboto-Bold.ttf
  ///           weight: 700
  /// ```
  static const String roboto = 'Roboto';
}
