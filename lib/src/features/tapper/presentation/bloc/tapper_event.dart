part of 'tapper_bloc.dart';

abstract class TapperEvent extends Equatable {
  const TapperEvent();

  @override
  List<Object?> get props => [];
}

final class TapEvent extends TapperEvent {
  const TapEvent();
}

final class LongPressStartEvent extends TapperEvent {
  final Duration interval;
  final int step;

  const LongPressStartEvent({
    this.interval = const Duration(milliseconds: 100),
    this.step = 1,
  });
}

final class LongPressEndEvent extends TapperEvent {
  const LongPressEndEvent();
}

final class GetAllTapPerDayEvent extends TapperEvent {
  const GetAllTapPerDayEvent();
}

final class GetTodayTapPerDayEvent extends TapperEvent {
  const GetTodayTapPerDayEvent();
}

final class GoToRepositoryEvent extends TapperEvent {
  const GoToRepositoryEvent();
}

final class GetTodayWeatherEvent extends TapperEvent {
  const GetTodayWeatherEvent();
}
