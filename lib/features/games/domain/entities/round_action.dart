import 'package:equatable/equatable.dart';

/// Acciones que se pueden registrar en una ronda (metodología de juego).
///
/// No modifican los puntos: son estadísticas/medallas.
enum RoundActionType {
  capicua('Capicúa'),
  paseRedondo('Pase redondo'),
  trancao('Trancao'),
  zapatero('Zapatero'),
  paseIndividual('Pase individual');

  final String label;

  const RoundActionType(this.label);

  static RoundActionType fromName(String? name) {
    return RoundActionType.values.firstWhere(
      (action) => action.name == name,
      orElse: () => RoundActionType.paseIndividual,
    );
  }
}

/// Acción registrada en una ronda, atribuida a un equipo y, opcionalmente, a
/// un jugador concreto de ese equipo.
class RoundEvent extends Equatable {
  final RoundActionType type;

  /// Índice del equipo en `game.teams` (0-based).
  final int teamIndex;

  /// Nombre del jugador que la hizo (opcional).
  final String? playerName;

  const RoundEvent({
    required this.type,
    required this.teamIndex,
    this.playerName,
  });

  Map<String, dynamic> toMap() {
    return {
      'type': type.name,
      'teamIndex': teamIndex,
      'playerName': playerName,
    };
  }

  factory RoundEvent.fromMap(Map<String, dynamic> map) {
    return RoundEvent(
      type: RoundActionType.fromName(map['type'] as String?),
      teamIndex: (map['teamIndex'] as num?)?.toInt() ?? 0,
      playerName: map['playerName'] as String?,
    );
  }

  @override
  List<Object?> get props => [type, teamIndex, playerName];
}
