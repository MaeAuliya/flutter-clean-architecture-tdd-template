import 'package:dio/dio.dart';

/// {@template api_headers}
/// Utility class to generate standardized **API request headers**.
///
/// By default, it includes:
/// - `Accept: application/json`
///
/// You can also:
/// - Attach a `Bearer` token for authenticated requests.
/// - Merge in custom headers via [additionalHeaders].
///
/// ---
/// ### Usage
/// ```dart
/// // Basic usage
/// final options = APIHeaders.getHeaders();
///
/// // With authentication
/// final options = APIHeaders.getHeaders(token: "your_token");
///
/// // With additional headers
/// final options = APIHeaders.getHeaders(
///   token: "your_token",
///   additionalHeaders: {
///     "X-Custom-Header": "CustomValue",
///   },
/// );
///
/// // Apply to Dio
/// final dio = Dio();
/// final response = await dio.get(
///   "https://api.example.com/data",
///   options: options,
/// );
/// ```
/// {@endtemplate}
class APIHeaders {
  /// {@macro api_headers}
  static Options getHeaders({
    String? token,
    Map<String, String>? additionalHeaders,
  }) {
    Map<String, String> headers = {'Accept': 'application/json'};

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    if (additionalHeaders != null && additionalHeaders.isNotEmpty) {
      headers.addAll(additionalHeaders);
    }

    return Options(headers: headers);
  }
}
