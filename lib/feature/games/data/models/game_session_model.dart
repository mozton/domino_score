import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/game_session_entity.dart';

class GameSessionModel extends GameSessionEntity {
  const GameSessionModel({
    required super.id,
    required super.groupId,
    required super.joinCode,
    required super.status,
    required super.team1,
    required super.team2,
    super.scoreTeam1,
    super.scoreTeam2,
    super.totalRounds,
    required super.createdAt,
    super.finishedAt,
  });

  factory GameSessionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return GameSessionModel(
      id: doc.id,
      groupId: data['groupId'] ?? '',
      joinCode: data['joinCode'] ?? '',
      status: data['status'] ?? 'active',
      team1: data['team1'] ?? [],
      team2: data['team2'] ?? [],
      scoreTeam1: data['scoreTeam1'] ?? 0,
      scoreTeam2: data['scoreTeam2'] ?? 0,
      totalRounds: data['totalRounds'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      finishedAt: data['finishedAt'] != null
          ? (data['finishedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'groupId': groupId,
      'joinCode': joinCode,
      'status': status,
      'team1': team1,
      'team2': team2,
      'scoreTeam1': scoreTeam1,
      'scoreTeam2': scoreTeam2,
      'totalRounds': totalRounds,
      'createdAt': Timestamp.fromDate(createdAt),
      'finishedAt': finishedAt != null ? Timestamp.fromDate(finishedAt!) : null,
    };
  }
}
