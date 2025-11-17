import 'package:dominos_score/model/models.dart';

class GameModel {
  int? id;
  List<Round> rounds;
  int actualRound;
  Team team1;
  Team team2;
  Team? team3;
  Team? team4;
  int pointsToWin;
  DateTime? createdAt;
  String? winnerTeamName;

  GameModel({
    this.id,
    required this.rounds,
    required this.actualRound,
    required this.team1,
    required this.team2,
    this.team3,
    this.team4,
    required this.pointsToWin,
    this.createdAt,
    this.winnerTeamName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'rounds': rounds.map((round) => round.toMap()).toList(),
      'actualRound': actualRound,
      'team1': team1.toMap(),
      'team2': team2.toMap(),
      'team3': team3?.toMap(),
      'team4': team4?.toMap(),
      'pointsToWin': pointsToWin,
      'createdAt': createdAt?.toIso8601String(),
      'winnerTeamName': winnerTeamName,
    };
  }

  factory GameModel.fromMap(Map<String, dynamic> map) {
    return GameModel(
      id: map['id'] as int?,
      rounds: List<Round>.from(
        (map['rounds'] as List<dynamic>).map(
          (roundMap) => Round.fromMap(roundMap as Map<String, dynamic>),
        ),
      ),
      actualRound: map['actualRound'] as int,
      team1: Team.fromMap(map['team1'] as Map<String, dynamic>),
      team2: Team.fromMap(map['team2'] as Map<String, dynamic>),
      team3: map['team3'] != null
          ? Team.fromMap(map['team3'] as Map<String, dynamic>)
          : null,
      team4: map['team4'] != null
          ? Team.fromMap(map['team4'] as Map<String, dynamic>)
          : null,
      pointsToWin: map['pointsToWin'] as int,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : null,
      winnerTeamName: map['winnerTeamName'] as String?,
    );
  }
}
