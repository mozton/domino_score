import 'package:dominos_score/features/games/domain/entities/game_entity.dart';
import 'package:equatable/equatable.dart';

/// Vista en vivo de una partida de grupo.
///
/// Se publica en Firestore en `liveGames/{code}` y la puede leer cualquiera que
/// tenga el código (sin necesidad de ser miembro del grupo).
class LiveGame extends Equatable {
  final String code;
  final String groupId;
  final String groupName;
  final Game game;
  final DateTime updatedAt;

  const LiveGame({
    required this.code,
    required this.groupId,
    required this.groupName,
    required this.game,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [code, groupId, groupName, game, updatedAt];
}
