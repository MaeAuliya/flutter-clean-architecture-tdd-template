import 'package:flutter_clean_tdd_template/src/core/errors/exception.dart';
import 'package:flutter_clean_tdd_template/src/core/errors/failure.dart';
import 'package:flutter_clean_tdd_template/src/core/services/logging/app_logger.dart';
import 'package:flutter_clean_tdd_template/src/features/template/data/datasources/template_local_data_source.dart';
import 'package:flutter_clean_tdd_template/src/features/template/data/datasources/template_remote_data_source.dart';
import 'package:flutter_clean_tdd_template/src/features/template/data/models/template_version_model.dart';
import 'package:flutter_clean_tdd_template/src/features/template/data/repositories/template_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTemplateRemoteDataSource extends Mock
    implements TemplateRemoteDataSource {}

class MockTemplateLocalDataSource extends Mock
    implements TemplateLocalDataSource {}

class MockAppLogger extends Mock implements AppLogger {}

void main() {
  setUpAll(() {
    registerFallbackValue(Exception('fallback error'));
    registerFallbackValue(StackTrace.empty);
  });

  late TemplateRemoteDataSource remoteDataSource;
  late TemplateLocalDataSource localDataSource;
  late AppLogger logger;
  late TemplateRepositoryImpl repository;

  setUp(() {
    remoteDataSource = MockTemplateRemoteDataSource();
    localDataSource = MockTemplateLocalDataSource();
    logger = MockAppLogger();
    repository = TemplateRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
      logger: logger,
    );
  });

  test('maps local exceptions to StorageFailure and logs once', () async {
    const exception = LocalException(diagnosticMessage: 'private detail');
    when(
      () => localDataSource.getCurrentTemplateVersion(),
    ).thenThrow(exception);
    final result = await repository.getCurrentTemplateVersion();

    expect(
      result.fold((failure) => failure, (_) => null),
      isA<StorageFailure>(),
    );
    verify(
      () => logger.nonFatal(
        exception,
        any(),
        reason: 'Load template version failed',
      ),
    ).called(1);
  });

  test('maps remote rejection to ServerFailure and logs once', () async {
    const exception = ServerException.rejected(
      diagnosticMessage: 'private detail',
    );
    when(() => remoteDataSource.openGithubUrl()).thenThrow(exception);
    final result = await repository.openGithubUrl();

    expect(
      result.fold((failure) => failure, (_) => null),
      isA<ServerFailure>(),
    );
    verify(
      () => logger.nonFatal(
        exception,
        any(),
        reason: 'Open GitHub URL failed',
      ),
    ).called(1);
  });

  test('treats request cancellation as expected control flow', () async {
    when(
      () => remoteDataSource.openGithubUrl(),
    ).thenThrow(const RequestCancelledException());

    final result = await repository.openGithubUrl();

    expect(result.isRight(), isTrue);
    verifyNever(
      () => logger.nonFatal(
        any<Exception>(),
        any(),
        reason: any(named: 'reason'),
      ),
    );
  });

  test('returns datasource values unchanged on success', () async {
    const model = TemplateVersionModel.empty();
    when(
      () => localDataSource.getCurrentTemplateVersion(),
    ).thenAnswer((_) async => model);

    final result = await repository.getCurrentTemplateVersion();

    expect(result.fold((_) => null, (value) => value), model);
    verifyNever(
      () => logger.nonFatal(
        any<Exception>(),
        any(),
        reason: any(named: 'reason'),
      ),
    );
  });
}
