import 'package:flutter/material.dart';

import '../extensions/context_extension.dart';
import 'fonts.dart';

/// {@template core_typography}
/// Centralized typography system for the application.
///
/// This class:
/// - Defines **font weights** (regular → extraBold).
/// - Provides a **dynamic style builder** for flexible overrides.
/// - Contains **preset text styles** (display, headline, title, body, label).
/// - Integrates with [ThemeData] via [toTextTheme].
///
/// ### Example usage:
/// ```dart
/// Text(
///   'Dashboard',
///   style: CoreTypography.headlineMd,
/// );
///
/// final style = CoreTypography.style(
///   size: 16,
///   weight: CoreTypography.semiBold,
///   color: theme.colorScheme.primary,
///   underline: true,
/// );
/// ```
///
/// ### Benefits:
/// - Consistent typography across the app.
/// - Easier maintenance & readability.
/// - Ready for light/dark theme integration.
/// {@endtemplate}
class CoreTypography {
  const CoreTypography._();

  // =====================
  // Font Weights
  // =====================
  static const FontWeight extraBold = FontWeight.w800;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight regular = FontWeight.w400;

  // =====================
  // Dynamic Builder
  // =====================

  /// Creates a custom [TextStyle] dynamically.
  ///
  /// Supply only the attributes you want to override.
  ///
  /// Example:
  /// ```dart
  /// final style = CoreTypography.style(
  ///   size: 14,
  ///   weight: CoreTypography.medium,
  ///   color: Colors.red,
  ///   strikeThrough: true,
  /// );
  /// ```
  static TextStyle style({
    double? size,
    FontWeight? weight,
    Color? color,
    double? height,
    double? letterSpacing,
    bool underline = false,
    bool strikeThrough = false,
    FontStyle fontStyle = FontStyle.normal,
    List<FontFeature>? fontFeatures,
    TextLeadingDistribution? leadingDistribution,
    List<Shadow>? shadows,
    Paint? foreground,
    Paint? background,
    String? fontFamily,
  }) {
    final decoration = TextDecoration.combine([
      if (underline) TextDecoration.underline,
      if (strikeThrough) TextDecoration.lineThrough,
    ]);

    return TextStyle(
      fontFamily: fontFamily ?? Fonts.roboto,
      fontWeight: weight ?? regular,
      fontSize: size,
      height: height,
      letterSpacing: letterSpacing,
      color: color,
      decoration: decoration == TextDecoration.none ? null : decoration,
      decorationThickness: (underline || strikeThrough) ? 1.5 : null,
      fontStyle: fontStyle,
      fontFeatures: fontFeatures,
      leadingDistribution: leadingDistribution,
      shadows: shadows,
      foreground: foreground,
      background: background,
    );
  }

  // =====================
  // Preset Styles
  // =====================

  /// Display (large hero text)
  static const TextStyle displayLg = TextStyle(
    fontFamily: Fonts.roboto,
    fontWeight: extraBold,
    fontSize: 40,
    height: 1.2,
  );

  /// Display (medium hero text)
  static const TextStyle displayMd = TextStyle(
    fontFamily: Fonts.roboto,
    fontWeight: bold,
    fontSize: 32,
    height: 1.2,
  );

  /// Headline (large)
  static const TextStyle headlineLg = TextStyle(
    fontFamily: Fonts.roboto,
    fontWeight: bold,
    fontSize: 28,
    height: 1.25,
  );

  /// Headline (medium)
  static const TextStyle headlineMd = TextStyle(
    fontFamily: Fonts.roboto,
    fontWeight: semiBold,
    fontSize: 24,
    height: 1.25,
  );

  /// Title (large)
  static const TextStyle titleLg = TextStyle(
    fontFamily: Fonts.roboto,
    fontWeight: semiBold,
    fontSize: 20,
    height: 1.3,
  );

  /// Title (medium)
  static const TextStyle titleMd = TextStyle(
    fontFamily: Fonts.roboto,
    fontWeight: semiBold,
    fontSize: 18,
    height: 1.3,
  );

  /// Title (small)
  static const TextStyle titleSm = TextStyle(
    fontFamily: Fonts.roboto,
    fontWeight: medium,
    fontSize: 16,
    height: 1.35,
  );

  /// Body (large paragraph)
  static const TextStyle bodyLg = TextStyle(
    fontFamily: Fonts.roboto,
    fontWeight: regular,
    fontSize: 16,
    height: 1.5,
  );

  /// Body (medium paragraph)
  static const TextStyle bodyMd = TextStyle(
    fontFamily: Fonts.roboto,
    fontWeight: regular,
    fontSize: 14,
    height: 1.5,
  );

  /// Body (small text)
  static const TextStyle bodySm = TextStyle(
    fontFamily: Fonts.roboto,
    fontWeight: regular,
    fontSize: 12,
    height: 1.4,
  );

  /// Label (large - e.g., button text)
  static const TextStyle labelLg = TextStyle(
    fontFamily: Fonts.roboto,
    fontWeight: semiBold,
    fontSize: 14,
    height: 1.3,
    letterSpacing: 0.1,
  );

  /// Label (small - captions, tags)
  static const TextStyle labelSm = TextStyle(
    fontFamily: Fonts.roboto,
    fontWeight: medium,
    fontSize: 11,
    height: 1.2,
    letterSpacing: 0.3,
  );

  // =====================
  // Theme Integration
  // =====================

