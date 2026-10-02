import 'package:dominos_score/features/games/domain/entities/game_entity.dart';
import 'package:dominos_score/features/games/domain/entities/game_mode.dart';
import 'package:dominos_score/features/games/domain/repositories/game_repository.dart';

/// Crea una partida nueva con los equipos por defecto del [mode].
///
/// [liveCode] es el código para verla en vivo (solo partidas de grupo).
class StartNewGameUseCase {
  final GameRepository repository;

  StartNewGameUseCase(this.repository);

  Future<Game> call({
    required int pointsToWin,
    required GameMode mode,
    String? liveCode,
  }) {
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
}
