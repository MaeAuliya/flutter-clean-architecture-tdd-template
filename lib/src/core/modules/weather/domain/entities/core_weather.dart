import 'package:equatable/equatable.dart';

import 'core_weather_time_location.dart';

class CoreWeather extends Equatable {
  final double temperature;
  final CoreWeatherTimeLocation timeLocation;

  const CoreWeather({
    required this.temperature,
    required this.timeLocation,
  });

  @override
  List<Object?> get props => [
    temperature,
    timeLocation,
  ];
}
