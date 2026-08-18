import 'package:dartz/dartz.dart';

import '../../../../core/errors/exception.dart';
import '../../../../core/errors/failure_mapper.dart';
import '../../../../core/services/logging/app_logger.dart';
import '../../../../core/utils/typedef.dart';
import '../../domain/entities/template_version.dart';
import '../../domain/repositories/template_repository.dart';
import '../datasources/template_local_data_source.dart';
import '../datasources/template_remote_data_source.dart';

class TemplateRepositoryImpl implements TemplateRepository {
  final TemplateRemoteDataSource _remoteDataSource;
  final TemplateLocalDataSource _localDataSource;
  final AppLogger _logger;

  const TemplateRepositoryImpl({
    required TemplateRemoteDataSource remoteDataSource,
    required TemplateLocalDataSource localDataSource,
    required AppLogger logger,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
       _logger = logger;

  @override
  ResultVoid openGithubUrl() async {
    try {
      await _remoteDataSource.openGithubUrl();
      return const Right(null);
    } on ServerException catch (error, stack) {
      _logger.nonFatal(error, stack, reason: 'Open GitHub URL failed');
      return Left(FailureMapper.fromException(error));
    } on RequestCancelledException {
      return const Right(null);
    }
  }

  @override
  ResultFuture<TemplateVersion> getCurrentTemplateVersion() async {
    try {
      final result = await _localDataSource.getCurrentTemplateVersion();
      return Right(result);
    } on LocalException catch (error, stack) {
      _logger.nonFatal(error, stack, reason: 'Load template version failed');
      return Left(FailureMapper.fromException(error));
    }
  }
}
