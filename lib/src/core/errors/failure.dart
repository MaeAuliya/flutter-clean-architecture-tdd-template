import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  final String userMessage;
  final Object? cause;

  const Failure({required this.userMessage, this.cause});

  @override
  List<Object?> get props => [userMessage, cause];
}

final class NetworkFailure extends Failure {
  const NetworkFailure({required super.userMessage, super.cause});
}

final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({required super.userMessage, super.cause});
}

final class ValidationFailure extends Failure {
  const ValidationFailure({required super.userMessage, super.cause});
}

final class ServerFailure extends Failure {
  const ServerFailure({required super.userMessage, super.cause});
}

final class StorageFailure extends Failure {
  const StorageFailure({required super.userMessage, super.cause});
}

final class UnexpectedFailure extends Failure {
  const UnexpectedFailure({required super.userMessage, super.cause});
}
