import 'package:flutter_clean_tdd_template/src/core/errors/exception.dart';
import 'package:flutter_clean_tdd_template/src/core/errors/failure.dart';
import 'package:flutter_clean_tdd_template/src/core/errors/failure_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const cases = <(Object, Type)>[
    (ServerException.network(), NetworkFailure),
    (ServerException.unauthorized(), UnauthorizedFailure),
    (ServerException.validation(), ValidationFailure),
    (ServerException.server(), ServerFailure),
    (ServerException.rejected(), ServerFailure),
    (LocalException(), StorageFailure),
    ('unknown error', UnexpectedFailure),
  ];

  for (final (error, failureType) in cases) {
    test('$error maps to $failureType without exposing diagnostics', () {
      final failure = FailureMapper.fromException(error);

      expect(failure.runtimeType, failureType);
      expect(failure.cause, error);
      expect(failure.userMessage, isNot(contains(error.toString())));
    });
  }
}
