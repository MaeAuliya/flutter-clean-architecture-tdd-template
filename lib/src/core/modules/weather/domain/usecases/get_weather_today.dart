import '../../../../usecases/usecase.dart';
import '../../../../utils/typedef.dart';
import '../entities/core_weather.dart';
import '../repositories/weather_repository.dart';

class GetWeatherToday implements UseCaseWithoutParams<CoreWeather> {
  final WeatherRepository _repository;

  const GetWeatherToday({required WeatherRepository repository})
    : _repository = repository;

  @override
  ResultFuture<CoreWeather> call() => _repository.getWeatherToday();
}
