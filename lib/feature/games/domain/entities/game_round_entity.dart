import 'package:equatable/equatable.dart';

class GameRoundEntity extends Equatable {
  final String id;
  final int roundNumber;
  final String winningTeam; // 'team1' o 'team2'
  final int pointsScored;
  final bool isCapicua;
  final bool isTrancao;
  final String? playerWhoScoredId;
  final DateTime timestamp;

  const GameRoundEntity({
    required this.id,
    required this.roundNumber,
    required this.winningTeam,
    required this.pointsScored,
    this.isCapicua = false,
    this.isTrancao = false,
    this.playerWhoScoredId,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [
    id,
    roundNumber,
    winningTeam,
    pointsScored,
    isCapicua,
    isTrancao,
    playerWhoScoredId,
    timestamp,
  ];
}
