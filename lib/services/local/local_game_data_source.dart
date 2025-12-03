import 'package:dominos_score/models/game/game_model.dart';
import 'package:dominos_score/models/game/team_model.dart';
import 'package:dominos_score/models/game/round_model.dart';

// Interface para el servicio local (Sqflite, Hive, etc.)
abstract class LocalGameDataSource {
  //name team
  Future<int> insertTeam(int gameId, TeamModel team);
  Future<int> updateTeamName(int teamId, String newName);
  Future<int> updateTotalScore(int teamId, int newTotalScore);

  // ROUND
  Future<int> insertRound(int gameId, RoundModel round);
  Future<void> deleteRound(int roundId);

  //OTHER
  Future<List<GameModel>> getGames();
  // Future<GameModel> getGameById(int gameId);
  Future<int> createGame(GameModel game);
  Future<void> updatePointToWin(int gameId, int pointsToWin);
  Future<void> updateActualRound(int gameId, int actualRound);

  // Se asume que tu DatabaseHelper implementará estos métodos
}
