class Round {
  int? id;
  int round;
  int pointTeam1;
  int pointTeam2;
  int? pointTeam3;
  int? pointTeam4;

  Round({
    this.id,
    required this.round,
    required this.pointTeam1,
    required this.pointTeam2,
    this.pointTeam3,
    this.pointTeam4,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'round': round,
      'pointTeam1': pointTeam1,
      'pointTeam2': pointTeam2,
      'pointTeam3': pointTeam3,
      'pointTeam4': pointTeam4,
    };
  }

  factory Round.fromMap(Map<String, dynamic> map) {
    return Round(
      id: map['id'] as int?,
      round: map['round'] as int,
      pointTeam1: map['pointTeam1'] as int,
      pointTeam2: map['pointTeam2'] as int,
      pointTeam3: map['pointTeam3'] as int?, // Agregado
      pointTeam4: map['pointTeam4'] as int?, // Agregado
    );
  }
}
