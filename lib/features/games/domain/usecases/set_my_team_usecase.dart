import 'package:dominos_score/core/error/app_exception.dart';
import 'package:dominos_score/features/games/domain/entities/game_entity.dart';
import 'package:dominos_score/features/games/domain/repositories/game_repository.dart';

/// Marca (o limpia) el equipo en el que juega el usuario en la partida actual.
class SetMyTeamUseCase {
  final GameRepository repository;

  SetMyTeamUseCase(this.repository);

  Future<void> call(Game game, int? teamIndex) {
    final gameId = game.id;
    if (gameId == null) {
      throw AppException('La partida todavía no está guardada.');
    }
    if (teamIndex != null &&
        (teamIndex < 0 || teamIndex >= game.teams.length)) {
      throw AppException('Equipo inválido.');
    }
    return repository.updateGameMyTeamIndex(gameId, teamIndex);
  }
}
