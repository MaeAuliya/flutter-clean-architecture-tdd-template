import 'package:flutter/material.dart';

enum WeatherTemperature {
  cold,
  cool,
  pleasant,
  warm,
  hot,
}

class WeatherTemperatureEnums {
  static WeatherTemperature getFromCelsius(double temperature) {
    switch (temperature) {
      case <= 10:
        return WeatherTemperature.cold;
      case > 10 && <= 20:
        return WeatherTemperature.cool;
      case > 20 && <= 28:
        return WeatherTemperature.pleasant;
      case > 28 && <= 34:
        return WeatherTemperature.warm;
      case > 34:
        return WeatherTemperature.hot;
      default:
        return WeatherTemperature.pleasant;
    }
  }

  static IconData getIcon(WeatherTemperature weather) {
    switch (weather) {
      case WeatherTemperature.cold:
        return Icons.ac_unit;
      case WeatherTemperature.cool:
        return Icons.wb_cloudy;
      case WeatherTemperature.pleasant:
        return Icons.wb_sunny;
      case WeatherTemperature.warm:
        return Icons.wb_incandescent;
      case WeatherTemperature.hot:
        return Icons.local_fire_department;
    }
  }

  static String getText(WeatherTemperature weather) {
    switch (weather) {
      case WeatherTemperature.cold:
        return 'Cold';
      case WeatherTemperature.cool:
        return 'Cool';
      case WeatherTemperature.pleasant:
        return 'Pleasant';
      case WeatherTemperature.warm:
        return 'Warm';
      case WeatherTemperature.hot:
        return 'Hot';
    }
  }

  static Color getColor(WeatherTemperature weather) {
    switch (weather) {
      case WeatherTemperature.cold:
        return Colors.lightBlue;
      case WeatherTemperature.cool:
        return Colors.blueGrey;
      case WeatherTemperature.pleasant:
        return Colors.amber;
      case WeatherTemperature.warm:
        return Colors.orange;
      case WeatherTemperature.hot:
        return Colors.red;
    }
  }
}
