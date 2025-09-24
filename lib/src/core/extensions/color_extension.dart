import 'dart:ui';

/// {@template color_extension}
/// Extension methods for working with [Color].
///
/// This extension provides helper methods to convert a [Color]
/// object into different formats (e.g., integer or hex string).
///
/// Example usage:
/// ```dart
/// final myColor = const Color(0xFF42A5F5);
///
/// // Convert to ARGB integer
/// final colorInt = myColor.toInt();
///
/// // Convert to hex string with alpha
/// final hexWithAlpha = myColor.toHex(); // #ff42a5f5
///
/// // Convert to hex string without alpha
/// final hexWithoutAlpha = myColor.toHex(withAlpha: false); // #42a5f5
/// ```
/// {@endtemplate}
extension ColorExtension on Color {
  /// {@macro color_extension}
  ///
  /// Converts this [Color] into a 32-bit ARGB integer.
  ///
  /// Format: `0xAARRGGBB`
  /// - Alpha (A): 8 bits
  /// - Red (R): 8 bits
  /// - Green (G): 8 bits
  /// - Blue (B): 8 bits
  ///
  /// Example:
  /// ```dart
  /// const color = Color(0xFF42A5F5);
  /// print(color.toInt()); // 4283215695
  /// ```
  int toInt() {
    final alpha = (a * 255).toInt();
    final red = (r * 255).toInt();
    final green = (g * 255).toInt();
    final blue = (b * 255).toInt();

    return (alpha << 24) | (red << 16) | (green << 8) | blue;
  }

  /// {@macro color_extension}
  ///
  /// Converts this [Color] into a hex string.
  ///
  /// By default includes the alpha channel (`#AARRGGBB`).
  /// Set [withAlpha] to `false` to generate a hex string without alpha (`#RRGGBB`).
  ///
  /// Example:
  /// ```dart
  /// const color = Color(0xFF42A5F5);
  /// print(color.toHex()); // #ff42a5f5
  /// print(color.toHex(withAlpha: false)); // #42a5f5
  /// ```
  String toHex({bool withAlpha = true}) {
    if (withAlpha) {
      return '#${(a * 255).toInt().toRadixString(16).padLeft(2, '0')}'
          '${(r * 255).toInt().toRadixString(16).padLeft(2, '0')}'
          '${(g * 255).toInt().toRadixString(16).padLeft(2, '0')}'
          '${(b * 255).toInt().toRadixString(16).padLeft(2, '0')}';
    } else {
      return '#${(r * 255).toInt().toRadixString(16).padLeft(2, '0')}'
          '${(g * 255).toInt().toRadixString(16).padLeft(2, '0')}'
          '${(b * 255).toInt().toRadixString(16).padLeft(2, '0')}';
    }
  }
}
