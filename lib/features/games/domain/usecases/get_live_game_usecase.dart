import 'package:dominos_score/features/games/domain/entities/live_game_entity.dart';
import 'package:dominos_score/features/games/domain/repositories/live_game_repository.dart';

class GetLiveGameUseCase {
  final LiveGameRepository repository;

  GetLiveGameUseCase(this.repository);

  Future<LiveGame?> call(String code) => repository.getByCode(code);
}
