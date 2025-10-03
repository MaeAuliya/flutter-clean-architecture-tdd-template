import 'package:dartz/dartz.dart';

import '../../../../core/errors/exception.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/utils/typedef.dart';
import '../../domain/entities/tap_per_day.dart';
import '../../domain/repositories/tapper_repository.dart';
import '../datasources/tapper_local_data_source.dart';
import '../datasources/tapper_remote_data_source.dart';

class TapperRepositoryImpl implements TapperRepository {
  final TapperLocalDataSource _localDataSource;
  final TapperRemoteDataSource _remoteDataSource;

  const TapperRepositoryImpl({
    required TapperLocalDataSource localDataSource,
    required TapperRemoteDataSource remoteDataSource,
  }) : _localDataSource = localDataSource,
       _remoteDataSource = remoteDataSource;

  @override
  ResultFuture<List<TapPerDay>> getAllTapPerDay() async {
    try {
      final result = await _localDataSource.getAllTapPerDay();
      return Right(result);
    } on LocalException catch (e) {
      return Left(LocalFailure.fromException(e));
    }
  }

  @override
  ResultFuture<TapPerDay?> getTodayTapPerDay() async {
    try {
      final result = await _localDataSource.getTodayTapPerDay();
      return Right(result);
    } on LocalException catch (e) {
      return Left(LocalFailure.fromException(e));
    }
  }

  @override
  ResultVoid longPress(int taps) async {
    try {
      final result = await _localDataSource.longPress(taps);
      return Right(result);
    } on LocalException catch (e) {
      return Left(LocalFailure.fromException(e));
    }
  }

  @override
  ResultVoid tap(int steps) async {
    try {
      final result = await _localDataSource.tap(steps);
      return Right(result);
    } on LocalException catch (e) {
      return Left(LocalFailure.fromException(e));
    }
  }

  @override
  ResultVoid goToRepository() async {
    try {
      final result = await _remoteDataSource.goToRepository();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }
}
