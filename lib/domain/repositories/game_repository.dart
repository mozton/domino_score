import 'package:dominos_score/domain/models/game/game_model.dart';
import 'package:dominos_score/domain/models/game/team_model.dart';
import 'package:dominos_score/domain/models/game/round_model.dart';

abstract class GameRepository {
  // ===================== GAMES CRUD & FETCH =====================

  Future<List<GameModel>> fetchAllGames();
  Future<int> saveGame(GameModel game);
  Future<GameModel> createGameWithDefaultTeams(GameModel game);

  // ===================== TEAM CRUD =====================

  Future<int> insertTeam(int gameId, TeamModel team);
  Future<int> updateTeamName(int teamId, String newName);
  Future<int> saveTeam(int gameId, TeamModel team);

  // ===================== ROUNDS & SCORE CRUD =====================

  Future<int> saveRound(int gameId, RoundModel round);
  Future<int> updateTeamScore(int teamId, int newTotalScore);
  Future<void> deleteRound(int roundId);

  // ===================== GAME METADATA UPDATES =====================

  Future<void> updateGamePointsToWin(int gameId, int pointsToWin);
  Future<void> updateGameActualRound(int gameId, int actualRound);
}
