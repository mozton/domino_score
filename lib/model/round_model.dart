class Round {
  int? id;
  final int? gameId; // Foreign Key
  final int number;
  final int team1Points;
  final int team2Points;
  final int? team3Points;
  final int? team4Points;

  Round({
    this.id,
    this.gameId,
    required this.number,
    required this.team1Points,
    required this.team2Points,
    this.team3Points,
    this.team4Points,
  });

  factory Round.fromMap(Map<String, dynamic> map) {
    return Round(
      id: map['id'] as int?,
      gameId: map['gameId'] as int?,
      number: map['number'] as int,
      team1Points: map['team1Points'] as int,
      team2Points: map['team2Points'] as int,
      team3Points: map['team3Points'] as int?,
      team4Points: map['team4Points'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'gameId': gameId,
      'number': number,
      'team1Points': team1Points,
      'team2Points': team2Points,
      'team3Points': team3Points,
      'team4Points': team4Points,
    };
  }
}
