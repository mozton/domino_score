import 'package:dominos_score/models/models.dart';
import 'package:dominos_score/models/game/team_model.dart';
import 'package:dominos_score/models/game/round_model.dart';
import 'package:dominos_score/services/local/local_game_data_source.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper implements LocalGameDataSource {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

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

  Future<void> deleteDB() async {
    // Obtener la ruta donde SQLite guarda las bases de datos
    final dbPath = await getDatabasesPath();
    final path = join(
      dbPath,
      'DominoScoreDB.db',
    ); // <-- Cambia 'games.db' al nombre real

    // Borrar el archivo completo de la base de datos
    await deleteDatabase(path);
    print('Base de Datos Borrada');
  }

  Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE games (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        actualRound INTEGER NOT NULL,
        pointsToWin INTEGER NOT NULL,
        createdAt TEXT NOT NULL,
        winnerTeamName TEXT
        )
''');

    await db.execute('''
      CREATE TABLE teams (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        gameId INTEGER,
        name TEXT NOT NULL,
        player1 TEXT,
        player2 TEXT,
        totalScore INTEGER,
        FOREIGN KEY (gameId) REFERENCES games(id) ON DELETE CASCADE
        )
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
        )

''');
  }

  @override
  Future<int> createGame(GameModel game) async {
    final db = await database;

    final gameId = await db.insert('games', {
      'pointsToWin': game.pointsToWin,
      'actualRound': game.actualRound,
      'createdAt': game.createdAt.toIso8601String(),
      'winnerTeamName': game.winnerTeamName,
    });
    print('Se creo juego #$gameId');
    return gameId;
  }

  Future<int> updatePointToWin(int gameId, int newScore) async {
    final db = await database;

    return await db.update(
      'games',
      {'pointsToWin': newScore},
      where: 'id = ?',
      whereArgs: [gameId],
    );
  }
  // ========================== // TEAMS // ========================== //

  //  Add Teams

  Future<int> insertTeam(int gameId, TeamModel team) async {
    final db = await database;

    final Map<String, dynamic> teamData = {
      'gameId': gameId,
      'name': team.name,
      'player1': team.player1,
      'player2': team.player2,
      'totalScore': team.totalScore,
    };

    // Solo incluir el id si no es null (para actualizaciones)
    if (team.id != null) {
      teamData['id'] = team.id;
    }

    return await db.insert(
      'teams',
      teamData,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Update teamName

  Future<int> updateTeamName(int teamId, String newName) async {
    final db = await database;

    return await db.update(
      'teams',
      {'name': newName},
      where: 'id = ?',
      whereArgs: [teamId],
    );
  }

  // Update totalScore

  Future<int> updateTotalScoreTeam(int teamId, int newTotal) async {
    final db = await database;

    return await db.update(
      'teams',
      {'totalScore': newTotal},
      where: 'id = ?',
      whereArgs: [teamId],
    );
  }

  // Get team by Id

  Future<TeamModel?> getTeamById(int teamId) async {
    final db = await database;

    final result = await db.query(
      'teams',
      where: 'id = ?',
      whereArgs: [teamId],
      limit: 1,
    );

    if (result.isNotEmpty) {
      final t = result.first;

      return TeamModel(
        id: t['id'] as int,
        gameId: t['gameId'] as int?,
        name: t['name'] as String,
        totalScore: t['totalScore'] as int,
      );
    }

    return null; // No existe ese team
  }

  // ========================== // ROUNDS // ========================== //

  // Add rounds

  Future<int> insertRound(int gameId, RoundModel round) async {
    final db = await database;

    return await db.insert('rounds', {
      'gameId': gameId,
      'number': round.number,
      'team1Points': round.team1Points,
      'team2Points': round.team2Points,
      'team3Points': round.team3Points,
      'team4Points': round.team4Points,
    });
  }

  Future<int> updateTotalScore(int teamId, int newTotalScore) async {
    final db = await database;
    return await db.update(
      'teams',
      {'totalScore': newTotalScore},
      where: 'id = ?',
      whereArgs: [teamId],
    );
  }

  // Update actualRound

  Future<int> updateActualRound(int gameId, int actualRound) async {
    final db = await database;

    return await db.update(
      'games',
      {'actualRound': actualRound},
      where: 'id = ?',
      whereArgs: [gameId],
    );
  }

  // Delete round by id

  Future<int> deleteRound(int id) async {
    final db = await database;

    return await db.delete('rounds', where: 'id = ?', whereArgs: [id]);
  }

  // --------------------------------------------------\--

  Future<List<GameModel>> getGames() async {
    final db = await database;

    // 1. Obtener todos los juegos
    final gameMaps = await db.query('games');

    List<GameModel> games = [];

    for (var gameMap in gameMaps) {
      final gameId = gameMap['id'] as int;

      // 2. Obtener los teams del juego
      final teamMaps = await db.query(
        'teams',
        where: 'gameId = ?',
        whereArgs: [gameId],
      );

      List<TeamModel> teams = teamMaps.map((t) {
        return TeamModel(
          id: t['id'] as int,
          gameId: t['gameId'] as int,
          name: t['name'] as String,
          totalScore: t['totalScore'] as int,
        );
      }).toList();

      // 3. Obtener las rondas del juego
      final roundMaps = await db.query(
        'rounds',
        where: 'gameId = ?',
        whereArgs: [gameId],
      );

      List<RoundModel> rounds = roundMaps.map((r) {
        return RoundModel(
          id: r['id'] as int,
          number: r['number'] as int,
          team1Points: r['team1Points'] as int,
          team2Points: r['team2Points'] as int,
          team3Points: r['team3Points'] as int?,
          team4Points: r['team4Points'] as int?,
        );
      }).toList();

      // 4. Construir GameModel usando las listas
      final game = GameModel.fromMap(gameMap, teams: teams, rounds: rounds);

      games.add(game);
    }

    return games;
  }
}
