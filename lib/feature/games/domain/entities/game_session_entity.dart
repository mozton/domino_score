import 'package:equatable/equatable.dart';

class GameSessionEntity extends Equatable {
  final String id;
  final String groupId;
  final String joinCode; // Código temporal para ver en vivo
  final String status; // 'active' o 'finished'
  final List<dynamic> team1; // Ej. [{"id": "123", "name": "Luis"}]
  final List<dynamic> team2;
  final int scoreTeam1;
  final int scoreTeam2;
  final int totalRounds;
  final DateTime createdAt;
  final DateTime? finishedAt;

  const GameSessionEntity({
    required this.id,
    required this.groupId,
    required this.joinCode,
    required this.status,
    required this.team1,
    required this.team2,
    this.scoreTeam1 = 0,
    this.scoreTeam2 = 0,
    this.totalRounds = 0,
    required this.createdAt,
    this.finishedAt,
  });

  @override
  List<Object?> get props => [
    id,
    groupId,
    joinCode,
    status,
    team1,
    team2,
    scoreTeam1,
    scoreTeam2,
    totalRounds,
    createdAt,
    finishedAt,
  ];
}
