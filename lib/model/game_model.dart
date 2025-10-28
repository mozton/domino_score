import 'package:dominos_score/model/round_model.dart';

class GameModel {
  List<Round> rounds;
  int actualRound;
  Team team1;
  Team team2;

  GameModel({
    required this.rounds,
    required this.actualRound,
    required this.team1,
    required this.team2,
  });
}

class Team {
  final int id;
  String name;

  Team({required this.id, required this.name});
}
