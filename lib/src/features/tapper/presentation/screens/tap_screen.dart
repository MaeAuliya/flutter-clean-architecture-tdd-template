import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/context_extension.dart';
import '../../../../core/utils/core_utils.dart';
import '../bloc/tapper_bloc.dart';
import '../views/tap_view.dart';

class TapScreen extends StatefulWidget {
  const TapScreen({super.key});

  @override
  State<TapScreen> createState() => _TapScreenState();
}

class _TapScreenState extends State<TapScreen> {
  @override
  void initState() {
    context.tapperBloc.add(const GetTodayTapPerDayEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TapperBloc, TapperState>(
      listener: (context, state) {
        if (state is GetTodayTapPerDayError) {
          CoreUtils.showSnackBar(
            context: context,
            message: state.errorMessage,
            isError: true,
          );
        } else if (state is TapError) {
          CoreUtils.showSnackBar(
            context: context,
            message: state.errorMessage,
            isError: true,
          );
        } else if (state is LongPressError) {
          CoreUtils.showSnackBar(
            context: context,
            message: state.errorMessage,
            isError: true,
          );
        } else if (state is GetTodayWeatherError) {
          CoreUtils.showSnackBar(
            context: context,
            message: state.errorMessage,
            isError: true,
          );
        } else if (state is GetTodayTapPerDaySuccess) {
          context.tapperProvider.updateTodayTap(state.todayTapPerDay);
          context.tapperBloc.add(const GetTodayWeatherEvent());
        } else if (state is GetTodayTapPerDayEmpty) {
          context.tapperProvider.updateTodayTap(null);
        } else if (state is TapSuccess) {
          context.tapperProvider.updateSuccessTap(state.currentCount);
        } else if (state is LongPressSuccess) {
          context.tapperProvider.updateSuccessTap(state.currentCount);
        } else if (state is GetTodayWeatherSuccess) {
          context.weatherProvider.updateWeather(state.todayWeather);
        }
      },
      child: const TapView(),
    );
  }
}
