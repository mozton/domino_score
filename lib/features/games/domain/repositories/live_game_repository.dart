import 'package:dominos_score/features/games/domain/entities/live_game_entity.dart';

abstract class LiveGameRepository {
  /// Publica (o actualiza) la vista en vivo de la partida.
  Future<void> publish(LiveGame liveGame);

  /// Devuelve la partida en vivo asociada al [code], o `null` si no existe.
  Future<LiveGame?> getByCode(String code);
}
