import 'exception.dart';
import 'failure.dart';

abstract final class FailureMapper {
  static Failure fromException(Object error) {
    return switch (error) {
      ServerException(kind: ServerExceptionKind.network) => NetworkFailure(
        userMessage: 'Check your connection and try again.',
        cause: error,
      ),
      ServerException(kind: ServerExceptionKind.unauthorized) =>
        UnauthorizedFailure(
          userMessage: 'Your session has expired. Please sign in again.',
          cause: error,
        ),
      ServerException(kind: ServerExceptionKind.validation) =>
        ValidationFailure(
          userMessage: 'Check the provided information and try again.',
          cause: error,
        ),
      ServerException(kind: ServerExceptionKind.server) => ServerFailure(
        userMessage: 'The service is unavailable. Please try again later.',
        cause: error,
      ),
      ServerException(kind: ServerExceptionKind.rejected) => ServerFailure(
        userMessage: 'The request could not be completed.',
        cause: error,
      ),
      LocalException() => StorageFailure(
        userMessage: 'Saved data could not be loaded.',
        cause: error,
      ),
      _ => UnexpectedFailure(
        userMessage: 'Something went wrong. Please try again.',
        cause: error,
      ),
    };
  }
}
