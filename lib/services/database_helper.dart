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
     CREATE TABLE games(
      id INTEGER PRIMARY KEY AUTOINCREMENT
      actualRound INTEGER,
      pointsToWin INTEGER,
      createAt TEXT,
      winnerTeamName TEXT

        )
''');

    await db.execute('''
      CREATE TABLE teams(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        gameId INTEGER NOT NULL,
        name TEXT NOT NULL,
        totalPoints INTEGER NOT NULL,
        FOREIGN KEY (gameId) REFERENCES games(id) ON DELETE CASCADE
        )
''');

    await db.execute('''
      CREATE TABLE rounds(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        gameId INTEGER NOT NULL,
        round INTEGER NOT NULL,
        pointTeam1 INTEGER NOT NULL,
        pointTeam2 INTEGER NOT NULL,
        pointTeam3 INTEGER,
        pointTeam4 INTEGER,
        FOREIGN KEY (gameId) REFERENCES games(id) ON DELETE CASCADE

)''');
  }

  Future<int> createGame(GameModel game) async {
    final db = await database;
    // await db.insert('games', {'id': 2});

    //INSERT GAME
    final gameId = await db.insert('games', {
      'actualRoun': game.actualRound,
      'pointsToWin': game.pointsToWin,
      'createAt': game.createdAt,
      'winnerTeamName': game.winnerTeamName,
    });

    // INSERT TEAMS
    await db.insert('teams', {
      'gameId': gameId,
      'name': game.team1.name,
      'totalPoints': game.team1.totalPoints ?? 0,
    });

    await db.insert('teams', {
      'gameId': gameId,
      'name': game.team2.name,
      'totalPoints': game.team2.totalPoints ?? 0,
    });

    if (game.team3 != null) {
      await db.insert('teams', {
        'gameId': gameId,
        'name': game.team3!.name,
        'totalPoints': game.team3!.totalPoints ?? 0,
      });
    }
    if (game.team4 != null) {
      await db.insert('teams', {
        'gameId': gameId,
        'name': game.team3!.name,
        'totalPoints': game.team3!.totalPoints ?? 0,
      });
    }

    // INSERT ROUNDS

    for (var r in game.rounds) {
      await db.insert('rounds', {
        'gameId': gameId,
        'round': r.round,
        'pointTeam1': r.pointTeam1,
        'pointTeam2': r.pointTeam2,
        'pointTeam3': r.pointTeam3,
        'pointTeam4': r.pointTeam4,
      });
    }
    return gameId;
  }

  Future<List<GameModel>> getGames() async {
    final db = await database;

    final gameRows = await db.query('games');
    List<GameModel> games = [];

    for (var g in gameRows) {
      final gameId = g['id'] as int;

      // TEAMS
      final teamRows = await db.query(
        'teams',
        where: 'gameId = ?',
        whereArgs: [gameId],
      );

      final team1 = Team.fromMap(teamRows[0]);
      final team2 = Team.fromMap(teamRows[1]);
      Team? team3;
      Team? team4;
      if (teamRows.length > 2) team3 = Team.fromMap(teamRows[2]);
      if (teamRows.length > 3) team4 = Team.fromMap(teamRows[3]);

      // ROUNDS

      final roundRows = await db.query(
        'rounds',
        where: 'gameId = ?',
        whereArgs: [gameId],
      );
      final rounds = roundRows.map((r) => Round.fromMap(r)).toList();

      games.add(
        GameModel(
          id: gameId,
          rounds: rounds,
          actualRound: g['actualRound'] as int,
          pointsToWin: g['pointsToWin'] as int,
          createdAt: g['createAt'] != null
              ? DateTime.parse(g['createAt'].toString())
              : null,
          winnerTeamName: g['winnerTeamName'] as String,
          team1: team1,
          team2: team2,
          team3: team3,
          team4: team4,
        ),
      );
    }
    return games;
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
