import 'dart:io';

import 'package:dominos_score/model/game_model.dart';
import 'package:dominos_score/model/models.dart';
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
      CREATE TABLE games (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        actualRound INTEGER NOT NULL,
        pointsToWin INTEGER NOT NULL,
        createdAt TEXT NOT NULL,
        winnerTeamName TEXT
              );
''');

    await db.execute('''
      CREATE TABLE teams (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        gameId INTEGER NOT NULL,
        name TEXT NOT NULL,
        FOREIGN KEY (gameId) REFERENCES games(id) ON DELETE CASCADE
        );
''');

    await db.execute('''
      CREATE TABLE rounds (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        gameId INTEGER NOT NULL,
        number INTEGER NOT NULL,
        team1Points INTEGER NOT NULL,
        team2Points INTEGER NOT NULL,
        team3Points INTEGER,
        team4Points INTEGER,
        FOREIGN KEY (gameId) REFERENCES games(id) ON DELETE CASCADE
        );

''');
  }
}
