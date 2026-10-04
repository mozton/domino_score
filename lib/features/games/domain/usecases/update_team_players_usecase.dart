import 'package:dominos_score/features/games/domain/entities/game_entity.dart';
import 'package:dominos_score/features/games/domain/repositories/game_repository.dart';

/// Cambia los jugadores de un equipo (miembros del grupo o invitados).
class UpdateTeamPlayersUseCase {
  final GameRepository repository;

  UpdateTeamPlayersUseCase(this.repository);

  Future<Game> call(
    Game game, {
    required int teamId,
    String? player1,
    String? player2,
  }) async {
    await repository.updateTeamPlayers(teamId, player1, player2);
    return (await repository.fetchGameById(game.id!))!;
  }
}
