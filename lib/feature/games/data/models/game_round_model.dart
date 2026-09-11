import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/game_round_entity.dart';

class GameRoundModel extends GameRoundEntity {
  const GameRoundModel({
    required super.id,
    required super.roundNumber,
    required super.winningTeam,
    required super.pointsScored,
    super.isCapicua,
    super.isTrancao,
    super.playerWhoScoredId,
    required super.timestamp,
  });

  factory GameRoundModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return GameRoundModel(
      id: doc.id,
      roundNumber: data['roundNumber'] ?? 0,
      winningTeam: data['winningTeam'] ?? '',
      pointsScored: data['pointsScored'] ?? 0,
      isCapicua: data['isCapicua'] ?? false,
      isTrancao: data['isTrancao'] ?? false,
      playerWhoScoredId: data['playerWhoScoredId'],
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'roundNumber': roundNumber,
      'winningTeam': winningTeam,
      'pointsScored': pointsScored,
      'isCapicua': isCapicua,
      'isTrancao': isTrancao,
      'playerWhoScoredId': playerWhoScoredId,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}
