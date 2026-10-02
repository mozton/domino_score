import 'package:dominos_score/features/games/domain/entities/game_entity.dart';
import 'package:dominos_score/features/games/domain/repositories/game_repository.dart';

/// Carga el historial de un grupo (partidas en Firestore), ordenado de más
/// reciente a más antigua.
class GetGroupGamesUseCase {
  final GameRepository repository;

  GetGroupGamesUseCase(this.repository);

  Future<List<Game>> call(String groupId) async {
    final games = await repository.fetchGroupGames(groupId);
    games.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return games;
  }
}
