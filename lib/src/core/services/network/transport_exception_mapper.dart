import 'package:dio/dio.dart';

import '../../errors/exception.dart';

abstract final class TransportExceptionMapper {
  static Never throwMapped(DioException error) {
    if (error.type == DioExceptionType.cancel) {
      throw const RequestCancelledException();
    }

    final statusCode = error.response?.statusCode;

    if (statusCode == 401 || statusCode == 403) {
      throw const ServerException.unauthorized(
        diagnosticMessage: 'Transport rejected authorization',
      );
    }

    if (statusCode == 400 || statusCode == 422) {
      throw const ServerException.validation(
        diagnosticMessage: 'Transport rejected request validation',
      );
    }

    if (statusCode != null && statusCode >= 500) {
      throw const ServerException.server(
        diagnosticMessage: 'Transport server failure',
      );
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        throw const ServerException.network(
          diagnosticMessage: 'Transport connection failure',
        );
      case DioExceptionType.cancel:
        throw const RequestCancelledException();
      case DioExceptionType.badCertificate:
      case DioExceptionType.badResponse:
      case DioExceptionType.unknown:
        throw const ServerException.rejected(
          diagnosticMessage: 'Transport request rejected',
        );
    }
  }
}
