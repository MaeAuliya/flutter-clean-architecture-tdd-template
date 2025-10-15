/// {@template api}
/// Centralized class to manage **all API endpoints** in the project.
///
/// This uses compile-time environment variables defined via
/// `--dart-define-from-file`, ensuring that API keys and base URLs
/// are not hardcoded in source code.
///
/// ---
/// ### Setup
/// Create an `env.json` file in the project root:
/// ```json
/// {
///   "BASE_URL": "https://api.example.com",
///   "EXAMPLE": "/v1/example"
/// }
/// ```
///
/// Run the app with:
/// ```bash
/// flutter run --dart-define-from-file=env.json
/// ```
///
/// ---
/// ### Usage
/// ```dart
/// final api = API();
/// print(api.baseUrl);             // → https://api.example.com
/// print(api.exampleAPI.example);  // → /v1/example
/// ```
/// {@endtemplate}
class API {
  /// {@macro api}
  final ExampleAPI exampleAPI;
  final WeatherAPI weatherAPI;

  /// {@macro api}
  const API()
    : exampleAPI = const ExampleAPI(),
      weatherAPI = const WeatherAPI();

  /// The base URL for the API, retrieved from env `BASE_URL`.
  String get baseUrl => const String.fromEnvironment("BASE_URL");
}

/// {@template example_api}
/// Example subset of API endpoints.
///
/// Organize related endpoints into their own class for better modularity.
///
/// Example:
/// ```dart
/// final api = API();
/// print(api.exampleAPI.example); // → /v1/example
/// ```
/// {@endtemplate}
class ExampleAPI {
  /// {@macro example_api}
  const ExampleAPI();

  /// Example endpoint retrieved from env `EXAMPLE`.
  String get example => const String.fromEnvironment("EXAMPLE");
}

class WeatherAPI {
  const WeatherAPI();

  String get weather => const String.fromEnvironment("WEATHER_URL");
}
