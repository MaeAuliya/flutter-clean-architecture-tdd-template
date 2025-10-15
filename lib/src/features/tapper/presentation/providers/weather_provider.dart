import 'package:flutter/cupertino.dart';

import '../../../../core/modules/weather/data/models/core_weather_model.dart';
import '../../../../core/modules/weather/domain/entities/core_weather.dart';

class WeatherProvider extends ChangeNotifier {
  CoreWeatherModel? _weather;

  CoreWeatherModel? get weather => _weather;

  void updateWeather(CoreWeather weather) {
    _weather = CoreWeatherModel.fromEntity(weather);
    notifyListeners();
  }
}
