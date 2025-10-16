import 'package:dartz/dartz.dart';

import '../../../../core/errors/exception.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/utils/typedef.dart';
import '../../domain/entities/template_version.dart';
import '../../domain/repositories/template_repository.dart';
import '../datasources/template_local_data_source.dart';
import '../datasources/template_remote_data_source.dart';

class TemplateRepositoryImpl implements TemplateRepository {
  final TemplateRemoteDataSource _remoteDataSource;
  final TemplateLocalDataSource _localDataSource;

  const TemplateRepositoryImpl({
    required TemplateRemoteDataSource remoteDataSource,
    required TemplateLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  @override
  ResultVoid openGithubUrl() async {
    try {
      final result = await _remoteDataSource.openGithubUrl();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<TemplateVersion> getCurrentTemplateVersion() async {
    try {
      final result = await _localDataSource.getCurrentTemplateVersion();
      return Right(result);
    } on LocalException catch (e) {
      return Left(LocalFailure.fromException(e));
    }
  }
}
