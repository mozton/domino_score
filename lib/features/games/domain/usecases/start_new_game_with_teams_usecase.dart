import 'package:dominos_score/features/games/domain/entities/game_entity.dart';
import 'package:dominos_score/features/games/domain/entities/team_entity.dart';
import 'package:dominos_score/features/games/domain/repositories/game_repository.dart';

/// Crea una partida nueva reutilizando los nombres/jugadores de los equipos
/// actuales, con el marcador a cero (la "revancha").
///
/// [liveCode] es el código para verla en vivo (solo partidas de grupo).
class StartNewGameWithTeamsUseCase {
  final GameRepository repository;

  StartNewGameWithTeamsUseCase(this.repository);

  Future<Game> call(Game currentGame, {String? liveCode}) {
    final teams = currentGame.teams
        .map(
          (t) => Team(
            name: t.name,
            player1: t.player1,
            player2: t.player2,
            totalScore: 0,
          ),
        )
        .toList();

    return repository.createGameWithDefaultTeams(
      Game(
        actualRound: 0,
        pointsToWin: currentGame.pointsToWin,
        createdAt: DateTime.now(),
        teams: teams,
        myTeamIndex: currentGame.myTeamIndex,
        liveCode: liveCode,
      ),
    );
  }
}
