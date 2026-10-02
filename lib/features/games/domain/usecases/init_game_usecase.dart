import 'package:dominos_score/features/games/domain/entities/game_entity.dart';
import 'package:dominos_score/features/games/domain/entities/game_mode.dart';
import 'package:dominos_score/features/games/domain/repositories/game_repository.dart';

/// Inicializa el juego: carga la última partida del alcance activo (local o
/// del grupo) o, si no hay ninguna, crea una nueva con los equipos por defecto
/// del [mode].
class InitGameUseCase {
  final GameRepository repository;

  InitGameUseCase(this.repository);

  Future<Game> call({
    required int pointsToWin,
    required GameMode mode,
    String? liveCode,
  }) async {
    final games = await repository.fetchActiveGames();
    if (games.isEmpty) {
      return repository.createGameWithDefaultTeams(
        Game(
          actualRound: 0,
          pointsToWin: pointsToWin,
          createdAt: DateTime.now(),
          teams: mode.buildDefaultTeams(),
          liveCode: liveCode,
        ),
      );
    }
    return games.last;
  }
}
