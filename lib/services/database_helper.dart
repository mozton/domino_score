import 'dart:io';

import 'package:dominos_score/model/game_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();
  // deleteDatabase();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'DominoScoreDB.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
      onConfigure: (db) async {
        // Activar claves foráneas
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  Future<void> _createTables(Database db, int version) async {
    await db.execute('''
     CREATE TABLE games(
      id INTEGER PRIMARY KEY AUTOINCREMENT
        )
''');

    await db.execute('''
      CREATE TABLE teams(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        totalPoints INTEGER NOT NULL
        )
''');

    await db.execute('''
      CREATE TABLE rounds(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        round INTEGER NOT NULL,
        pointTeam1 INTEGER NOT NULL,
        pointTeam2 INTEGER NOT NULL

)''');
  }

  Future<void> getGames() async {
    final db = await database;

    final games = await db.query('rounds');
  }

  Future<void> deleteDatabaseFile() async {
    final dbPath = await getDatabasesPath();
    final path = '$dbPath/DominoScoreDB.db';

    if (await File(path).exists()) {
      await deleteDatabase(path);
      print('Base de datos eliminada');
    } else {
      print('No existe la base de datos');
    }
  }
}
