import 'package:dominos_score/models/game/game_model.dart';
import 'package:dominos_score/models/game/team_model.dart';
import 'package:dominos_score/models/game/round_model.dart';
import 'package:dominos_score/services/local/local_game_data_source.dart';
// import 'package:dominos_score/services/cloud/cloud_game_data_source.dart'; // Para el futuro sync

class GameRepository {
  final LocalGameDataSource localDataSource;
  // final CloudGameDataSource cloudDataSource; // Inyectar la fuente de la nube cuando se implemente

  GameRepository({
    required this.localDataSource,
    required cloudDataSource,
    // required this.cloudDataSource,
  });

  // ===================== GAMES CRUD & FETCH =====================

  Future<List<GameModel>> fetchAllGames() async {
    return localDataSource.getGames();
  }

  Future<int> saveGame(GameModel game) async {
    // 1. Guardar localmente y obtener el ID
    final id = await localDataSource.createGame(game);
    // 2. (Opcional) Sincronizar a la nube.
    return id;
  }

  // ===================== TEAM CRUD =====================
  Future<int> insertTeam(int gameId, TeamModel team) async {
    return localDataSource.insertTeam(gameId, team);
  }

  Future<int> updateTeamName(int teamId, String newName) async {
    return localDataSource.updateTeamName(teamId, newName);
  }

  Future<GameModel> createGameWithDefaultTeams(GameModel game) async {
    // 1. Insertar el juego y obtener el ID de la DB
    final gameId = await localDataSource.createGame(game);

    game.id = gameId;

    // 2. Si el juego ya tiene equipos definidos, usarlos. Si no, crear equipos por defecto
    if (game.teams.isNotEmpty) {
      print('📦 Creando juego con ${game.teams.length} equipos existentes:');
      for (var team in game.teams) {
        print('  - Equipo: ${team.name}');
      }

      // Usar los equipos que vienen en el game
      final List<TeamModel> teamsWithIds = [];

      for (var team in game.teams) {
        // Actualizar el gameId del equipo
        final teamWithGameId = TeamModel(
          gameId: gameId,
          name: team.name,
          player1: team.player1,
          player2: team.player2,
          totalScore: team.totalScore,
        );

        // Insertar el equipo y obtener su ID
        final teamId = await localDataSource.insertTeam(gameId, teamWithGameId);

        // Crear el modelo final con el ID
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
      // Crear equipos por defecto si no hay equipos definidos
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

      // Insertar equipos y obtener sus IDs de la DB
      final team1Id = await localDataSource.insertTeam(gameId, team1Template);
      final team2Id = await localDataSource.insertTeam(gameId, team2Template);

      // Crear los modelos de equipo finales con los IDs de la DB
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

      // Asignar los equipos finales al GameModel
      game.teams = [team1, team2];
    }

    // 3. Devolver el GameModel completo
    return game;
  }

  Future<int> saveTeam(int gameId, TeamModel team) async {
    final teamId = await localDataSource.insertTeam(gameId, team);
    return teamId;
  }

  // ===================== ROUNDS CRUD =====================

  Future<int> saveRound(int gameId, RoundModel round) async {
    final roundId = await localDataSource.insertRound(gameId, round);
    return roundId;
  }

  Future<int> updateTeamScore(int teamId, int newTotalScore) async {
    return localDataSource.updateTotalScore(teamId, newTotalScore);
  }

  Future<void> deleteRound(int roundId) async {
    await localDataSource.deleteRound(roundId);
  }

  // ===================== GAME METADATA UPDATES =====================

  Future<void> updateGamePointsToWin(int gameId, int pointsToWin) async {
    await localDataSource.updatePointToWin(gameId, pointsToWin);
  }

  Future<void> updateGameActualRound(int gameId, int actualRound) async {
    await localDataSource.updateActualRound(gameId, actualRound);
  }
}
