import 'package:flutter/material.dart';

import '../../../../core/enums/weather_temperature.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/res/colours.dart';
import '../../../../core/res/typography.dart';

class WeatherBadge extends StatelessWidget {
  final double temperature;
  final WeatherTemperature weatherTemperature;
  final String address;

  const WeatherBadge({
    super.key,
    required this.temperature,
    required this.weatherTemperature,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: context.widthScale * 12,
        horizontal: context.widthScale * 16,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colours.white,

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      margin: EdgeInsets.symmetric(horizontal: context.widthScale * 16),
      width: context.width - context.widthScale * 32,
      child: Row(
        spacing: context.widthScale * 16,
        children: [
          Container(
            padding: EdgeInsets.all(context.widthScale * 4),
            decoration: BoxDecoration(
              color: Colours.white,
              border: Border.all(
                color: WeatherTemperatureEnums.getColor(weatherTemperature),
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              WeatherTemperatureEnums.getIcon(weatherTemperature),
              color: WeatherTemperatureEnums.getColor(weatherTemperature),
              size: context.widthScale * 40,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: context.heightScale * 2,
              children: [
                CoreText(
                  '$temperature°C (${WeatherTemperatureEnums.getText(weatherTemperature)})',
                  size: 14,
                  weight: CoreTypography.semiBold,
                  color: WeatherTemperatureEnums.getColor(weatherTemperature),
                ),
                CoreText(
                  'Today in $address',
                  size: 13,
                  color: Colours.gray400,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
