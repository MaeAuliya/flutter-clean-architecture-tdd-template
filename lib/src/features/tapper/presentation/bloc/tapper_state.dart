part of 'tapper_bloc.dart';

abstract class TapperState extends Equatable {
  const TapperState();

  @override
  List<Object?> get props => [];
}

final class TapperInit extends TapperState {
  const TapperInit();
}

final class TapperLoading extends TapperState {
  const TapperLoading();
}

final class TapSuccess extends TapperState {
  final int currentCount;

  const TapSuccess(this.currentCount);

  @override
  List<Object?> get props => [currentCount];
}

final class TapLoading extends TapperState {
  const TapLoading();
}

final class TapError extends TapperState {
  final String errorMessage;

  const TapError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

final class LongPressSuccess extends TapperState {
  final int currentCount;

  const LongPressSuccess(this.currentCount);

  @override
  List<Object?> get props => [currentCount];
}

final class LongPressLoading extends TapperState {
  const LongPressLoading();
}

final class LongPressError extends TapperState {
  final String errorMessage;

  const LongPressError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

final class GetAllTapPerDaySuccess extends TapperState {
  final List<TapPerDay> tapList;

  const GetAllTapPerDaySuccess(this.tapList);

  @override
  List<Object?> get props => [tapList];
}

final class GetAllTapPerDayLoading extends TapperState {
  const GetAllTapPerDayLoading();
}

final class GetAllTapPerDayError extends TapperState {
  final String errorMessage;

  const GetAllTapPerDayError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

final class GetTodayTapPerDaySuccess extends TapperState {
  final TapPerDay todayTapPerDay;

  const GetTodayTapPerDaySuccess(this.todayTapPerDay);

  @override
  List<Object?> get props => [todayTapPerDay];
}

final class GetTodayTapPerDayEmpty extends TapperState {
  const GetTodayTapPerDayEmpty();
}

final class GetTodayTapPerDayLoading extends TapperState {
  const GetTodayTapPerDayLoading();
}

final class GetTodayTapPerDayError extends TapperState {
  final String errorMessage;

  const GetTodayTapPerDayError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

final class GoToRepositorySuccess extends TapperState {
  const GoToRepositorySuccess();
}

final class GoToRepositoryError extends TapperState {
  final String errorMessage;

  const GoToRepositoryError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

final class CounterTick extends TapperState {
  final int count;
  final bool isSync;

  const CounterTick(
    this.count, {
    this.isSync = false,
  });

  @override
  List<Object?> get props => [count, isSync];
}

final class CounterStopped extends TapperState {
  final int count;

  const CounterStopped(this.count);

  @override
  List<Object?> get props => [count];
}

final class GetTodayWeatherSuccess extends TapperState {
  final CoreWeather todayWeather;

  const GetTodayWeatherSuccess(this.todayWeather);

  @override
  List<Object?> get props => [todayWeather];
}

final class GetTodayWeatherLoading extends TapperState {
  const GetTodayWeatherLoading();
}

final class GetTodayWeatherError extends TapperState {
  final String errorMessage;

  const GetTodayWeatherError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
