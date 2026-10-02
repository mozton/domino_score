import 'package:dominos_score/features/games/domain/entities/live_game_entity.dart';
import 'package:dominos_score/features/games/domain/repositories/live_game_repository.dart';

class PublishLiveGameUseCase {
  final LiveGameRepository repository;

  PublishLiveGameUseCase(this.repository);

  Future<void> call(LiveGame liveGame) => repository.publish(liveGame);
}
