import 'package:equatable/equatable.dart';

enum ServerExceptionKind {
  network,
  unauthorized,
  validation,
  server,
  rejected,
}

final class RequestCancelledException implements Exception {
  const RequestCancelledException();
}

final class ServerException extends Equatable implements Exception {
  final ServerExceptionKind kind;
  final String? diagnosticMessage;

  const ServerException({required this.kind, this.diagnosticMessage});

  const ServerException.network({this.diagnosticMessage})
    : kind = ServerExceptionKind.network;

  const ServerException.unauthorized({this.diagnosticMessage})
    : kind = ServerExceptionKind.unauthorized;

  const ServerException.validation({this.diagnosticMessage})
    : kind = ServerExceptionKind.validation;

  const ServerException.server({this.diagnosticMessage})
    : kind = ServerExceptionKind.server;

  const ServerException.rejected({this.diagnosticMessage})
    : kind = ServerExceptionKind.rejected;

  @override
  List<Object?> get props => [kind, diagnosticMessage];
}

final class LocalException extends Equatable implements Exception {
  final String? diagnosticMessage;

  const LocalException({this.diagnosticMessage});

  @override
  List<Object?> get props => [diagnosticMessage];
}