  /// Converts the presets into a [TextTheme] for use in [ThemeData].
  ///
  /// - [onSurface] → main text color.
  /// - [onSurfaceMuted] → secondary/muted text color.
  static TextTheme toTextTheme({
    required Color onSurface,
    required Color onSurfaceMuted,
  }) {
    TextStyle c(TextStyle s, {bool muted = false}) =>
        s.copyWith(color: muted ? onSurfaceMuted : onSurface);

    return TextTheme(
      displayLarge: c(displayLg),
      displayMedium: c(displayMd),
      headlineLarge: c(headlineLg),
      headlineMedium: c(headlineMd),
      titleLarge: c(titleLg),
      titleMedium: c(titleMd),
      titleSmall: c(titleSm, muted: true),
      bodyLarge: c(bodyLg),
      bodyMedium: c(bodyMd),
      bodySmall: c(bodySm, muted: true),
      labelLarge: c(labelLg),
      labelMedium: c(labelSm, muted: true),
      labelSmall: c(labelSm.copyWith(fontSize: 10), muted: true),
    );
  }
}

/// {@template app_text_styles}
/// Wrapper for convenient access to text styles via [BuildContext].
///
/// Example:
/// ```dart
/// Text('Hello', style: context.textStyles.bodyMd);
/// ```
/// {@endtemplate}
class AppTextStyles {
  final TextTheme _theme;
  AppTextStyles._(this._theme);

  static AppTextStyles of(BuildContext context) {
    return AppTextStyles._(Theme.of(context).textTheme);
  }

  TextStyle get displayLg => _theme.displayLarge!;
  TextStyle get displayMd => _theme.displayMedium!;
  TextStyle get headlineLg => _theme.headlineLarge!;
  TextStyle get headlineMd => _theme.headlineMedium!;
  TextStyle get titleLg => _theme.titleLarge!;
  TextStyle get titleMd => _theme.titleMedium!;
  TextStyle get titleSm => _theme.titleSmall!;
  TextStyle get bodyLg => _theme.bodyLarge!;
  TextStyle get bodyMd => _theme.bodyMedium!;
  TextStyle get bodySm => _theme.bodySmall!;
  TextStyle get labelLg => _theme.labelLarge!;
  TextStyle get labelMd => _theme.labelMedium!;
  TextStyle get labelSm => _theme.labelSmall!;
}

/// {@template core_text}
/// A helper widget for one-liner text rendering.
///
/// It combines:
/// - Preset role-based styles ([TextRole]).
/// - Dynamic overrides (color, weight, size, underline, etc.).
///
/// Example:
/// ```dart
/// const CoreText(
///   'Hello World',
///   role: TextRole.titleMd,
///   underline: true,
/// );
/// ```
/// {@endtemplate}
class CoreText extends StatelessWidget {
  const CoreText(
    this.text, {
    super.key,
    TextStyle? style,
    this.role,
    this.color,
    this.weight,
    this.size,
    this.height,
    this.letterSpacing,
    this.underline = false,
    this.strikeThrough = false,
    this.textAlign,
    this.maxLines,
    this.overflow = TextOverflow.ellipsis,
    this.softWrap,
    this.family = Fonts.roboto,
  }) : _style = style;

  final String text;
  final TextStyle? _style;

  /// The role preset, e.g., [TextRole.titleMd], [TextRole.bodyLg].
  final TextRole? role;

  final Color? color;
  final FontWeight? weight;
  final double? size;
  final double? height;
  final double? letterSpacing;
  final bool underline;
  final bool strikeThrough;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;
  final String family;

  @override
  Widget build(BuildContext context) {
    TextStyle base = switch (role) {
      TextRole.displayLg => context.textStyles.displayLg,
      TextRole.displayMd => context.textStyles.displayMd,
      TextRole.headlineLg => context.textStyles.headlineLg,
      TextRole.headlineMd => context.textStyles.headlineMd,
      TextRole.titleLg => context.textStyles.titleLg,
      TextRole.titleMd => context.textStyles.titleMd,
      TextRole.titleSm => context.textStyles.titleSm,
      TextRole.bodyLg => context.textStyles.bodyLg,
      TextRole.bodyMd => context.textStyles.bodyMd,
      TextRole.bodySm => context.textStyles.bodySm,
      TextRole.labelLg => context.textStyles.labelLg,
      TextRole.labelMd => context.textStyles.labelMd,
      TextRole.labelSm => context.textStyles.labelSm,
      null =>
        Theme.of(context).textTheme.bodyMedium ?? const TextStyle(fontSize: 14),
    };

    // Apply overrides
    base = base.merge(
      CoreTypography.style(
        size: size,
        weight: weight,
        color: color,
        height: height,
        letterSpacing: letterSpacing,
        underline: underline,
        strikeThrough: strikeThrough,
        fontFamily: family,
      ),
    );

    if (_style != null) base = base.merge(_style);

    return Text(
      text,
      style: base,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
    );
  }
}

/// {@template text_role}
/// Enum representing preset typography roles.
///
/// Used in [CoreText] to pick a base style.
/// - Display → [displayLg], [displayMd]
/// - Headline → [headlineLg], [headlineMd]
/// - Title → [titleLg], [titleMd], [titleSm]
/// - Body → [bodyLg], [bodyMd], [bodySm]
/// - Label → [labelLg], [labelMd], [labelSm]
///
/// Example:
/// ```dart
/// CoreText('Welcome', role: TextRole.headlineLg);
/// ```
/// {@endtemplate}
enum TextRole {
  displayLg,
  displayMd,
  headlineLg,
  headlineMd,
  titleLg,
  titleMd,
  titleSm,
  bodyLg,
  bodyMd,
  bodySm,
  labelLg,
  labelMd,
  labelSm,
}
