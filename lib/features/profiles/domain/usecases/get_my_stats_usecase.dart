import 'package:dominos_score/features/games/domain/entities/round_action.dart';
import 'package:dominos_score/features/games/domain/repositories/game_repository.dart';
import 'package:dominos_score/features/profiles/domain/entities/player_stats_entity.dart';

/// Calcula las estadísticas del usuario a partir de sus partidas locales.
///
/// Las victorias/derrotas usan el equipo marcado como "mi equipo" y las
/// capicúas/zapateros se cuentan de las acciones registradas por ese equipo.
class GetMyStatsUseCase {
  final GameRepository _gameRepository;

  GetMyStatsUseCase(this._gameRepository);

  Future<PlayerStats> call() async {
    final games = await _gameRepository.fetchLocalGames();
    if (games.isEmpty) return PlayerStats.empty;

    var gamesFinished = 0;
    var totalRounds = 0;
    var totalPoints = 0;
    var bestGamePoints = 0;
    var wins = 0;
    var losses = 0;
    var capicuas = 0;
    var zapateros = 0;

    for (final game in games) {
      final myIndex = game.myTeamIndex;

      var gamePoints = 0;
      for (final round in game.rounds) {
        // Suma los puntos de todos los equipos de la partida (2, 3 o 4).
        for (var i = 0; i < game.teams.length; i++) {
          gamePoints += round.pointsFor(i);
        }

        // Acciones de la metodología atribuidas a mi equipo.
        if (myIndex != null) {
          for (final event in round.events) {
            if (event.teamIndex != myIndex) continue;
            if (event.type == RoundActionType.capicua) capicuas++;
            if (event.type == RoundActionType.zapatero) zapateros++;
          }
        }
      }

      totalRounds += game.rounds.length;
      totalPoints += gamePoints;
      if (gamePoints > bestGamePoints) bestGamePoints = gamePoints;

      final goal = game.pointsToWin;
      final finished =
          goal > 0 && game.teams.any((team) => team.totalScore >= goal);

      if (finished) {
        gamesFinished++;
        if (myIndex != null && myIndex < game.teams.length) {
          if (game.teams[myIndex].totalScore >= goal) {
            wins++;
          } else {
            losses++;
          }
        }
      }
    }

    return PlayerStats(
      gamesPlayed: games.length,
      gamesFinished: gamesFinished,
      totalRounds: totalRounds,
      totalPoints: totalPoints,
      averagePointsPerGame: totalPoints / games.length,
      bestGamePoints: bestGamePoints,
      wins: wins,
      losses: losses,
      capicuas: capicuas,
      zapateros: zapateros,
    );
  }
}
