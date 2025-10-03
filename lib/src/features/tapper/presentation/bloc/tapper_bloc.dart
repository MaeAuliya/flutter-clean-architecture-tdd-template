import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/tap_per_day.dart';
import '../../domain/usecases/get_all_tap_per_day.dart';
import '../../domain/usecases/get_today_tap_per_day.dart';
import '../../domain/usecases/go_to_repository.dart';
import '../../domain/usecases/long_press.dart';
import '../../domain/usecases/tap.dart';

part 'tapper_event.dart';
part 'tapper_state.dart';

class TapperBloc extends Bloc<TapperEvent, TapperState> {
  final GetAllTapPerDay _getAllTapPerDay;
  final GetTodayTapPerDay _getTodayTapPerDay;
  final GoToRepository _goToRepository;
  final LongPress _longPress;
  final Tap _tap;

  TapperBloc({
    required GetAllTapPerDay getAllTapPerDay,
    required GetTodayTapPerDay getTodayTapPerDay,
    required GoToRepository goToRepository,
    required LongPress longPress,
    required Tap tap,
  }) : _getAllTapPerDay = getAllTapPerDay,
       _getTodayTapPerDay = getTodayTapPerDay,
       _goToRepository = goToRepository,
       _longPress = longPress,
       _tap = tap,
       super(const TapperInit()) {
    on<GetAllTapPerDayEvent>(_getAllTapPerDayHandler);
    on<GetTodayTapPerDayEvent>(_getTodayTapPerDayHandler);
    on<GoToRepositoryEvent>(_goToRepositoryHandler);
    on<LongPressStartEvent>(_longPressStartHandler);
    on<LongPressEndEvent>(_longPressEndHandler);
    on<TapEvent>(_tapHandler);
    on<_FlushTapTickEvent>(_flushTapTickHandler);
    on<_FlushLongPressTickEvent>(_flushLongPressTickHandler);
    on<_LongPressTickEvent>(_longPressTickHandler);
  }

  int _count = 0;
  int _pendingTapDelta = 0;

  int _pendingLpDelta = 0;
  bool _flushingTap = false;
  bool _flushingLp = false;
  Timer? _flushDebounce;
  Timer? _lpTimer;

  Future<void> _getAllTapPerDayHandler(
    GetAllTapPerDayEvent event,
    Emitter<TapperState> emit,
  ) async {
    emit(const GetAllTapPerDayLoading());
    await Future.delayed(const Duration(seconds: 1));
    final result = await _getAllTapPerDay.call();
    result.fold(
      (failure) => emit(GetAllTapPerDayError(failure.errorMessage)),
      (tapList) => emit(GetAllTapPerDaySuccess(tapList)),
    );
  }

  Future<void> _getTodayTapPerDayHandler(
    GetTodayTapPerDayEvent event,
    Emitter<TapperState> emit,
  ) async {
    emit(const GetTodayTapPerDayLoading());
    await Future.delayed(const Duration(seconds: 1));
    final result = await _getTodayTapPerDay.call();
    result.fold(
      (failure) => emit(GetTodayTapPerDayError(failure.errorMessage)),
      (tapPerDay) {
        _count = (tapPerDay?.tapCount ?? 0) + (tapPerDay?.longPressCount ?? 0);
        _pendingTapDelta = 0;
        _pendingLpDelta = 0;
        if (tapPerDay == null) {
          return emit(const GetTodayTapPerDayEmpty());
        } else {
          return emit(GetTodayTapPerDaySuccess(tapPerDay));
        }
      },
    );
  }

  Future<void> _goToRepositoryHandler(
    GoToRepositoryEvent event,
    Emitter<TapperState> emit,
  ) async {
    final result = await _goToRepository.call();
    result.fold(
      (failure) => emit(GoToRepositoryError(failure.errorMessage)),
      (_) => emit(const GoToRepositorySuccess()),
    );
  }

  Future<void> _longPressStartHandler(
    LongPressStartEvent event,
    Emitter<TapperState> emit,
  ) async {
    _lpTimer?.cancel();
    _lpTimer = Timer.periodic(event.interval, (_) async {
      add(_LongPressTickEvent(event.step));

      _flushDebounce?.cancel();
      _flushDebounce = Timer(const Duration(milliseconds: 150), () {
        add(const _FlushLongPressTickEvent());
      });
    });
  }

  Future<void> _longPressEndHandler(
    LongPressEndEvent event,
    Emitter<TapperState> emit,
  ) async {
    _lpTimer?.cancel();
    _flushDebounce?.cancel();
    add(const _FlushLongPressTickEvent());
    emit(CounterStopped(_count));
  }

  Future<void> _tapHandler(
    TapEvent event,
    Emitter<TapperState> emit,
  ) async {
    _count += 1;
    _pendingTapDelta += 1;

    emit(CounterTick(_count, isSync: _flushingTap || _pendingTapDelta > 0));

    _flushDebounce?.cancel();
    _flushDebounce = Timer(const Duration(milliseconds: 200), () {
      add(const _FlushTapTickEvent());
    });
  }

  Future<void> _flushTapTickHandler(
    _FlushTapTickEvent event,
    Emitter<TapperState> emit,
  ) async {
    if (_pendingTapDelta == 0 || _flushingTap) return;

    emit(const TapLoading());
    final delta = _pendingTapDelta;
    _pendingTapDelta = 0;
    _flushingTap = true;
    emit(CounterTick(_count, isSync: true));

    final result = await _tap.call(delta);
    result.fold(
      (failure) {
        _pendingTapDelta += delta;
        _count -= delta;
        _flushingTap = false;
        emit(LongPressError(failure.errorMessage));
      },
      (_) {
        _flushingTap = false;
        emit(LongPressSuccess(_count));
      },
    );
  }

  Future<void> _flushLongPressTickHandler(
    _FlushLongPressTickEvent event,
    Emitter<TapperState> emit,
  ) async {
    if (_pendingLpDelta == 0 || _flushingLp) return;

    emit(const TapLoading());
    final delta = _pendingLpDelta;
    _pendingLpDelta = 0;
    _flushingLp = true;
    emit(CounterTick(_count, isSync: true));

    final result = await _longPress.call(delta);
    result.fold(
      (failure) {
        _pendingLpDelta += delta;
        _count -= delta;
        _flushingLp = false;
        emit(LongPressError(failure.errorMessage));
      },
      (_) {
        _flushingLp = false;
        emit(LongPressSuccess(_count));
      },
    );
  }

  Future<void> _longPressTickHandler(
    _LongPressTickEvent event,
    Emitter<TapperState> emit,
  ) async {
    _count += event.step;
    _pendingLpDelta += event.step;

    emit(CounterTick(_count, isSync: _flushingLp || _pendingLpDelta > 0));

    _flushDebounce?.cancel();
    _flushDebounce = Timer(const Duration(milliseconds: 150), () {
      add(const _FlushLongPressTickEvent());
    });
  }

  @override
  Future<void> close() {
    _lpTimer?.cancel();
    _flushDebounce?.cancel();
    return super.close();
  }
}

class _FlushTapTickEvent extends TapperEvent {
  const _FlushTapTickEvent();
}

class _FlushLongPressTickEvent extends TapperEvent {
  const _FlushLongPressTickEvent();
}

class _LongPressTickEvent extends TapperEvent {
  final int step;

  const _LongPressTickEvent(this.step);

  @override
  List<Object?> get props => [step];
}
