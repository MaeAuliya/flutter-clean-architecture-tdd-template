/// {@template texts}
/// Centralized class for managing all static text strings used in the app.
///
/// Benefits:
/// - Consistent wording across the app.
/// - Easier maintenance (update in one place).
/// - Simple localization (copy this file for another language).
///
/// Example:
/// ```dart
/// Text(Texts.login);               // "Login"
/// Text(Texts.stateEmpty);          // "No data available"
/// Text(Texts.errorNoInternet);     // "No internet connection."
/// ```
///
/// For localization, create a separate file like `texts_id.dart`
/// with the same keys but translated values.
/// {@endtemplate}
class Texts {
  const Texts._(); // Prevent instantiation

  // =====================
  // Dummy / Placeholder
  // =====================
  static const dummyText =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
      'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.';

  static const exampleText = 'This is an example text.';

  // =====================
  // Authentication
  // =====================
  static const login = 'Login';
  static const logout = 'Logout';
  static const register = 'Register';
  static const email = 'Email';
  static const password = 'Password';
  static const forgotPassword = 'Forgot Password?';
  static const confirmPassword = 'Confirm Password';

  // =====================
  // Home / General
  // =====================
  static const homeTitle = 'Home';
  static const welcomeMessage = 'Welcome back!';
  static const searchHint = 'Search...';

  // =====================
  // States
  // =====================
  static const success = 'Success';
  static const stateEmpty = 'No data available.';
  static const stateLoading = 'Loading...';
  static const stateSuccess = 'Operation completed successfully.';
  static const stateError = 'Something went wrong. Please try again.';
  static const stateNoInternet = 'No internet connection.';
  static const stateUnauthorized = 'You are not authorized.';
  static const stateRefreshing = 'Refreshing...';
  static const stateCompleted = 'All tasks completed.';
  static const pageUnderConstruction = 'This page currently under construction';

  // =====================
  // Errors
  // =====================
  static const error = 'Error';
  static const errorSomethingWentWrong =
      'Something went wrong. Please try again.';
  static const errorNoInternet = 'No internet connection.';
  static const errorInvalidEmail = 'Please enter a valid email address.';
  static const errorEmptyField = 'This field cannot be empty.';

  // =====================
  // Buttons
  // =====================
  static const btnSave = 'Save';
  static const btnCancel = 'Cancel';
  static const btnSubmit = 'Submit';
  static const btnContinue = 'Continue';

  // =====================
  // Validator
  // =====================
  static const emptyValidator = 'This field cannot be empty.';
  static const passwordEightCharValidator =
      'Password must be at least 8 characters.';
  static const passwordValueValidator = 'Passwords do not match.';
  static const phoneDigitsOnlyValidator =
      'Phone number must contain only digits.';
  static const phoneMinLengthValidator =
      'Phone number must be at least 10 digits.';
  static const phoneMaxLengthValidator =
      'Phone number must be no more than 15 digits.';
  static const emailInvalidValidator = 'Please enter a valid email address.';

  static const statisticsDummyDesc =
      'This is your Statistic Page — a space designed for creativity and exploration. Use this page to visualize data, track progress, or showcase any form of analytics that fits your app’s purpose. Feel free to customize the layout, charts, and metrics to match your own idea — whether it’s user activity, performance trends, achievements, or something entirely new. Make it yours.';
}
