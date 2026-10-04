import 'package:dominos_score/features/games/domain/entities/game_entity.dart';
import 'package:dominos_score/features/games/domain/entities/game_mode.dart';
import 'package:dominos_score/features/games/domain/entities/team_entity.dart';
import 'package:dominos_score/features/games/domain/repositories/game_repository.dart';

/// Crea una partida nueva con los equipos por defecto del [mode].
///
/// [liveCode] es el código para verla en vivo (solo partidas de grupo).
///
/// [playerNames] son los nombres de los miembros del grupo: se reparten por
/// los puestos de los equipos (2 por equipo en parejas, 1 en individual). Los
/// puestos que sobren quedan como "Jugador N" para que se cambien por invitados.
class StartNewGameUseCase {
  final GameRepository repository;

  StartNewGameUseCase(this.repository);

  Future<Game> call({
    required int pointsToWin,
    required GameMode mode,
    String? liveCode,
    List<String> playerNames = const [],
  }) {
    return repository.createGameWithDefaultTeams(
      Game(
        actualRound: 0,
        pointsToWin: pointsToWin,
        createdAt: DateTime.now(),
        teams: _withPlayers(mode.buildDefaultTeams(), playerNames, mode),
        liveCode: liveCode,
      ),
    );
  }

  List<Team> _withPlayers(
    List<Team> teams,
    List<String> names,
    GameMode mode,
  ) {
    final available = names
        .map((name) => name.trim())
        .where((name) => name.isNotEmpty)
        .toList();
    if (available.isEmpty) return teams;

    final result = <Team>[];
    var next = 0;

    for (final team in teams) {
      if (next >= available.length) {
        result.add(team);
        continue;
      }

      if (mode.isTeams) {
        final player1 = available[next++];
        final player2 = next < available.length
            ? available[next++]
            : team.player2;
        result.add(team.copyWith(player1: player1, player2: player2));
      } else {
        // En individual el equipo es el jugador.
        final player = available[next++];
        result.add(team.copyWith(name: player, player1: player));
      }
    }

    return result;
  }
}
