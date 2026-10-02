import 'package:dominos_score/features/games/domain/entities/game_entity.dart';
import 'package:dominos_score/features/games/domain/repositories/game_repository.dart';

/// Cambia los puntos objetivo para ganar la partida.
class UpdatePointsToWinUseCase {
  final GameRepository repository;

  UpdatePointsToWinUseCase(this.repository);

  Future<Game> call(int gameId, int pointsToWin) async {
    await repository.updateGamePointsToWin(gameId, pointsToWin);
    return (await repository.fetchGameById(gameId))!;
  }
}
