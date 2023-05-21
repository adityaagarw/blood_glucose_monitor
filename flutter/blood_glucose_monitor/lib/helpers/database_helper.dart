import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../models/glucose_reading.dart';
import '../../models/pp_reading.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'glucose_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE glucose_readings (
            id INTEGER PRIMARY KEY,
            date TEXT,
            time TEXT,
            type TEXT,
            glucose_level INTEGER
          )
        ''');
        await db.execute('''
          CREATE TABLE pp_readings (
            id INTEGER PRIMARY KEY,
            reading_id INTEGER,
            food TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertReading(GlucoseReading reading) async {
    final db = await database;
    final id = await db.insert('glucose_readings', reading.toMap());
    if (reading.type == 'PP' && reading.food != null) {
      final ppReading = PPReading(
        id: null,
        readingId: id,
        food: reading.food,
      );
      await db.insert('pp_readings', ppReading.toMap());
    }
  }

  Future<List<GlucoseReading>> getReadings() async {
    final db = await database;
    final readingsData = await db.query('glucose_readings');
    final readings = <GlucoseReading>[];
    for (final readingData in readingsData) {
      final ppReadingData = await db.query(
        'pp_readings',
        where: 'reading_id = ?',
        whereArgs: [readingData['id']],
        limit: 1,
      );
      final ppReading = ppReadingData.isNotEmpty
          ? PPReading.fromMap(ppReadingData.first)
          : null;
      readings.add(GlucoseReading.fromMap(readingData, ppReading?.food));
    }
    return readings;
  }

  Future<void> deleteReading(int id) async {
    final db = await database;
    await db.delete('pp_readings', where: 'reading_id = ?', whereArgs: [id]);
    await db.delete('glucose_readings', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteReadingsByDateRange(
      DateTime startDate, DateTime endDate) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete(
        'pp_readings',
        where:
            'reading_id IN (SELECT id FROM glucose_readings WHERE date BETWEEN ? AND ?)',
        whereArgs: [startDate.toIso8601String(), endDate.toIso8601String()],
      );
      await txn.delete(
        'glucose_readings',
        where: 'date BETWEEN ? AND ?',
        whereArgs: [startDate.toIso8601String(), endDate.toIso8601String()],
      );
    });
  }
}
