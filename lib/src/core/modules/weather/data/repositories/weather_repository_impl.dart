import 'package:dartz/dartz.dart';

import '../../../../errors/exception.dart';
import '../../../../errors/failure.dart';
import '../../../../utils/typedef.dart';
import '../../domain/entities/core_weather.dart';
import '../../domain/repositories/weather_repository.dart';
import '../datasources/weather_remote_data_source.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource _remoteDataSource;

  const WeatherRepositoryImpl({
    required WeatherRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  ResultFuture<CoreWeather> getWeatherToday() async {
    try {
      final result = await _remoteDataSource.getWeatherToday();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }
}
