import 'package:dominos_score/features/games/domain/entities/team_entity.dart';

/// Modo de partida: equipos (parejas) o individual (free for all / pintintín).
enum GameMode {
  teams2v2(2, 2, 'Equipos · 2 vs 2'),
  individual2(2, 1, 'Individual · 2'),
  individual3(3, 1, 'Individual · 3 (Pintintín)'),
  individual4(4, 1, 'Individual · 4');

  /// Cantidad de equipos/jugadores que puntúan de forma independiente.
  final int teamCount;

  /// Jugadores por equipo (2 = parejas, 1 = individual).
  final int playersPerTeam;

  final String label;

  const GameMode(this.teamCount, this.playersPerTeam, this.label);

  bool get isTeams => playersPerTeam == 2;

  static GameMode fromName(String? name) {
    return GameMode.values.firstWhere(
      (mode) => mode.name == name,
      orElse: () => GameMode.teams2v2,
    );
  }

  /// Equipos por defecto para este modo.
  List<Team> buildDefaultTeams() {
    if (isTeams) {
      return List.generate(
        teamCount,
        (i) => Team(
          name: 'Team ${i + 1}',
          player1: 'Jugador ${i * 2 + 1}',
          player2: 'Jugador ${i * 2 + 2}',
          totalScore: 0,
        ),
      );
    }
    return List.generate(
      teamCount,
      (i) => Team(name: 'Jugador ${i + 1}', totalScore: 0),
    );
  }
}
