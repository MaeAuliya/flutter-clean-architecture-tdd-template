import '../../../../utils/typedef.dart';
import '../../domain/entities/core_weather_time_location.dart';

class CoreWeatherTimeLocationModel extends CoreWeatherTimeLocation {
  const CoreWeatherTimeLocationModel({
    required super.districtName,
    required super.latitude,
    required super.longitude,
    required super.time,
  });

  CoreWeatherTimeLocationModel.empty()
    : super(
        districtName: '',
        latitude: 0,
        longitude: 0,
        time: DateTime.now(),
      );

  CoreWeatherTimeLocationModel.fromMap(DataMap map)
    : super(
        districtName: map['district_name'] as String,
        latitude: map['latitude'] as double,
        longitude: map['longitude'] as double,
        time: DateTime.parse(map['current_time'] as String),
      );
}
