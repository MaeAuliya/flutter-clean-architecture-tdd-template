import '../../../../utils/typedef.dart';
import '../../domain/entities/core_weather.dart';
import 'core_weather_time_location_model.dart';

class CoreWeatherModel extends CoreWeather {
  const CoreWeatherModel({
    required super.temperature,
    required super.timeLocation,
  });

  CoreWeatherModel.empty()
    : super(
        temperature: 0,
        timeLocation: CoreWeatherTimeLocationModel.empty(),
      );

  CoreWeatherModel.fromMap(DataMap map)
    : super(
        temperature: map['temperature'],
        timeLocation: CoreWeatherTimeLocationModel.fromMap(
          map['time_location'],
        ),
      );

  CoreWeatherModel.fromEntity(CoreWeather entity)
    : super(
        temperature: entity.temperature,
        timeLocation: entity.timeLocation,
      );
}
