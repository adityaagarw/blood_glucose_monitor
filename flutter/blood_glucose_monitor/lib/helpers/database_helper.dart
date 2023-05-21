import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import '../models/glucose_reading.dart';
import '../models/pp_reading.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._();

  static Database? _database;

  DatabaseHelper._();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'glucose_tracker.db');
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  void _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE glucose_readings(
        id TEXT PRIMARY KEY,
        date TEXT,
        hour TEXT,
        minute TEXT,
        type TEXT,
        glucoseLevel INTEGER,
        food TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE pp_readings(
        id TEXT PRIMARY KEY,
        date TEXT,
        hour TEXT,
        minute TEXT,
        glucoseLevel INTEGER,
        food TEXT
      )
    ''');
  }

  Future<int> insertReading(GlucoseReading reading) async {
    final db = await instance.database;
    return await db.insert('glucose_readings', reading.toMap());
  }

  Future<int> insertPPReading(PPReading reading) async {
    final db = await instance.database;
    return await db.insert('pp_readings', reading.toMap());
  }

  Future<List<GlucoseReading>> getAllReadings() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('glucose_readings');
    return List.generate(maps.length, (index) {
      return GlucoseReading.fromMap(maps[index]);
    });
  }

  Future<List<PPReading>> getAllPPReadings() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('pp_readings');
    return List.generate(maps.length, (index) {
      return PPReading.fromMap(maps[index]);
    });
  }

  Future<int> deleteReading(String id) async {
    final db = await instance.database;
    return await db.delete(
      'glucose_readings',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deletePPReading(String id) async {
    final db = await instance.database;
    return await db.delete(
      'pp_readings',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteReadingsByDateRange(
      DateTime startDate, DateTime endDate) async {
    final db = await instance.database;
    final start = startDate.toIso8601String();
    final end = endDate.toIso8601String();
    return await db.delete(
      'glucose_readings',
      where: 'date >= ? AND date <= ?',
      whereArgs: [start, end],
    );
  }

  Future<int> deletePPReadingsByDateRange(
      DateTime startDate, DateTime endDate) async {
    final db = await instance.database;
    final start = startDate.toIso8601String();
    final end = endDate.toIso8601String();
    return await db.delete(
      'pp_readings',
      where: 'date >= ? AND date <= ?',
      whereArgs: [start, end],
    );
  }
}
