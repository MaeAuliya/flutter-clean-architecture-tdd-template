import '../../../../core/utils/typedef.dart';
import '../entities/tap_per_day.dart';

abstract class TapperRepository {
  const TapperRepository();

  ResultVoid tap();

  ResultVoid longPress(int taps);

  ResultFuture<List<TapPerDay>> getAllTapPerDay();

  ResultFuture<TapPerDay> getTodayTapPerDay();
}
