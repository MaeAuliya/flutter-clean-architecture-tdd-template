import 'dart:ui';

/// {@template colours}
/// Centralized color palette for the entire application.
///
/// This class defines all brand, semantic, neutral, and overlay colors
/// used in the app. Instead of hardcoding color values across widgets,
/// always reference them through [Colours].
///
/// ### Benefits:
/// - Consistent color usage across the app.
/// - Easier to maintain or update brand identity.
/// - Provides a neutral gray scale and semantic colors for states.
///
/// ### Usage:
/// ```dart
/// Container(
///   color: Colours.primaryBlue,
///   child: Text(
///     'Hello',
///     style: TextStyle(color: Colours.white),
///   ),
/// );
/// ```
///
/// ### Color Categories:
/// - **Base** → white, black.
/// - **Primary Palette** → brand blues.
/// - **Secondary Palette** → greens, oranges, purples.
/// - **Neutral / Gray Scale** → 50–900 for backgrounds, borders, and text.
/// - **Semantic Colors** → error, warning, info, success.
/// - **Overlay / Shadows** → translucent blacks for overlays and shadows.
///
/// ### Example Theme Integration:
/// ```dart
/// final theme = ThemeData(
///   primaryColor: Colours.primaryBlue,
///   scaffoldBackgroundColor: Colours.gray50,
///   errorColor: Colours.errorColor,
/// );
/// ```
/// {@endtemplate}
class Colours {
  const Colours._();

  // =====================
  // Base
  // =====================
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF111827);

  // =====================
  // Primary Palette
  // =====================
  static const Color primaryBlue = Color(0xFF2F80ED);
  static const Color secondaryBlue = Color(0xFF73A9F3);
  static const Color darkBlue = Color(0xFF092C4C);
  static const Color lightBlue = Color(0xFFEAF3FF);
  static const Color yellow = Color(0xffFDC300);

  // =====================
  // Secondary Palette
  // =====================
  static const Color primaryGreen = Color(0xFF27AE60);
  static const Color secondaryGreen = Color(0xFF6FCF97);
  static const Color greenSuccess = Color(0xFFE0FFE0);

  static const Color primaryOrange = Color(0xFFF2994A);
  static const Color secondaryOrange = Color(0xFFFAD7B2);

  static const Color primaryPurple = Color(0xFF9B51E0);
  static const Color secondaryPurple = Color(0xFFD9B3F7);

  // =====================
  // Neutral / Gray Scale
  // =====================
  static const Color gray50 = Color(0xFFFAFAFA);
  static const Color gray100 = Color(0xFFF5F5F5);
  static const Color gray200 = Color(0xFFE5E7EB);
  static const Color gray300 = Color(0xFFD1D5DB);
  static const Color gray400 = Color(0xFF9CA3AF);
  static const Color gray500 = Color(0xFF6B7280); // "regular gray"
  static const Color gray600 = Color(0xFF4B5563);
  static const Color gray700 = Color(0xFF374151);
  static const Color gray800 = Color(0xFF1F2937);
  static const Color gray900 = Color(0xFF111827);

  // =====================
  // Semantic Colors
  // =====================
  static const Color errorColor = Color(0xFFEB5757);
  static const Color warningColor = Color(0xFFF2C94C);
  static const Color infoColor = Color(0xFF2D9CDB);
  static const Color successColor = Color(0xFF27AE60);

  // =====================
  // Overlay / Shadows
  // =====================
  static const Color overlayLight = Color(0x66000000); // 40% black
  static const Color overlayDark = Color(0x99000000); // 60% black
}
