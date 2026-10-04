import 'package:dominos_score/features/games/domain/entities/game_entity.dart';
import 'package:dominos_score/features/games/domain/entities/round_entity.dart';
import 'package:dominos_score/features/games/domain/entities/team_entity.dart';

/// Contrato del origen de datos de partidas.
///
/// Lo implementan tanto el origen local (Drift, historial general del usuario)
/// como el remoto (Firestore, partidas de un grupo).
abstract class GameDataSource {
  Future<int> createGame(Game game);
  Future<void> updatePointsToWin(int gameId, int pointsToWin);
  Future<void> updateActualRound(int gameId, int actualRound);
  Future<void> updateMyTeamIndex(int gameId, int? teamIndex);

  /// Código para ver la partida en vivo (solo partidas de grupo).
  Future<void> updateLiveCode(int gameId, String liveCode);

  Future<int> insertTeam(int gameId, Team team);
  Future<void> updateTeamName(int teamId, String newName);
  Future<void> updateTeamScore(int teamId, int newTotalScore);

  /// Jugadores del equipo (miembros del grupo o invitados).
  Future<void> updateTeamPlayers(
    int teamId,
    String? player1,
    String? player2,
  );

  Future<int> insertRound(int gameId, Round round);
  Future<void> deleteRound(int roundId);

  Future<List<Game>> getGames();
  Future<Game?> getGameById(int gameId);
}
