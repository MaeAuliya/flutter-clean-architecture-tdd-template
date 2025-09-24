import '../utils/typedef.dart';

/// {@template usecase_with_params}
/// Base abstract class for a use case that **requires input parameters**.
///
/// - [Types] → the return type of the use case.
/// - [Params] → the input parameters needed to execute the use case.
/// - Returns a [ResultFuture] that represents either a success or failure.
///
/// Example usage:
/// ```dart
/// class GetUserProfile extends UseCaseWithParams<User, int> {
///   final UserRepository repository;
///
///   const GetUserProfile(this.repository);
///
///   @override
///   ResultFuture<User> call(int userId) {
///     return repository.getUserById(userId);
///   }
/// }
/// ```
/// {@endtemplate}
abstract class UseCaseWithParams<Types, Params> {
  /// {@macro usecase_with_params}
  const UseCaseWithParams();

  /// Executes the use case with the given [params].
  ResultFuture<Types> call(Params params);
}

/// {@template usecase_without_params}
/// Base abstract class for a use case that **does not require input parameters**.
///
/// - [Types] → the return type of the use case.
/// - Returns a [ResultFuture] that represents either a success or failure.
///
/// Example usage:
/// ```dart
/// class GetCurrentUser extends UseCaseWithoutParams<User> {
///   final UserRepository repository;
///
///   const GetCurrentUser(this.repository);
///
///   @override
///   ResultFuture<User> call() {
///     return repository.getCurrentUser();
///   }
/// }
/// ```
/// {@endtemplate}
abstract class UseCaseWithoutParams<Types> {
  /// {@macro usecase_without_params}
  const UseCaseWithoutParams();

  /// Executes the use case with no parameters.
  ResultFuture<Types> call();
}

/// {@template usecase_stream_with_params}
/// Base abstract class for a **stream-based use case** that requires parameters.
///
/// - [Types] → the return type of the stream.
/// - [Params] → the input parameters needed to execute the use case.
/// - Returns a [ResultStream] that emits success or failure over time.
///
/// Example usage:
/// ```dart
/// class WatchUserActivity extends UseCaseStreamWithParams<Activity, int> {
///   final ActivityRepository repository;
///
///   const WatchUserActivity(this.repository);
///
///   @override
///   ResultStream<Activity> call(int userId) {
///     return repository.watchActivity(userId);
///   }
/// }
/// ```
/// {@endtemplate}
abstract class UseCaseStreamWithParams<Types, Params> {
  /// {@macro usecase_stream_with_params}
  const UseCaseStreamWithParams();

  /// Executes the use case with the given [params].
  ResultStream<Types> call(Params params);
}

/// {@template usecase_stream_without_params}
/// Base abstract class for a **stream-based use case** with no parameters.
///
/// - [Types] → the return type of the stream.
/// - Returns a [ResultStream] that emits success or failure over time.
///
/// Example usage:
/// ```dart
/// class WatchAllUsers extends UseCaseStreamWithoutParams<User> {
///   final UserRepository repository;
///
///   const WatchAllUsers(this.repository);
///
///   @override
///   ResultStream<User> call() {
///     return repository.watchAllUsers();
///   }
/// }
/// ```
/// {@endtemplate}
abstract class UseCaseStreamWithoutParams<Types> {
  /// {@macro usecase_stream_without_params}
  const UseCaseStreamWithoutParams();

  /// Executes the use case without parameters.
  ResultStream<Types> call();
}
