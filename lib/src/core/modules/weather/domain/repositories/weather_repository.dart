import '../../../../utils/typedef.dart';
import '../entities/core_weather.dart';

abstract class WeatherRepository {
  const WeatherRepository();

  ResultFuture<CoreWeather> getWeatherToday();
}
