import 'package:dominos_score/domain/datasourse/local_game_data_source.dart';
import 'package:dominos_score/domain/models/game/game_model.dart';
import 'package:dominos_score/domain/models/game/team_model.dart';
import 'package:dominos_score/domain/models/game/round_model.dart';

import 'package:dominos_score/domain/repositories/game_repository.dart';

class GameRepositoryImpl implements GameRepository {
  final LocalGameDataSource localDataSource;

  GameRepositoryImpl({required this.localDataSource});

  // ===================== GAMES CRUD & FETCH =====================

  @override
  Future<List<GameModel>> fetchAllGames() async {
    return localDataSource.getGames();
  }

  @override
  Future<int> saveGame(GameModel game) async {
    // 1. Guardar localmente y obtener el ID
    final id = await localDataSource.createGame(game);
    // 2. (Opcional) Sincronizar a la nube.
    return id;
  }

  // ===================== TEAM CRUD =====================

  @override
  Future<int> insertTeam(int gameId, TeamModel team) async {
    return localDataSource.insertTeam(gameId, team);
  }

  @override
  Future<int> updateTeamName(int teamId, String newName) async {
    return localDataSource.updateTeamName(teamId, newName);
  }

  @override
  Future<GameModel> createGameWithDefaultTeams(GameModel game) async {
    final gameId = await localDataSource.createGame(game);

    game.id = gameId;

    if (game.teams.isNotEmpty) {
      print('Creando juego con ${game.teams.length} equipos existentes:');
      for (var team in game.teams) {
        print('  - Equipo: ${team.name}');
      }

      final List<TeamModel> teamsWithIds = [];

      for (var team in game.teams) {
        final teamWithGameId = TeamModel(
          gameId: gameId,
          name: team.name,
          player1: team.player1,
          player2: team.player2,
          totalScore: team.totalScore,
        );

        final teamId = await localDataSource.insertTeam(gameId, teamWithGameId);

        final finalTeam = TeamModel(
          id: teamId,
          gameId: gameId,
          name: team.name,
          player1: team.player1,
          player2: team.player2,
          totalScore: team.totalScore,
        );

        teamsWithIds.add(finalTeam);
      }

      game.teams = teamsWithIds;
    } else {
      final team1Template = TeamModel(
        gameId: gameId,
        name: "Team 1",
        totalScore: 0,
      );
      final team2Template = TeamModel(
        gameId: gameId,
        name: "Team 2",
        totalScore: 0,
      );

      final team1Id = await localDataSource.insertTeam(gameId, team1Template);
      final team2Id = await localDataSource.insertTeam(gameId, team2Template);

      final team1 = TeamModel(
        id: team1Id,
        gameId: gameId,
        name: "Team 1",
        totalScore: 0,
      );
      final team2 = TeamModel(
        id: team2Id,
        gameId: gameId,
        name: "Team 2",
        totalScore: 0,
      );

      game.teams = [team1, team2];
    }

    return game;
  }

  @override
  Future<int> saveTeam(int gameId, TeamModel team) async {
    final teamId = await localDataSource.insertTeam(gameId, team);
    return teamId;
  }

  // ===================== ROUNDS & SCORE CRUD =====================

  @override
  Future<int> saveRound(int gameId, RoundModel round) async {
    final roundId = await localDataSource.insertRound(gameId, round);
    return roundId;
  }

  @override
  Future<int> updateTeamScore(int teamId, int newTotalScore) async {
    return localDataSource.updateTotalScore(teamId, newTotalScore);
  }

  @override
  Future<void> deleteRound(int roundId) async {
    await localDataSource.deleteRound(roundId);
  }

  // ===================== GAME METADATA UPDATES =====================

  @override
  Future<void> updateGamePointsToWin(int gameId, int pointsToWin) async {
    await localDataSource.updatePointToWin(gameId, pointsToWin);
  }

  @override
  Future<void> updateGameActualRound(int gameId, int actualRound) async {
    await localDataSource.updateActualRound(gameId, actualRound);
  }
}
