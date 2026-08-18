import '../../file_template.dart';
import '../../name_case.dart';

class RepositoryImplTemplate extends CoreTemplateGen {
  @override
  String featureTpl(NameCase n) => _template(
    n,
    corePrefix: '../../../../core',
  );

  @override
  String moduleTpl(NameCase n) => _template(
    n,
    corePrefix: '../../../..',
  );

  String _template(NameCase n, {required String corePrefix}) =>
      '''
import 'package:dartz/dartz.dart';

import '$corePrefix/errors/exception.dart';
import '$corePrefix/errors/failure_mapper.dart';
import '$corePrefix/services/logging/app_logger.dart';
import '$corePrefix/utils/typedef.dart';
import '../../domain/entities/${n.snake}_entity.dart';
import '../../domain/repositories/${n.snake}_repository.dart';
import '../datasources/${n.snake}_local_data_source.dart';
import '../datasources/${n.snake}_remote_data_source.dart';

class ${n.pascal}RepositoryImpl implements ${n.pascal}Repository {
  final ${n.pascal}LocalDataSource _localDataSource;
  final ${n.pascal}RemoteDataSource _remoteDataSource;
  final AppLogger _logger;

  const ${n.pascal}RepositoryImpl({
    required ${n.pascal}LocalDataSource localDataSource,
    required ${n.pascal}RemoteDataSource remoteDataSource,
    required AppLogger logger,
  }) : _localDataSource = localDataSource,
       _remoteDataSource = remoteDataSource,
       _logger = logger;

  @override
  ResultFuture<${n.pascal}Entity> get${n.pascal}() async {
    try {
      return Right(await _localDataSource.get${n.pascal}());
    } on LocalException catch (error, stack) {
      _logger.nonFatal(
        error,
        stack,
        reason: 'Load ${n.pascal} failed',
      );
      return Left(FailureMapper.fromException(error));
    }
  }

  @override
  ResultVoid update${n.pascal}(${n.pascal}Entity ${n.camel}Params) async {
    try {
      await _remoteDataSource.update${n.pascal}(${n.camel}Params);
      return const Right(null);
    } on ServerException catch (error, stack) {
      _logger.nonFatal(
        error,
        stack,
        reason: 'Update ${n.pascal} failed',
      );
      return Left(FailureMapper.fromException(error));
    } on RequestCancelledException {
      return const Right(null);
    }
  }
}
''';
}
