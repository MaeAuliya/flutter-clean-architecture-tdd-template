import 'package:dio/dio.dart';
import 'package:flutter_clean_tdd_template/src/core/errors/exception.dart';
import 'package:flutter_clean_tdd_template/src/core/services/network/transport_exception_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  DioException exception({
    required DioExceptionType type,
    int? statusCode,
  }) {
    final request = RequestOptions(path: '/test');
    return DioException(
      requestOptions: request,
      type: type,
      response: statusCode == null
          ? null
          : Response<void>(requestOptions: request, statusCode: statusCode),
    );
  }

  test('maps connection errors to network exceptions', () {
    expect(
      () => TransportExceptionMapper.throwMapped(
        exception(type: DioExceptionType.connectionError),
      ),
      throwsA(
        isA<ServerException>().having(
          (error) => error.kind,
          'kind',
          ServerExceptionKind.network,
        ),
      ),
    );
  });

  test('maps HTTP status codes to semantic exceptions', () {
    final cases = <(int, ServerExceptionKind)>[
      (401, ServerExceptionKind.unauthorized),
      (422, ServerExceptionKind.validation),
      (503, ServerExceptionKind.server),
    ];

    for (final (statusCode, kind) in cases) {
      expect(
        () => TransportExceptionMapper.throwMapped(
          exception(type: DioExceptionType.badResponse, statusCode: statusCode),
        ),
        throwsA(
          isA<ServerException>().having((error) => error.kind, 'kind', kind),
        ),
      );
    }
  });

  test('maps transport failures without exposing client diagnostics', () {
    const privateDetail = 'private response detail';
    final error = DioException(
      requestOptions: RequestOptions(path: '/test'),
      type: DioExceptionType.unknown,
      message: privateDetail,
    );

    expect(
      () => TransportExceptionMapper.throwMapped(error),
      throwsA(
        isA<ServerException>()
            .having(
              (exception) => exception.kind,
              'kind',
              ServerExceptionKind.rejected,
            )
            .having(
              (exception) => exception.diagnosticMessage,
              'diagnosticMessage',
              isNot(contains(privateDetail)),
            ),
      ),
    );
  });

  test('maps cancellation before any attached response status', () {
    expect(
      () => TransportExceptionMapper.throwMapped(
        exception(type: DioExceptionType.cancel, statusCode: 503),
      ),
      throwsA(isA<RequestCancelledException>()),
    );
  });
}
