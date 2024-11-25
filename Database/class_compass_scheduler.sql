import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'schedule.db');
    return openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          '''CREATE TABLE schedule(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            instructor TEXT,
            startTime TEXT,
            endTime TEXT,
            day INTEGER,
            color TEXT)''',
        );
      },
      version: 1,
    );
  }

  Future<void> insertSchedule(Map<String, dynamic> schedule) async {
    final db = await database;
    await db.insert(
      'schedule',
      schedule,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getSchedules() async {
    final db = await database;
    return await db.query('schedule');
  }

  Future<void> deleteSchedule(int id) async {
    final db = await database;
    await db.delete(
      'schedule',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateSchedule(Map<String, dynamic> schedule) async {
    final db = await database;
    await db.update(
      'schedule',
      schedule,
      where: 'id = ?',
      whereArgs: [schedule['id']],
    );
  }
}
