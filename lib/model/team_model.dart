class Team {
  final int id;
  String name;
  String? name2;
  int? totalPoints;

  Team({required this.id, required this.name, this.name2, this.totalPoints});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'name2': name2, 'points': totalPoints};
  }

  factory Team.fromMap(Map<String, dynamic> map) {
    return Team(
      id: map['id'],
      name: map['name'],
      name2: map['name2'],
      totalPoints: map['points'],
    );
  }
}
