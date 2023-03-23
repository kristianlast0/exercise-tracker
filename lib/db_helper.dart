import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'exercises.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE exercises (
            id INTEGER PRIMARY KEY,
            exercise TEXT,
            weight REAL,
            target_reps INTEGER,
            bpm INTEGER,
            duration INTEGER,
            actual_reps INTEGER
          )
        ''');
      },
    );
  }

  Future<Map<String, dynamic>?> fetchLastExerciseByName(String exerciseName, int currentId) async {
    final db = await database;
    final result = await db.query(
      'exercises',
      where: 'exercise = ? AND id < ?',
      whereArgs: [exerciseName, currentId],
      orderBy: 'id DESC',
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<List<Map<String, dynamic>>> fetchAllExercises() async {
    final db = await database;
    return await db.query('exercises', orderBy: 'id DESC',);
  }

  Future<int> insertData(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert('exercises', data);
  }

  Future<void> truncateExercises() async {
    final db = await database;
    await db.delete('exercises');
  }

}