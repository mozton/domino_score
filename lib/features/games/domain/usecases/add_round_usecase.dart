import 'package:dominos_score/features/games/domain/entities/game_entity.dart';
import 'package:dominos_score/features/games/domain/entities/round_action.dart';
import 'package:dominos_score/features/games/domain/entities/round_entity.dart';
import 'package:dominos_score/features/games/domain/repositories/game_repository.dart';

/// Añade una ronda a la partida actual.
///
/// [teamPoints] trae los puntos anotados por cada equipo en esta ronda (en el
/// orden de `game.teams`) y [events] las acciones de la metodología (capicúa,
/// pase redondo, trancao, zapatero, pase individual), que **no alteran** los
/// puntos.
class AddRoundUseCase {
  final GameRepository repository;

  AddRoundUseCase(this.repository);

  Future<Game> call(
    Game game, {
    required List<int> teamPoints,
    List<RoundEvent> events = const [],
  }) async {
    final gameId = game.id!;
    final nextRoundNumber = game.actualRound + 1;

    final round = Round.fromTeamPoints(
      number: nextRoundNumber,
      gameId: gameId,
      points: teamPoints,
      events: events,
    );

    await repository.saveRound(gameId, round);

    for (var i = 0; i < game.teams.length; i++) {
      final team = game.teams[i];
      if (team.id == null) continue;
      final points = i < teamPoints.length ? teamPoints[i] : 0;
      await repository.updateTeamScore(team.id!, team.totalScore + points);
    }

    await repository.updateGameActualRound(gameId, nextRoundNumber);

    return (await repository.fetchGameById(gameId))!;
  }
}
