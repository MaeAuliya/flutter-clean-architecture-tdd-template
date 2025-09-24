import 'package:equatable/equatable.dart';

import 'exception.dart';

/// {@template failure}
/// Base abstract class for all failures used across the app.
///
/// A [Failure] is the **domain-friendly representation** of an [Exception].
/// Instead of exposing raw exceptions directly to the UI layer,
/// they are mapped into [Failure] objects, which are easier to test,
/// handle, and display.
///
/// Properties:
/// - [message] → human-readable error description.
/// - [statusCode] → status code that indicates the type of error.
///
/// Example usage:
/// ```dart
/// try {
///   final response = await api.getUser();
///   if (response.statusCode != 200) {
///     throw ServerException(message: "User not found", statusCode: 404);
///   }
/// } on ServerException catch (e) {
///   return Left(ServerFailure.fromException(e));
/// } on LocalException catch (e) {
///   return Left(LocalFailure.fromException(e));
/// }
/// ```
/// {@endtemplate}
abstract class Failure extends Equatable {
  /// {@macro failure}
  final String message;

  /// {@macro failure}
  final int statusCode;

  /// {@macro failure}
  const Failure({required this.message, required this.statusCode});

  /// A formatted error message that combines [statusCode] and [message].
  String get errorMessage => '$statusCode: $message';

  @override
  List<Object?> get props => [message, statusCode];
}

/// {@template server_failure}
/// A [Failure] that represents an error coming from the **remote server / API**.
///
/// Typically mapped from a [ServerException].
///
/// Example usage:
/// ```dart
/// on ServerException catch (e) {
///   return Left(ServerFailure.fromException(e));
/// }
/// ```
/// {@endtemplate}
class ServerFailure extends Failure {
  /// {@macro server_failure}
  const ServerFailure({required super.message, required super.statusCode});

  /// Creates a [ServerFailure] from a [ServerException].
  ServerFailure.fromException(ServerException exception)
    : this(message: exception.message, statusCode: exception.statusCode);
}

/// {@template local_failure}
/// A [Failure] that represents an error coming from **local resources**
/// such as cache, database, or local storage.
///
/// Typically mapped from a [LocalException].
///
/// Example usage:
/// ```dart
/// on LocalException catch (e) {
///   return Left(LocalFailure.fromException(e));
/// }
/// ```
/// {@endtemplate}
class LocalFailure extends Failure {
  /// {@macro local_failure}
  const LocalFailure({required super.message, required super.statusCode});

  /// Creates a [LocalFailure] from a [LocalException].
  ///
  /// Note: [statusCode] is defaulted to `500`
  /// since local errors usually don't have HTTP codes.
  LocalFailure.fromException(LocalException exception)
    : this(message: exception.message, statusCode: 500);
}
