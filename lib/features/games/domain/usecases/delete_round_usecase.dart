import 'package:dominos_score/features/games/domain/entities/game_entity.dart';
import 'package:dominos_score/features/games/domain/repositories/game_repository.dart';

/// Elimina una ronda: recalcula los marcadores de todos los equipos y el número
/// de ronda, borra la ronda y devuelve la partida recargada.
class DeleteRoundUseCase {
  final GameRepository repository;

  DeleteRoundUseCase(this.repository);

  Future<Game> call(Game game, {required int roundIndex}) async {
    final roundToDelete = game.rounds[roundIndex];
    final roundId = roundToDelete.id!;

    for (var i = 0; i < game.teams.length; i++) {
      final team = game.teams[i];
      if (team.id == null) continue;
      final newScore = team.totalScore - roundToDelete.pointsFor(i);
      await repository.updateTeamScore(team.id!, newScore);
    }

    final newActualRound = game.actualRound - 1;
    await repository.updateGameActualRound(
      game.id!,
      newActualRound < 0 ? 0 : newActualRound,
    );
    await repository.deleteRound(roundId);

    return (await repository.fetchGameById(game.id!))!;
  }
}
