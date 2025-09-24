import 'dart:ui';

import '../res/colours.dart';

/// {@template example_enum}
/// Example enum that represents a **generic status** in the app.
///
/// Useful as a template for creating other enums with utility classes.
///
/// Values:
/// - [active]   → Item is enabled and can be interacted with.
/// - [inactive] → Item exists but cannot be interacted with.
/// - [pending]  → Item is awaiting confirmation or action.
/// {@endtemplate}
enum Status {
  /// {@macro status_enum}
  active,

  /// {@macro status_enum}
  inactive,

  /// {@macro status_enum}
  pending,
}

/// {@template status_enums}
/// Utility class that provides helper methods for working with [Status].
///
/// This follows the same pattern as `UserClassEnums`,
/// allowing you to:
/// - Map external codes into [Status].
/// - Resolve UI-related properties like colors using the [Colours] class.
///
/// Example usage:
/// ```dart
/// final status = StatusEnums.getStatus(1);
/// print(status); // Status.active
///
/// final bg = StatusEnums.getBackgroundColor(Status.pending);
/// print(bg); // Colours.primaryOrange
/// ```
/// {@endtemplate}
class StatusEnums {
  /// {@macro status_enums}
  static Status getStatus(int code) {
    switch (code) {
      case 1:
        return Status.active;
      case 2:
        return Status.inactive;
      case 3:
        return Status.pending;
      default:
        return Status.inactive;
    }
  }

  /// {@macro status_enums}
  ///
  /// Returns a background [Color] for the given [Status].
  /// The colors are defined in [Colours].
  static Color getBackgroundColor(Status status) {
    switch (status) {
      case Status.active:
        return Colours.primaryBlue;
      case Status.inactive:
        return Colours.primaryGreen;
      case Status.pending:
        return Colours.primaryOrange;
    }
  }

  /// {@macro status_enums}
  ///
  /// Returns a foreground [Color] for the given [Status].
  /// The colors are defined in [Colours].
  static Color getForegroundColor(Status status) {
    switch (status) {
      case Status.active:
        return Colours.white;
      case Status.inactive:
        return Colours.gray500;
      case Status.pending:
        return Colours.black;
    }
  }
}
