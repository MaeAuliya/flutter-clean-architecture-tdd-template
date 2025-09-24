import 'package:dartz/dartz.dart';

import '../errors/failure.dart';

/// {@template result_future}
/// A type alias representing an asynchronous computation that
/// returns either a [Failure] or a successful value of type [T].
///
/// Equivalent to:
/// ```dart
/// Future<Either<Failure, T>>
/// ```
/// {@endtemplate}
typedef ResultFuture<T> = Future<Either<Failure, T>>;

/// {@template result_stream}
/// A type alias representing a stream of values where each event
/// can be either a [Failure] or a successful value of type [T].
///
/// Equivalent to:
/// ```dart
/// Stream<Either<Failure, T>>
/// ```
/// {@endtemplate}
typedef ResultStream<T> = Stream<Either<Failure, T>>;

/// {@template result_void}
/// A type alias for a [ResultFuture] that returns no value (`void`)
/// but still conveys success or failure.
///
/// Equivalent to:
/// ```dart
/// ResultFuture<void>
/// ```
/// {@endtemplate}
typedef ResultVoid = ResultFuture<void>;

/// {@template data_map}
/// A shorthand alias for a [Map] with `String` keys and `dynamic` values.
///
/// Useful for representing JSON-like data structures.
///
/// Equivalent to:
/// ```dart
/// Map<String, dynamic>
/// ```
/// {@endtemplate}
typedef DataMap = Map<String, dynamic>;
