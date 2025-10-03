import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabase {
  static String get tapPerDayTable => 'tap_per_day';

  static Future<Database> initLocalDatabase() async {
    final database = await openDatabase(
      join(await getDatabasesPath(), 'local_database.db'),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tapPerDayTable (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date_id TEXT NOT NULL,
            tap_count INTEGER NOT NULL,
            long_press_count INTEGER NOT NULL,
            date INTEGER NOT NULL
          )
          ''');
      },
      version: 1,
    );

    return database;
  }
}
