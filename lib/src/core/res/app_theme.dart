import 'package:flutter/material.dart';

import 'colours.dart';

/// {@template app_theme}
/// Application-wide theme configuration for **light** and **dark** modes.
///
/// This class provides two predefined [ThemeData] objects:
/// - [AppTheme.light] → for light mode
/// - [AppTheme.dark] → for dark mode
///
/// It integrates:
/// - A custom [ColorScheme] from [Colours].
/// - Component theming (AppBar, Buttons, Inputs, Cards, Dialogs, etc.).
/// - Custom [TextTheme] mapping with light/dark overrides.
/// - Consistent borders, radii, paddings, and elevations.
///
/// ### Usage:
/// ```dart
/// MaterialApp(
///   theme: AppTheme.light,
///   darkTheme: AppTheme.dark,
///   themeMode: ThemeMode.system, // or ThemeMode.light / dark
///   home: const MyHomePage(),
/// );
/// ```
///
/// ### Benefits:
/// - Centralizes app styling for easy maintenance.
/// - Provides consistent light/dark variants.
/// - Ready to extend with typography and custom components.
/// {@endtemplate}
class AppTheme {
  const AppTheme._();

  /// Light theme configuration.
  ///
  /// Uses [Colours.primaryBlue] as the main brand color,
  /// and a white/gray surface palette.
  static ThemeData get light {
    final colorScheme = const ColorScheme(
      brightness: Brightness.light,
      primary: Colours.primaryBlue,
      onPrimary: Colours.white,
      secondary: Colours.secondaryBlue,
      onSecondary: Colours.black,
      error: Colours.errorColor,
      onError: Colours.white,
      surface: Colours.white,
      onSurface: Colours.black,
      tertiary: Colours.primaryGreen,
      onTertiary: Colours.white,
      surfaceContainerHighest: Colours.gray100,
      surfaceContainerHigh: Colours.gray100,
      surfaceContainer: Colours.gray100,
      surfaceContainerLow: Colours.gray50,
      surfaceContainerLowest: Colours.white,
      surfaceBright: Colours.white,
      surfaceDim: Colours.gray100,
      outline: Colours.gray300,
      outlineVariant: Colours.gray200,
      shadow: Color(0x1A000000), // 10% black
      scrim: Colours.overlayDark,
      inverseSurface: Colours.gray900,
      onInverseSurface: Colours.gray100,
      inversePrimary: Colours.darkBlue,
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      dividerColor: Colours.gray200,
      splashFactory: InkRipple.splashFactory,
    );

    return base.copyWith(
      textTheme: _textTheme(base.textTheme, isDark: false),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: _textTheme(base.textTheme, isDark: false).titleLarge,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 1,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(12),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: colorScheme.outline),
          foregroundColor: colorScheme.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colours.gray100,
        hintStyle: const TextStyle(color: Colours.gray500),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: _border(Colours.gray300, 12),
        enabledBorder: _border(Colours.gray300, 12),
        focusedBorder: _border(colorScheme.primary, 12, width: 1.4),
        errorBorder: _border(Colours.errorColor, 12),
        focusedErrorBorder: _border(Colours.errorColor, 12, width: 1.4),
      ),
      chipTheme: base.chipTheme.copyWith(
        color: const WidgetStatePropertyAll(Colours.gray100),
        side: const BorderSide(color: Colours.gray200),
        labelStyle: const TextStyle(color: Colours.gray700),
        selectedColor: colorScheme.secondary,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: Colours.gray500,
        type: BottomNavigationBarType.fixed,
        selectedIconTheme: const IconThemeData(size: 26),
        unselectedIconTheme: const IconThemeData(size: 24),
      ),
      dividerTheme: const DividerThemeData(
        color: Colours.gray200,
        thickness: 1,
        space: 1,
      ),
    );
  }

  /// Dark theme configuration.
  ///
  /// Uses [Colours.secondaryBlue] and [Colours.primaryPurple]
  /// as accent colors, with a gray-based dark surface palette.
  static ThemeData get dark {
    final colorScheme = const ColorScheme(
      brightness: Brightness.dark,
      primary: Colours.secondaryBlue,
      onPrimary: Colours.black,
      secondary: Colours.primaryPurple,
      onSecondary: Colours.white,
      error: Colours.errorColor,
      onError: Colours.white,
      surface: Colours.gray800,
      onSurface: Colours.gray100,
      tertiary: Colours.secondaryGreen,
      onTertiary: Colours.black,
      surfaceContainerHighest: Colours.gray800,
      surfaceContainerHigh: Colours.gray800,
      surfaceContainer: Colours.gray800,
      surfaceContainerLow: Colours.gray700,
      surfaceContainerLowest: Colours.gray900,
      surfaceBright: Colours.gray700,
      surfaceDim: Colours.gray900,
      outline: Colours.gray600,
      outlineVariant: Colours.gray700,
      shadow: Color(0x66000000),
      scrim: Colours.overlayDark,
      inverseSurface: Colours.gray50,
      onInverseSurface: Colours.gray900,
      inversePrimary: Colours.primaryBlue,
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      dividerColor: Colours.gray700,
      splashFactory: InkRipple.splashFactory,
    );

    return base.copyWith(
      textTheme: _textTheme(base.textTheme, isDark: true),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: _textTheme(base.textTheme, isDark: true).titleLarge,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(12),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: colorScheme.outline),
          foregroundColor: colorScheme.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colours.gray700,
        hintStyle: const TextStyle(color: Colours.gray400),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: _border(Colours.gray600, 12),
        enabledBorder: _border(Colours.gray600, 12),
        focusedBorder: _border(colorScheme.primary, 12, width: 1.4),
        errorBorder: _border(Colours.errorColor, 12),
        focusedErrorBorder: _border(Colours.errorColor, 12, width: 1.4),
      ),
      chipTheme: base.chipTheme.copyWith(
        color: const WidgetStatePropertyAll(Colours.gray700),
        side: const BorderSide(color: Colours.gray600),
        labelStyle: const TextStyle(color: Colours.gray200),
        selectedColor: colorScheme.secondary,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: Colours.gray400,
        type: BottomNavigationBarType.fixed,
        selectedIconTheme: const IconThemeData(size: 26),
        unselectedIconTheme: const IconThemeData(size: 24),
      ),
      dividerTheme: const DividerThemeData(
        color: Colours.gray700,
        thickness: 1,
        space: 1,
      ),
    );
  }

  // ------- Helpers -------
  /// Returns an [OutlineInputBorder] with the given [color], [radius],
  /// and optional [width].
  ///
  /// Used for text field decoration in both themes.
  static OutlineInputBorder _border(
    Color color,
    double radius, {
    double width = 1,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  /// Builds a [TextTheme] adapted to either light or dark mode.
  ///
  /// - [isDark] → determines which base colors are applied.
  /// - Overrides headline, title, body, and label styles with consistent
  ///   weights and colors.
  static TextTheme _textTheme(TextTheme base, {required bool isDark}) {
    final onSurface = isDark ? Colours.gray100 : Colours.black;
    final onSurfaceMuted = isDark ? Colours.gray300 : Colours.gray600;

    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(color: onSurface),
      displayMedium: base.displayMedium?.copyWith(color: onSurface),
      displaySmall: base.displaySmall?.copyWith(color: onSurface),
      headlineLarge: base.headlineLarge?.copyWith(color: onSurface),
      headlineMedium: base.headlineMedium?.copyWith(color: onSurface),
      headlineSmall: base.headlineSmall?.copyWith(color: onSurface),
      titleLarge: base.titleLarge?.copyWith(
        color: onSurface,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: base.titleMedium?.copyWith(
        color: onSurface,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: base.titleSmall?.copyWith(
        color: onSurfaceMuted,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: base.bodyLarge?.copyWith(color: onSurface),
      bodyMedium: base.bodyMedium?.copyWith(color: onSurface),
      bodySmall: base.bodySmall?.copyWith(color: onSurfaceMuted),
      labelLarge: base.labelLarge?.copyWith(
        color: onSurface,
        fontWeight: FontWeight.w600,
      ),
      labelMedium: base.labelMedium?.copyWith(color: onSurfaceMuted),
      labelSmall: base.labelSmall?.copyWith(color: onSurfaceMuted),
    );
  }
}
