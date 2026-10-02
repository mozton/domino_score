import 'package:dominos_score/features/games/domain/entities/game_entity.dart';
import 'package:dominos_score/features/games/domain/repositories/game_repository.dart';
import 'package:dominos_score/features/profiles/domain/entities/match_summary_entity.dart';

/// Devuelve las últimas partidas del usuario a partir de sus juegos locales.
class GetMyRecentMatchesUseCase {
  final GameRepository _gameRepository;

  GetMyRecentMatchesUseCase(this._gameRepository);

  Future<List<MatchSummary>> call({int limit = 5}) async {
    final games = await _gameRepository.fetchLocalGames();
    if (games.isEmpty) return const [];

    games.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return games.take(limit).map(_toSummary).toList();
  }

  MatchSummary _toSummary(Game game) {
    final names = game.teams.map((t) => t.name).toList();
    final scores = game.teams.map((t) => t.totalScore).toList();

    final finished =
        game.pointsToWin > 0 &&
        game.teams.any((t) => t.totalScore >= game.pointsToWin);

    return MatchSummary(
      gameId: game.id ?? 0,
      title: names.isEmpty ? 'Partida' : names.join(' vs '),
      scoreDetail:
          '${scores.isEmpty ? '0' : scores.join(' - ')} • ${game.rounds.length} rondas',
      date: game.createdAt,
      finished: finished,
      // `wonByMe` quedará disponible cuando la jugabilidad registre a qué
      // equipo pertenece el jugador.
      wonByMe: null,
    );
  }
}
