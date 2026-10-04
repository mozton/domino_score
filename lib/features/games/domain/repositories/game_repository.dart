import 'package:dominos_score/features/games/domain/entities/game_entity.dart';
import 'package:dominos_score/features/games/domain/entities/round_entity.dart';
import 'package:dominos_score/features/games/domain/entities/team_entity.dart';

/// Contrato de repositorio del dominio de games.
///
/// Distingue tres lecturas de historial:
///  - [fetchLocalGames]: partidas locales del usuario (historial general).
///  - [fetchGroupGames]: partidas de un grupo (Firestore, compartidas).
///  - [fetchActiveGames]: partidas del alcance de la sesión actual.
abstract class GameRepository {
  Future<List<Game>> fetchLocalGames();
  Future<List<Game>> fetchGroupGames(String groupId);
  Future<List<Game>> fetchActiveGames();

  Future<Game?> fetchGameById(int gameId);

  Future<int> saveGame(Game game);
  Future<Game> createGameWithDefaultTeams(Game game);

  Future<int> insertTeam(int gameId, Team team);
  Future<void> updateTeamName(int teamId, String name);
  Future<void> updateTeamScore(int teamId, int newTotalScore);

  /// Jugadores del equipo: miembros del grupo o invitados con nombre propio.
  Future<void> updateTeamPlayers(int teamId, String? player1, String? player2);

  Future<int> saveRound(int gameId, Round round);
  Future<void> deleteRound(int roundId);

  Future<void> updateGamePointsToWin(int gameId, int pointsToWin);
  Future<void> updateGameActualRound(int gameId, int actualRound);

  /// Marca el equipo en el que juega el usuario (metodología de juego).
  Future<void> updateGameMyTeamIndex(int gameId, int? teamIndex);

  /// Guarda el código con el que se puede ver la partida en vivo.
  Future<void> updateGameLiveCode(int gameId, String liveCode);
}
