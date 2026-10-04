import 'package:dominos_score/features/games/data/datasources/game_data_source.dart';
import 'package:dominos_score/features/games/domain/entities/game_entity.dart';
import 'package:dominos_score/features/games/domain/entities/round_entity.dart';
import 'package:dominos_score/features/games/domain/entities/team_entity.dart';
import 'package:dominos_score/features/games/domain/repositories/game_repository.dart';

/// Implementación del repositorio de games.
///
/// Las operaciones de la sesión van al origen de datos del alcance activo
/// (local o del grupo), mientras que el historial general lee siempre el
/// origen local y el historial de grupo su colección en Firestore.
class GameRepositoryImpl implements GameRepository {
  final GameDataSource _activeDataSource;
  final GameDataSource _localDataSource;
  final GameDataSource Function(String groupId) _groupDataSourceFactory;

  GameRepositoryImpl({
    required GameDataSource activeDataSource,
    required GameDataSource localDataSource,
    required GameDataSource Function(String groupId) groupDataSourceFactory,
  }) : _activeDataSource = activeDataSource,
       _localDataSource = localDataSource,
       _groupDataSourceFactory = groupDataSourceFactory;

  @override
  Future<List<Game>> fetchLocalGames() => _localDataSource.getGames();

  @override
  Future<List<Game>> fetchGroupGames(String groupId) =>
      _groupDataSourceFactory(groupId).getGames();

  @override
  Future<List<Game>> fetchActiveGames() => _activeDataSource.getGames();

  @override
  Future<Game?> fetchGameById(int gameId) =>
      _activeDataSource.getGameById(gameId);

  @override
  Future<int> saveGame(Game game) => _activeDataSource.createGame(game);

  @override
  Future<Game> createGameWithDefaultTeams(Game game) async {
    final gameId = await _activeDataSource.createGame(game);
    final gameWithId = game.copyWith(id: gameId);

    final List<Team> teams;
    if (game.teams.isNotEmpty) {
      teams = [];
      for (final team in game.teams) {
        final teamId = await _activeDataSource.insertTeam(
          gameId,
          team.copyWith(gameId: gameId),
        );
        teams.add(team.copyWith(id: teamId, gameId: gameId));
      }
    } else {
      final team1Id = await _activeDataSource.insertTeam(
        gameId,
        const Team(name: 'Team 1', totalScore: 0),
      );
      final team2Id = await _activeDataSource.insertTeam(
        gameId,
        const Team(name: 'Team 2', totalScore: 0),
      );
      teams = [
        Team(id: team1Id, gameId: gameId, name: 'Team 1', totalScore: 0),
        Team(id: team2Id, gameId: gameId, name: 'Team 2', totalScore: 0),
      ];
    }

    return gameWithId.copyWith(teams: teams, rounds: const []);
  }

  @override
  Future<int> insertTeam(int gameId, Team team) =>
      _activeDataSource.insertTeam(gameId, team);

  @override
  Future<void> updateTeamName(int teamId, String newName) =>
      _activeDataSource.updateTeamName(teamId, newName);

  @override
  Future<void> updateTeamScore(int teamId, int newTotalScore) =>
      _activeDataSource.updateTeamScore(teamId, newTotalScore);

  @override
  Future<int> saveRound(int gameId, Round round) =>
      _activeDataSource.insertRound(gameId, round);

  @override
  Future<void> deleteRound(int roundId) =>
      _activeDataSource.deleteRound(roundId);

  @override
  Future<void> updateGamePointsToWin(int gameId, int pointsToWin) =>
      _activeDataSource.updatePointsToWin(gameId, pointsToWin);

  @override
  Future<void> updateGameActualRound(int gameId, int actualRound) =>
      _activeDataSource.updateActualRound(gameId, actualRound);

  @override
  Future<void> updateGameMyTeamIndex(int gameId, int? teamIndex) =>
      _activeDataSource.updateMyTeamIndex(gameId, teamIndex);

  @override
  Future<void> updateGameLiveCode(int gameId, String liveCode) =>
      _activeDataSource.updateLiveCode(gameId, liveCode);

  @override
  Future<void> updateTeamPlayers(
    int teamId,
    String? player1,
    String? player2,
  ) => _activeDataSource.updateTeamPlayers(teamId, player1, player2);
}
