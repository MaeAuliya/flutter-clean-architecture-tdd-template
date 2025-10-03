import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../core/errors/exception.dart';
import '../../../../core/services/local_database.dart';
import '../models/tap_per_day_model.dart';

abstract class TapperLocalDataSource {
  const TapperLocalDataSource();

  Future<void> tap(int steps);

  Future<void> longPress(int taps);

  Future<List<TapPerDayModel>> getAllTapPerDay();

  Future<TapPerDayModel?> getTodayTapPerDay();
}

class TapperLocalDataSourceImpl implements TapperLocalDataSource {
  final Database _db;

  const TapperLocalDataSourceImpl({required Database db}) : _db = db;

  @override
  Future<List<TapPerDayModel>> getAllTapPerDay() async {
    try {
      final result = await _db.query('tap_per_day', orderBy: 'date DESC');

      return result.map((e) => TapPerDayModel.fromLocalDatabase(e)).toList();
    } on LocalException {
      rethrow;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw (e.toString());
    }
  }

  @override
  Future<TapPerDayModel?> getTodayTapPerDay() async {
    try {
      final now = DateTime.now();
      final dateId = "${now.year}-${now.month}-${now.day}";

      final result = await _db.query(
        'tap_per_day',
        where: 'date_id = ?',
        whereArgs: [dateId],
        limit: 1,
      );

      if (result.isNotEmpty) {
        return TapPerDayModel.fromLocalDatabase(result.first);
      } else {
        return null;
      }
    } on LocalException {
      rethrow;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw (e.toString());
    }
  }

  @override
  Future<void> longPress(int taps) async {
    try {
      final now = DateTime.now();
      final dateId = "${now.year}-${now.month}-${now.day}";

      final result = await _db.query(
        LocalDatabase.tapPerDayTable,
        where: 'date_id = ?',
        whereArgs: [dateId],
        limit: 1,
      );

      if (result.isEmpty) {
        await _db.insert(LocalDatabase.tapPerDayTable, {
          'date_id': dateId,
          'tap_count': 0,
          'long_press_count': taps,
          'date': now.millisecondsSinceEpoch,
        });
      } else {
        final current = result.first;
        final currentLongPress = current['long_press_count'] as int;

        await _db.update(
          LocalDatabase.tapPerDayTable,
          {'long_press_count': currentLongPress + taps},
          where: 'date_id = ?',
          whereArgs: [dateId],
        );
      }
    } on LocalException {
      rethrow;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw (e.toString());
    }
  }

  @override
  Future<void> tap(int steps) async {
    try {
      final now = DateTime.now();
      final dateId = "${now.year}-${now.month}-${now.day}";

      final result = await _db.query(
        LocalDatabase.tapPerDayTable,
        where: 'date_id = ?',
        whereArgs: [dateId],
        limit: 1,
      );

      if (result.isEmpty) {
        await _db.insert(LocalDatabase.tapPerDayTable, {
          'date_id': dateId,
          'tap_count': steps,
          'long_press_count': 0,
          'date': now.millisecondsSinceEpoch,
        });
      } else {
        final current = result.first;
        final currentTap = current['tap_count'] as int;

        await _db.update(
          LocalDatabase.tapPerDayTable,
          {'tap_count': currentTap + steps},
          where: 'date_id = ?',
          whereArgs: [dateId],
        );
      }
    } on LocalException {
      rethrow;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw (e.toString());
    }
  }
}
