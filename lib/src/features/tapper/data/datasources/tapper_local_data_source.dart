import 'package:sqflite/sqflite.dart';

import '../models/tap_per_day_model.dart';

abstract class TapperLocalDataSource {
  const TapperLocalDataSource();

  Future<void> tap();

  Future<void> longPress(int taps);

  Future<List<TapPerDayModel>> getAllTapPerDay();

  Future<TapPerDayModel> getTodayTapPerDay();
}

class TapperLocalDataSourceImpl implements TapperLocalDataSource {
  final Database _database;

  const TapperLocalDataSourceImpl({required Database database})
    : _database = database;

  @override
  Future<List<TapPerDayModel>> getAllTapPerDay() async {
    // TODO: implement getAllTapPerDay
    throw UnimplementedError();
  }

  @override
  Future<TapPerDayModel> getTodayTapPerDay() async {
    // TODO: implement getTodayTapPerDay
    throw UnimplementedError();
  }

  @override
  Future<void> longPress(int taps) async {
    // TODO: implement longPress
    throw UnimplementedError();
  }

  @override
  Future<void> tap() async {
    // TODO: implement tap
    throw UnimplementedError();
  }
}
