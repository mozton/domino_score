import 'dart:convert';

import 'package:dominos_score/features/games/data/database/app_database.dart';
import 'package:dominos_score/features/games/data/database/database_manager.dart';
import 'package:dominos_score/features/games/data/datasources/game_data_source.dart';
import 'package:dominos_score/features/games/domain/entities/game_entity.dart';
import 'package:dominos_score/features/games/domain/entities/round_action.dart';
import 'package:dominos_score/features/games/domain/entities/round_entity.dart';
import 'package:dominos_score/features/games/domain/entities/team_entity.dart';
import 'package:drift/drift.dart';

/// Implementación Drift (local) del origen de datos de games.
///
/// Todas las operaciones comprueban que la base siga abierta: al cerrar sesión
/// la base se cierra y cualquier consulta que llegue tarde (por ejemplo, la
/// pantalla anterior terminando de cargar) devuelve un resultado vacío en vez
/// de reventar con `Channel was closed before receiving a response`.
class DriftGameDataSource implements GameDataSource {
  final DatabaseManager _databaseManager;

  DriftGameDataSource(this._databaseManager);

  AppDatabase get _db => _databaseManager.database;

  bool get _isOpen => _databaseManager.isOpen;

  /// Ejecuta [action] solo si la base está abierta; si no, devuelve [fallback].
  Future<T> _guard<T>(T fallback, Future<T> Function() action) async {
    if (!_isOpen) return fallback;
    try {
      return await action();
    } catch (error) {
      // La base se cerró mientras se consultaba (cierre de sesión, cambio de
      // usuario...): se devuelve un resultado vacío en lugar del error crudo.
      if (isDatabaseClosedError(error)) return fallback;
      rethrow;
    }
  }

  /// Igual que [_guard] pero para operaciones que no devuelven nada.
  Future<void> _guardVoid(Future<void> Function() action) async {
    if (!_isOpen) return;
    try {
      await action();
    } catch (error) {
      if (isDatabaseClosedError(error)) return;
      rethrow;
    }
  }

  @override
  Future<int> createGame(Game game) {
    return _guard(0, () async {
      return _db.into(_db.games).insert(
        GamesCompanion.insert(
          actualRound: game.actualRound,
          pointsToWin: game.pointsToWin,
          createdAt: game.createdAt,
          winnerTeamName: Value(game.winnerTeamName),
          myTeamIndex: Value(game.myTeamIndex),
        ),
      );
    });
  }

  @override
  Future<void> updatePointsToWin(int gameId, int pointsToWin) {
    return _guardVoid(() async {
      await (_db.update(_db.games)..where((t) => t.id.equals(gameId))).write(
        GamesCompanion(pointsToWin: Value(pointsToWin)),
      );
    });
  }

  @override
  Future<void> updateActualRound(int gameId, int actualRound) {
    return _guardVoid(() async {
      await (_db.update(_db.games)..where((t) => t.id.equals(gameId))).write(
        GamesCompanion(actualRound: Value(actualRound)),
      );
    });
  }

  @override
  Future<void> updateMyTeamIndex(int gameId, int? teamIndex) {
    return _guardVoid(() async {
      await (_db.update(_db.games)..where((t) => t.id.equals(gameId))).write(
        GamesCompanion(myTeamIndex: Value(teamIndex)),
      );
    });
  }

  /// Las partidas locales no se comparten, así que no guardan código en vivo.
  @override
  Future<void> updateLiveCode(int gameId, String liveCode) async {}

  @override
  Future<int> insertTeam(int gameId, Team team) {
    return _guard(0, () async {
      return _db.into(_db.teams).insert(
        TeamsCompanion.insert(
          gameId: gameId,
          name: team.name,
          player1: Value(team.player1),
          player2: Value(team.player2),
          totalScore: team.totalScore,
        ),
      );
    });
  }

  @override
  Future<void> updateTeamName(int teamId, String newName) {
    return _guardVoid(() async {
      await (_db.update(_db.teams)..where((t) => t.id.equals(teamId))).write(
        TeamsCompanion(name: Value(newName)),
      );
    });
  }

  @override
  Future<void> updateTeamScore(int teamId, int newTotalScore) {
    return _guardVoid(() async {
      await (_db.update(_db.teams)..where((t) => t.id.equals(teamId))).write(
        TeamsCompanion(totalScore: Value(newTotalScore)),
      );
    });
  }

  @override
  Future<int> insertRound(int gameId, Round round) {
    return _guard(0, () async {
      return _db.into(_db.rounds).insert(
        RoundsCompanion.insert(
          gameId: gameId,
          number: round.number,
          team1Points: round.team1Points,
          team2Points: round.team2Points,
          team3Points: Value(round.team3Points),
          team4Points: Value(round.team4Points),
          eventsJson: Value(_encodeEvents(round.events)),
        ),
      );
    });
  }

  @override
  Future<void> deleteRound(int roundId) {
    return _guardVoid(() async {
      await (_db.delete(_db.rounds)..where((t) => t.id.equals(roundId))).go();
    });
  }

  @override
  Future<List<Game>> getGames() {
    return _guard(const <Game>[], () async {
      final rows = await _db.select(_db.games).get();
      final games = <Game>[];
      for (final row in rows) {
        final game = await _loadGame(row.id);
        if (game != null) {
          games.add(game);
        }
      }
      return games;
    });
  }

  @override
  Future<Game?> getGameById(int gameId) {
    return _guard(null, () => _loadGame(gameId));
  }

  Future<Game?> _loadGame(int gameId) async {
    if (!_isOpen) return null;

    final gameRow = await (_db.select(_db.games)
          ..where((t) => t.id.equals(gameId)))
        .getSingleOrNull();
    if (gameRow == null) return null;

    final teamRows = await (_db.select(_db.teams)
          ..where((t) => t.gameId.equals(gameId))
          ..orderBy([(t) => OrderingTerm.asc(t.id)]))
        .get();

    final roundRows = await (_db.select(_db.rounds)
          ..where((t) => t.gameId.equals(gameId))
          ..orderBy([(t) => OrderingTerm.asc(t.id)]))
        .get();

    return Game(
      id: gameRow.id,
      actualRound: gameRow.actualRound,
      pointsToWin: gameRow.pointsToWin,
      createdAt: gameRow.createdAt,
      winnerTeamName: gameRow.winnerTeamName,
      myTeamIndex: gameRow.myTeamIndex,
      teams: teamRows.map(_teamFromRow).toList(),
      rounds: roundRows.map(_roundFromRow).toList(),
    );
  }

  Team _teamFromRow(TeamRow row) {
    return Team(
      id: row.id,
      gameId: row.gameId,
      name: row.name,
      player1: row.player1,
      player2: row.player2,
      totalScore: row.totalScore,
    );
  }

  Round _roundFromRow(RoundRow row) {
    return Round(
      id: row.id,
      gameId: row.gameId,
      number: row.number,
      team1Points: row.team1Points,
      team2Points: row.team2Points,
      team3Points: row.team3Points,
      team4Points: row.team4Points,
      events: _decodeEvents(row.eventsJson),
    );
  }

  String? _encodeEvents(List<RoundEvent> events) {
    if (events.isEmpty) return null;
    return jsonEncode(events.map((event) => event.toMap()).toList());
  }

  List<RoundEvent> _decodeEvents(String? json) {
    if (json == null || json.isEmpty) return const [];
    try {
      final list = jsonDecode(json) as List;
      return list
          .map(
            (item) =>
                RoundEvent.fromMap(Map<String, dynamic>.from(item as Map)),
          )
          .toList();
    } catch (_) {
      return const [];
    }
  }
}
