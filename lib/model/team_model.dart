class Team {
  final int? id;
  final int? gameId; // Foreign Key
  String name = 'Team 1';
  String? player1 = 'Jugador 1';
  String? player2 = 'Jugador 2';
  int? totalScore;

  Team({
    this.id,
    this.gameId,
    required this.name,
    this.player1,
    this.player2,
    this.totalScore,
  });

  factory Team.fromMap(Map<String, dynamic> map) {
    return Team(
      id: map['id'] as int?,
      gameId: map['gameId'] as int?,
      name: map['name'] as String,
      player1: map['player1'] as String?,
      player2: map['player2'] as String?,
      totalScore: map['totalScore'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'gameId': gameId,
      'name': name,
      'player1': player1,
      'player2': player2,
      'totalScore': totalScore,
    };
  }
}
