class Team {
  final int? id;
  final int? gameId; // Foreign Key
  String name = 'Team1';

  Team({this.id, this.gameId, required this.name});

  factory Team.fromMap(Map<String, dynamic> map) {
    return Team(
      id: map['id'] as int?,
      gameId: map['gameId'] as int?,
      name: map['name'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'gameId': gameId, 'name': name};
  }
}
