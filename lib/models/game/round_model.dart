class RoundModel {
  int? id;
  final int? gameId; // Foreign Key
  final int number;
  final int team1Points;
  final int team2Points;
  final int? team3Points;
  final int? team4Points;

  RoundModel({
    this.id,
    this.gameId,
    required this.number,
    required this.team1Points,
    required this.team2Points,
    this.team3Points,
    this.team4Points,
  });

  factory RoundModel.fromMap(Map<String, dynamic> map) {
    return RoundModel(
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

  factory RoundModel.fromJson(Map<String, dynamic> json) {
    return RoundModel(
      id: json['id'] as int?,
      gameId: json['gameId'] as int?,
      number: json['number'] as int,
      team1Points: json['team1Points'] as int,
      team2Points: json['team2Points'] as int,
      team3Points: json['team3Points'] as int?,
      team4Points: json['team4Points'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
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

  RoundModel copyWith({
    int? id,
    int? gameId,
    int? number,
    int? team1Points,
    int? team2Points,
    int? team3Points,
    int? team4Points,
  }) {
    return RoundModel(
      id: id ?? this.id,
      gameId: gameId ?? this.gameId,
      number: number ?? this.number,
      team1Points: team1Points ?? this.team1Points,
      team2Points: team2Points ?? this.team2Points,
      team3Points: team3Points ?? this.team3Points,
      team4Points: team4Points ?? this.team4Points,
    );
  }
}
