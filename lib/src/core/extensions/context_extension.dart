import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/navigation/presentation/providers/navigation_controller.dart';
import '../../features/tapper/presentation/bloc/tapper_bloc.dart';
import '../../features/tapper/presentation/providers/tapper_provider.dart';
import '../res/typography.dart';

/// {@template context_extension}
/// Handy helpers on [BuildContext] focusing on phones & tablets:
/// - Theming (theme, colorScheme, textTheme, AppTextStyles)
/// - MediaQuery (size, paddings, insets, orientation, DPR)
/// - Design-frame scaling (width/height scale, scalar)
/// - Breakpoints simplified: `isPhone`, `isTablet`
/// - Responsive value picker: `responsivePT<T>(phone: ..., tablet: ...)`
///
/// ### Example
/// ```dart
/// // Spacing with scale
/// SizedBox(height: context.heightScale * 24);
///
/// // Theme
/// final primary = context.colorScheme.primary;
/// final title = context.textStyles.titleMd;
///
/// // Phone/Tablet responsive value
/// final columns = context.responsivePT<int>(phone: 2, tablet: 4);
/// ```
/// {@endtemplate}
extension ContextExtension on BuildContext {
  // =========================
  // THEME
  // =========================

  /// {@macro context_extension}
  ThemeData get theme => Theme.of(this);

  /// {@macro context_extension}
  ColorScheme get colorScheme => theme.colorScheme;

  /// {@macro context_extension}
  TextTheme get textTheme => theme.textTheme;

  /// {@macro context_extension}
  AppTextStyles get textStyles => AppTextStyles.of(this);

  // =========================
  // MEDIAQUERY BASICS
  // =========================

  /// {@macro context_extension}
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// {@macro context_extension}
  Size get size => MediaQuery.sizeOf(this);

  /// {@macro context_extension}
  double get width => size.width;

  /// {@macro context_extension}
  double get height => size.height;

  /// {@macro context_extension}
  double get devicePixelRatio => mediaQuery.devicePixelRatio;

  /// {@macro context_extension}
  Orientation get orientation => MediaQuery.orientationOf(this);

  /// {@macro context_extension}
  bool get isPortrait => orientation == Orientation.portrait;

  /// {@macro context_extension}
  bool get isLandscape => orientation == Orientation.landscape;

  /// {@macro context_extension}
  double get topSafe => MediaQuery.paddingOf(this).top;

  /// {@macro context_extension}
  double get bottomSafe => MediaQuery.paddingOf(this).bottom;

  /// {@macro context_extension}
  /// System navigation bar height (Android gesture nav etc.).
  double get navBarHeight => MediaQuery.viewPaddingOf(this).bottom;

  /// {@macro context_extension}
  /// Returns `true` when the on-screen keyboard is visible.
  bool get isKeyboardOpen => MediaQuery.viewInsetsOf(this).bottom > 0;

  /// {@macro context_extension}
  double get shortestSide => size.shortestSide;

  // =========================
  // DESIGN-FRAME SCALING
  // =========================

  // Master design size (tweak to your Figma frame if needed).
  static const double _designWidth = 440; // iPhone 16 Pro Max width (design)
  static const double _designHeight = 956; // iPhone 16 Pro Max height (design)

  /// {@macro context_extension}
  double get widthScale => width / _designWidth;

  /// {@macro context_extension}
  double get heightScale => height / _designHeight;

  /// {@macro context_extension}
  /// Scale a value using width by default; set [byHeight] for height-based scale.
  double scale(num value, {bool byHeight = false}) =>
      (byHeight ? heightScale : widthScale) * value;

  // =========================
  // BREAKPOINTS: PHONES & TABLETS
  // =========================

  // Only two tiers: Phone vs Tablet (material guidance uses 600 dp)
  static const double _bpTabletMin = 600;

  /// {@macro context_extension}
  bool get isTablet => shortestSide >= _bpTabletMin;

  /// {@macro context_extension}
  bool get isPhone => !isTablet;

  /// {@macro context_extension}
  /// Pick a value for Phone/Tablet quickly.
  /// ```dart
  /// final grid = context.responsivePT<int>(phone: 2, tablet: 4);
  /// ```
  T responsivePT<T>({required T phone, required T tablet}) =>
      isTablet ? tablet : phone;

  /// {@macro context_extension}
  /// Opinionated grid columns for common layouts.
  /// Example:
  /// - Portrait phone: 2
  /// - Landscape phone: 3
  /// - Portrait tablet: 4
  /// - Landscape tablet: 6
  int get gridColumns {
    if (isTablet) return isLandscape ? 6 : 4;
    return isLandscape ? 3 : 2;
  }

  // =========================
  // DARK MODE
  // =========================

  /// {@macro context_extension}
  bool get isDarkMode => theme.brightness == Brightness.dark;

  // =========================
  // EXAMPLES FOR STATE (UNCOMMENT IF USED)
  // =========================

  //// Blocs
  // ExampleBloc get exampleBloc => read<ExampleBloc>();
  TapperBloc get tapperBloc => read<TapperBloc>();

  //// Providers
  // ExampleProvider get exampleProvider => read<ExampleProvider>();
  TapperProvider get tapperProvider => read<TapperProvider>();

  //// Navigation controller
  NavigationController get bottomNavigator => read<NavigationController>();
}
