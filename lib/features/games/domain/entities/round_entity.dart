import 'package:dominos_score/features/games/domain/entities/round_action.dart';
import 'package:equatable/equatable.dart';

/// Entidad de dominio de una ronda.
///
/// Los puntos se guardan en 4 columnas (para soportar hasta 4 equipos), pero se
/// exponen como lista para trabajar con 2, 3 o 4 equipos de forma uniforme.
/// Además, [events] guarda las acciones de la metodología (capicúa, pase
/// redondo, trancao, zapatero, pase individual).
class Round extends Equatable {
  final int? id;
  final int? gameId;
  final int number;
  final int team1Points;
  final int team2Points;
  final int? team3Points;
  final int? team4Points;
  final List<RoundEvent> events;

  const Round({
    this.id,
    this.gameId,
    required this.number,
    required this.team1Points,
    required this.team2Points,
    this.team3Points,
    this.team4Points,
    this.events = const [],
  });

  /// Puntos por equipo, en orden (siempre 4 posiciones; 0 cuando no aplica).
  List<int> get teamPoints => [
    team1Points,
    team2Points,
    team3Points ?? 0,
    team4Points ?? 0,
  ];

  /// Puntos que anotó el equipo en la posición [index].
  int pointsFor(int index) {
    final points = teamPoints;
    if (index < 0 || index >= points.length) return 0;
    return points[index];
  }

  /// Acciones registradas por un equipo concreto.
  List<RoundEvent> eventsForTeam(int teamIndex) =>
      events.where((event) => event.teamIndex == teamIndex).toList();

  /// Construye una ronda a partir de los puntos por equipo.
  factory Round.fromTeamPoints({
    int? id,
    int? gameId,
    required int number,
    required List<int> points,
    List<RoundEvent> events = const [],
  }) {
    int at(int index) => index < points.length ? points[index] : 0;
    return Round(
      id: id,
      gameId: gameId,
      number: number,
      team1Points: at(0),
      team2Points: at(1),
      team3Points: at(2),
      team4Points: at(3),
      events: events,
    );
  }

  Round copyWith({
    int? id,
    int? gameId,
    int? number,
    int? team1Points,
    int? team2Points,
    int? team3Points,
    int? team4Points,
    List<RoundEvent>? events,
  }) {
    return Round(
      id: id ?? this.id,
      gameId: gameId ?? this.gameId,
      number: number ?? this.number,
      team1Points: team1Points ?? this.team1Points,
      team2Points: team2Points ?? this.team2Points,
      team3Points: team3Points ?? this.team3Points,
      team4Points: team4Points ?? this.team4Points,
      events: events ?? this.events,
    );
  }

  @override
  List<Object?> get props => [
    id,
    gameId,
    number,
    team1Points,
    team2Points,
    team3Points,
    team4Points,
    events,
  ];
}
