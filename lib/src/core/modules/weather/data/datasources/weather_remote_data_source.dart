import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../errors/exception.dart';
import '../../../../services/api.dart';
import '../../../../services/api_header.dart';
import '../../../../utils/typedef.dart';
import '../../domain/entities/core_weather_time_location.dart';
import '../models/core_weather_model.dart';

abstract class WeatherRemoteDataSource {
  const WeatherRemoteDataSource();

  Future<CoreWeatherModel> getWeatherToday();
}

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final Dio _dio;
  final API _api;

  const WeatherRemoteDataSourceImpl({
    required Dio dio,
    required API api,
  }) : _dio = dio,
       _api = api;

  @override
  Future<CoreWeatherModel> getWeatherToday() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw const ServerException(
          message: 'Location services are disabled.',
          statusCode: 599,
        );
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw const ServerException(
            message: 'Location permissions are denied.',
            statusCode: 599,
          );
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw const ServerException(
          message:
              'Location permissions are permanently denied, cannot request.',
          statusCode: 599,
        );
      }

      final currentPosition = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      // current Address
      List<Placemark> placemarks = await placemarkFromCoordinates(
        currentPosition.latitude,
        currentPosition.longitude,
      );

      Placemark place = placemarks[0];

      final address = "${place.locality}, ${place.administrativeArea}";

      final currentTime = DateTime.now().toUtc().toIso8601String();
      final endTime = DateTime.now()
          .add(const Duration(days: 1))
          .toUtc()
          .toIso8601String();

      final request = await _dio.get(
        _api.weatherAPI.weather,
        options: APIHeaders.getHeaders(
          additionalHeaders: {
            'apikey': const String.fromEnvironment("WEATHER_API_KEY"),
          },
        ),
        queryParameters: {
          'location':
              '${currentPosition.latitude}, ${currentPosition.longitude}',
          'fields': 'temperature',
          'startTime': currentTime,
          'endTime': endTime,
          'timesteps': 'current',
          'units': 'metric',
          'timezone': 'UTC',
        },
      );

      final response = request.data['data']['timelines'] as List;

      final intervalResponse = response.first as DataMap;

      final resultResponse =
          (intervalResponse['intervals'] as List).first as DataMap;

      final result = CoreWeatherModel(
        temperature: resultResponse['values']['temperature'],
        timeLocation: CoreWeatherTimeLocation(
          districtName: address,
          latitude: currentPosition.latitude,
          longitude: currentPosition.longitude,
          time: DateTime.parse(currentTime).toLocal(),
        ),
      );

      debugPrint(result.toString());

      return result;
    } on DioException catch (e) {
      throw ServerException(
        message: e.message.toString(),
        statusCode: e.response?.statusCode ?? 599,
      );
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: 599);
    }
  }
}
