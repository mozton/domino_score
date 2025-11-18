import 'dart:convert';

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
}
