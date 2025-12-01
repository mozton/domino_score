import 'package:dominos_score/models/game/team_model.dart';
import 'package:dominos_score/models/game/round_model.dart';

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
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'actualRound': actualRound,
      'pointsToWin': pointsToWin,
      'createdAt': createdAt.toIso8601String(),
      'winnerTeamName': winnerTeamName,
      'teams': teams.map((t) => t.toJson()).toList(),
      'rounds': rounds.map((r) => r.toJson()).toList(),
    };
  }

  factory GameModel.fromJson(
    Map<String, dynamic> json, {
    required List<Team> teams,
    required List<Round> rounds,
  }) {
    return GameModel(
      id: json['id'] as int?,
      actualRound: json['actualRound'] as int,
      pointsToWin: json['pointsToWin'] as int,
      createdAt: DateTime.parse(json['createdAt']),
      winnerTeamName: json['winnerTeamName'] as String?,
      teams: teams,
      rounds: rounds,
    );
  }
}
