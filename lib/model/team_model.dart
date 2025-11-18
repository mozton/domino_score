class Team {
  final int? id;
  final int gameId; // Foreign Key
  final String name;
  final int totalPoints;
  Team({
    this.id,
    required this.gameId,
    required this.name,
    required this.totalPoints,
  });

  factory Team.fromMap(Map<String, dynamic> map) {
    return Team(
      id: map['id'] as int?,
      gameId: map['gameId'] as int,
      name: map['name'] as String,
      totalPoints: map['totalPoints'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'gameId': gameId,
      'name': name,
      'totalPoints': totalPoints,
    };
  }
}
