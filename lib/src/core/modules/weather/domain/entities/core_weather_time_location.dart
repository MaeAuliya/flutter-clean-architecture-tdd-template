import 'package:equatable/equatable.dart';

class CoreWeatherTimeLocation extends Equatable {
  final String districtName;
  final double latitude;
  final double longitude;
  final DateTime time;

  const CoreWeatherTimeLocation({
    required this.districtName,
    required this.latitude,
    required this.longitude,
    required this.time,
  });

  @override
  List<Object?> get props => [
    districtName,
    latitude,
    longitude,
    time,
  ];
}
