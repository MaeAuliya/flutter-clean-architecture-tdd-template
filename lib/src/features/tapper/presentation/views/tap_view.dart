import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../core/enums/weather_temperature.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/res/colours.dart';
import '../../../../core/res/typography.dart';
import '../../data/models/tap_per_day_model.dart';
import '../../domain/entities/tap_per_day.dart';
import '../bloc/tapper_bloc.dart';
import '../providers/tapper_provider.dart';
import '../providers/weather_provider.dart';
import '../widgets/tap_button.dart';
import '../widgets/weather_badge.dart';

class TapView extends StatelessWidget {
  const TapView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colours.gray200,
        body: Consumer<TapperProvider>(
          builder: (_, provider, __) {
            TapPerDay tapPerDay = provider.todayTap ?? TapPerDayModel.empty();
            return Stack(
              children: [
                Positioned.fill(
                  child: BlocBuilder<TapperBloc, TapperState>(
                    buildWhen: (prev, curr) =>
                        curr is CounterTick ||
                        curr is GetTodayTapPerDaySuccess ||
                        curr is GetTodayTapPerDayEmpty ||
                        curr is GetTodayTapPerDayLoading,
                    builder: (context, state) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: context.heightScale * 16,
                        children: [
                          const CoreText(
                            'Your Current Tap Today',
                            size: 16,
                            weight: CoreTypography.medium,
                            color: Colours.black,
                          ),
                          CoreText(
                            '${(state is CounterTick) ? state.count : (tapPerDay.tapCount + tapPerDay.longPressCount)}',
                            size: 32,
                            weight: CoreTypography.bold,
                            color: Colours.primaryBlue,
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Positioned(
                  top: context.heightScale * 24 + context.topSafe,
                  child: Consumer<WeatherProvider>(
                    builder: (_, weatherProvider, __) {
                      if (weatherProvider.weather == null) {
                        return Container();
                      } else {
                        return WeatherBadge(
                          temperature: weatherProvider.weather!.temperature,
                          weatherTemperature:
                              WeatherTemperatureEnums.getFromCelsius(
                                weatherProvider.weather!.temperature,
                              ),
                          address: weatherProvider
                              .weather!
                              .timeLocation
                              .districtName,
                        );
                      }
                    },
                  ),
                ),
                Positioned(
                  bottom: context.heightScale * 24,
                  right: context.widthScale * 16,
                  child: TapButton(
                    onTap: () {
                      context.tapperBloc.add(const TapEvent());
                    },
                    onLongPressEnd: () {
                      context.tapperBloc.add(const LongPressEndEvent());
                    },
                    onLongPressStart: () {
                      context.tapperBloc.add(const LongPressStartEvent());
                    },
                    iconData: CupertinoIcons.plus,
                    text: 'Tap or Long Press',
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
