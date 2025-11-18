import 'package:dominos_score/model/models.dart';

class GameModel {
  int? id;
  int actualRound;
  int pointsToWin;
  DateTime createdAt;
  String? winnerTeamName;

  List<Team> teams;
  List<Round> rounds;

  GameModel({
    this.id,
    required this.actualRound,
    required this.pointsToWin,
    required this.createdAt,
    this.winnerTeamName,
    required this.teams,
    required this.rounds,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'actualRound': actualRound,
      'pointsToWin': pointsToWin,
      'createdAt': createdAt.toIso8601String(),
      'winnerTeamName': winnerTeamName,
    };
  }

  factory GameModel.fromMap(
    Map<String, dynamic> map, {
    required List<Team> teams,
    required List<Round> rounds,
  }) {
    return GameModel(
      id: map['id'] as int?,
      actualRound: map['actualRound'] as int,
      pointsToWin: map['pointsToWin'] as int,
      createdAt: DateTime.parse(map['createdAt']),
      winnerTeamName: map['winnerTeamName'] as String?,
      teams: teams,
      rounds: rounds,
    );
  }
}
