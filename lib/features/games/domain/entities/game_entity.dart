import 'package:dominos_score/features/games/domain/entities/round_entity.dart';
import 'package:dominos_score/features/games/domain/entities/team_entity.dart';
import 'package:equatable/equatable.dart';

/// Entidad de dominio de una partida.
class Game extends Equatable {
  final int? id;
  final int actualRound;
  final int pointsToWin;
  final DateTime createdAt;
  final String? winnerTeamName;
  final List<Team> teams;
  final List<Round> rounds;

  /// Equipo en el que juega el usuario (0-based). `null` si no se ha marcado.
  /// Sirve para calcular victorias/derrotas reales en el perfil.
  final int? myTeamIndex;

  /// Código de esta partida para verla en vivo (solo partidas de grupo).
  final String? liveCode;

  const Game({
    this.id,
    required this.actualRound,
    required this.pointsToWin,
    required this.createdAt,
    this.winnerTeamName,
    this.teams = const [],
    this.rounds = const [],
    this.myTeamIndex,
    this.liveCode,
  });

  Game copyWith({
    int? id,
    int? actualRound,
    int? pointsToWin,
    DateTime? createdAt,
    String? winnerTeamName,
    List<Team>? teams,
    List<Round>? rounds,
    int? myTeamIndex,
    String? liveCode,
  }) {
    return Game(
      id: id ?? this.id,
      actualRound: actualRound ?? this.actualRound,
      pointsToWin: pointsToWin ?? this.pointsToWin,
      createdAt: createdAt ?? this.createdAt,
      winnerTeamName: winnerTeamName ?? this.winnerTeamName,
      teams: teams ?? this.teams,
      rounds: rounds ?? this.rounds,
      myTeamIndex: myTeamIndex ?? this.myTeamIndex,
      liveCode: liveCode ?? this.liveCode,
    );
  }

  /// Equipo marcado como "mi equipo", si existe.
  Team? get myTeam {
    final index = myTeamIndex;
    if (index == null || index < 0 || index >= teams.length) return null;
    return teams[index];
  }

  @override
  List<Object?> get props => [
    id,
    actualRound,
    pointsToWin,
    createdAt,
    winnerTeamName,
    teams,
    rounds,
    myTeamIndex,
    liveCode,
  ];
}
