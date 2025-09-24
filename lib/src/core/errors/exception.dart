import 'package:equatable/equatable.dart';

/// {@template server_exception}
/// An [Exception] that represents errors coming from a **remote server / API**.
///
/// Typically thrown when:
/// - The request returns a non-2xx status code.
/// - A network-related issue occurs (e.g., timeout, no connection).
///
/// Example usage:
/// ```dart
/// final response = await client.get(Uri.parse("https://api.example.com"));
/// if (response.statusCode != 200) {
///   throw ServerException(
///     message: "Failed to fetch data",
///     statusCode: response.statusCode,
///   );
/// }
/// ```
/// {@endtemplate}
class ServerException extends Equatable implements Exception {
  /// {@macro server_exception}
  final String message;

  /// {@macro server_exception}
  final int statusCode;

  /// {@macro server_exception}
  const ServerException({required this.message, required this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

/// {@template local_exception}
/// An [Exception] that represents errors coming from **local resources**
/// such as cache, database, or local storage.
///
/// Typically thrown when:
/// - Data is missing in cache or preferences.
/// - Reading/writing to local storage fails.
/// - Local data is corrupted.
///
/// Example usage:
/// ```dart
/// final token = await storage.read(key: "token");
/// if (token == null) {
///   throw const LocalException(
///     message: "No token found in local storage",
///   );
/// }
/// ```
/// {@endtemplate}
class LocalException extends Equatable implements Exception {
  /// {@macro local_exception}
  final String message;

  /// {@macro local_exception}
  const LocalException({required this.message});

  @override
  List<Object?> get props => [message];
}
