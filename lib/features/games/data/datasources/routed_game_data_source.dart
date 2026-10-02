import 'package:dominos_score/features/games/data/datasources/game_data_source.dart';
import 'package:dominos_score/features/games/domain/entities/game_entity.dart';
import 'package:dominos_score/features/games/domain/entities/round_entity.dart';
import 'package:dominos_score/features/games/domain/entities/team_entity.dart';
import 'package:dominos_score/features/games/domain/game_scope.dart';

/// Delega las operaciones al origen de datos del alcance activo: local (Drift)
/// o el grupo seleccionado (Firestore).
class RoutedGameDataSource implements GameDataSource {
  final GameDataSource _local;
  final GameDataSource Function(String groupId) _groupFactory;
  final GameScope _scope;

  final Map<String, GameDataSource> _groupCache = {};

  RoutedGameDataSource({
    required GameDataSource local,
    required GameDataSource Function(String groupId) groupFactory,
    required GameScope scope,
  }) : _local = local,
       _groupFactory = groupFactory,
       _scope = scope;

  /// Origen de datos de un grupo concreto (cacheado por grupo).
  GameDataSource groupDataSource(String groupId) =>
      _groupCache.putIfAbsent(groupId, () => _groupFactory(groupId));

  GameDataSource get _active {
    final groupId = _scope.groupId;
    if (groupId == null) return _local;
    return groupDataSource(groupId);
  }

  @override
  Future<int> createGame(Game game) => _active.createGame(game);

  @override
  Future<void> updatePointsToWin(int gameId, int pointsToWin) =>
      _active.updatePointsToWin(gameId, pointsToWin);

  @override
  Future<void> updateActualRound(int gameId, int actualRound) =>
      _active.updateActualRound(gameId, actualRound);

  @override
  Future<void> updateMyTeamIndex(int gameId, int? teamIndex) =>
      _active.updateMyTeamIndex(gameId, teamIndex);

  @override
  Future<void> updateLiveCode(int gameId, String liveCode) =>
      _active.updateLiveCode(gameId, liveCode);

  @override
  Future<int> insertTeam(int gameId, Team team) =>
      _active.insertTeam(gameId, team);

  @override
  Future<void> updateTeamName(int teamId, String newName) =>
      _active.updateTeamName(teamId, newName);

  @override
  Future<void> updateTeamScore(int teamId, int newTotalScore) =>
      _active.updateTeamScore(teamId, newTotalScore);

  @override
  Future<int> insertRound(int gameId, Round round) =>
      _active.insertRound(gameId, round);

  @override
  Future<void> deleteRound(int roundId) => _active.deleteRound(roundId);

  @override
  Future<List<Game>> getGames() => _active.getGames();

  @override
  Future<Game?> getGameById(int gameId) => _active.getGameById(gameId);
}
