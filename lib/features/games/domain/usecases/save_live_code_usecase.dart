import 'package:dominos_score/features/games/domain/entities/game_entity.dart';
import 'package:dominos_score/features/games/domain/repositories/game_repository.dart';

/// Guarda en la partida el código con el que se puede ver en vivo.
///
/// Hace falta para que el código se mantenga cuando otra persona (o el mismo
/// anfitrión) vuelve a abrir la partida más tarde.
class SaveLiveCodeUseCase {
  final GameRepository repository;

  SaveLiveCodeUseCase(this.repository);

  Future<void> call(Game game, String liveCode) async {
    final gameId = game.id;
    if (gameId == null) return;
    await repository.updateGameLiveCode(gameId, liveCode);
  }
}
