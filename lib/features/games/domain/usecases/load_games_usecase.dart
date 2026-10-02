import 'package:dominos_score/features/games/domain/entities/game_entity.dart';
import 'package:dominos_score/features/games/domain/repositories/game_repository.dart';

/// Carga el historial general (solo partidas locales del usuario), ordenado de
/// más reciente a más antigua.
class LoadGamesUseCase {
  final GameRepository repository;

  LoadGamesUseCase(this.repository);

  Future<List<Game>> call() async {
    final games = await repository.fetchLocalGames();
    games.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return games;
  }
}
