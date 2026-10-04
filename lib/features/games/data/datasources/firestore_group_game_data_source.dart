import 'package:dominos_score/core/network/firestore_rest_client.dart';
import 'package:dominos_score/core/utils/numeric_id_generator.dart';
import 'package:dominos_score/features/games/data/datasources/game_data_source.dart';
import 'package:dominos_score/features/games/domain/entities/game_entity.dart';
import 'package:dominos_score/features/games/domain/entities/round_action.dart';
import 'package:dominos_score/features/games/domain/entities/round_entity.dart';
import 'package:dominos_score/features/games/domain/entities/team_entity.dart';

/// Partidas de un grupo guardadas en Firestore.
///
/// Rutas usadas (una sola lectura por colección al listar):
///  - `groups/{groupId}/games/{gameId}`
///  - `groups/{groupId}/teams/{teamId}`   (campo `gameId`)
///  - `groups/{groupId}/rounds/{roundId}` (campo `gameId`)
///
/// Los ids de documento son numéricos para conservar el tipo `int` del dominio.
class FirestoreGroupGameDataSource implements GameDataSource {
  final FirestoreRestClient _client;
  final String groupId;

  FirestoreGroupGameDataSource(this._client, this.groupId);

  String get _gamesPath => 'groups/$groupId/games';
  String get _teamsPath => 'groups/$groupId/teams';
  String get _roundsPath => 'groups/$groupId/rounds';
  String get _parentPath => 'groups/$groupId';

  int _intId(String docId) => int.tryParse(docId) ?? 0;

  // ============================ GAMES ============================

  @override
  Future<int> createGame(Game game) async {
    final id = NumericIdGenerator.next();
    await _client.setDocument('$_gamesPath/$id', {
      'actualRound': game.actualRound,
      'pointsToWin': game.pointsToWin,
      'createdAt': game.createdAt,
      'winnerTeamName': game.winnerTeamName,
      'myTeamIndex': game.myTeamIndex,
      'liveCode': game.liveCode,
    });
    return id;
  }

  @override
  Future<void> updatePointsToWin(int gameId, int pointsToWin) =>
      _client.setDocument('$_gamesPath/$gameId', {'pointsToWin': pointsToWin});

  @override
  Future<void> updateActualRound(int gameId, int actualRound) =>
      _client.setDocument('$_gamesPath/$gameId', {'actualRound': actualRound});

  @override
  Future<void> updateMyTeamIndex(int gameId, int? teamIndex) =>
      _client.setDocument('$_gamesPath/$gameId', {'myTeamIndex': teamIndex});

  @override
  Future<void> updateLiveCode(int gameId, String liveCode) =>
      _client.setDocument('$_gamesPath/$gameId', {'liveCode': liveCode});

  @override
  Future<Game?> getGameById(int gameId) async {
    final doc = await _client.getDocument('$_gamesPath/$gameId');
    if (doc == null) return null;

    final teamDocs = await _client.runQuery(
      collectionId: 'teams',
      where: FirestoreFilter.equal('gameId', gameId),
      parentPath: _parentPath,
    );
    final roundDocs = await _client.runQuery(
      collectionId: 'rounds',
      where: FirestoreFilter.equal('gameId', gameId),
      parentPath: _parentPath,
    );

    return _gameFrom(
      doc,
      teamDocs.map(_teamFrom).toList(),
      roundDocs.map(_roundFrom).toList(),
    );
  }

  @override
  Future<List<Game>> getGames() async {
    final gameDocs = await _client.listDocuments(_gamesPath);
    if (gameDocs.isEmpty) return const [];

    final teamDocs = await _client.listDocuments(_teamsPath);
    final roundDocs = await _client.listDocuments(_roundsPath);

    final teamsByGame = <int, List<Team>>{};
    for (final doc in teamDocs) {
      final team = _teamFrom(doc);
      if (team.gameId == null) continue;
      teamsByGame.putIfAbsent(team.gameId!, () => []).add(team);
    }
    for (final teams in teamsByGame.values) {
      teams.sort((a, b) => (a.id ?? 0).compareTo(b.id ?? 0));
    }

    final roundsByGame = <int, List<Round>>{};
    for (final doc in roundDocs) {
      final round = _roundFrom(doc);
      if (round.gameId == null) continue;
      roundsByGame.putIfAbsent(round.gameId!, () => []).add(round);
    }
    for (final rounds in roundsByGame.values) {
      rounds.sort((a, b) => a.number.compareTo(b.number));
    }

    final games = gameDocs.map((doc) {
      final id = _intId(doc.id);
      return _gameFrom(
        doc,
        teamsByGame[id] ?? const [],
        roundsByGame[id] ?? const [],
      );
    }).toList();

    games.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return games;
  }

  // ============================ TEAMS ============================

  @override
  Future<int> insertTeam(int gameId, Team team) async {
    final id = NumericIdGenerator.next();
    await _client.setDocument('$_teamsPath/$id', {
      'gameId': gameId,
      'name': team.name,
      'player1': team.player1,
      'player2': team.player2,
      'totalScore': team.totalScore,
    });
    return id;
  }

  @override
  Future<void> updateTeamName(int teamId, String newName) =>
      _client.setDocument('$_teamsPath/$teamId', {'name': newName});

  @override
  Future<void> updateTeamScore(int teamId, int newTotalScore) =>
      _client.setDocument('$_teamsPath/$teamId', {'totalScore': newTotalScore});

  @override
  Future<void> updateTeamPlayers(
    int teamId,
    String? player1,
    String? player2,
  ) => _client.setDocument('$_teamsPath/$teamId', {
    'player1': player1,
    'player2': player2,
  });

  // ============================ ROUNDS ============================

  @override
  Future<int> insertRound(int gameId, Round round) async {
    final id = NumericIdGenerator.next();
    await _client.setDocument('$_roundsPath/$id', {
      'gameId': gameId,
      'number': round.number,
      'team1Points': round.team1Points,
      'team2Points': round.team2Points,
      'team3Points': round.team3Points,
      'team4Points': round.team4Points,
      'events': round.events.map((event) => event.toMap()).toList(),
    });
    return id;
  }

  @override
  Future<void> deleteRound(int roundId) =>
      _client.deleteDocument('$_roundsPath/$roundId');

  // =========================== MAPPERS ===========================

  Team _teamFrom(FirestoreDocument doc) {
    final data = doc.data;
    return Team(
      id: _intId(doc.id),
      gameId: (data['gameId'] as num?)?.toInt(),
      name: data['name'] as String? ?? '',
      player1: data['player1'] as String?,
      player2: data['player2'] as String?,
      totalScore: (data['totalScore'] as num?)?.toInt() ?? 0,
    );
  }

  Round _roundFrom(FirestoreDocument doc) {
    final data = doc.data;
    final events = data['events'];
    return Round(
      id: _intId(doc.id),
      gameId: (data['gameId'] as num?)?.toInt(),
      number: (data['number'] as num?)?.toInt() ?? 0,
      team1Points: (data['team1Points'] as num?)?.toInt() ?? 0,
      team2Points: (data['team2Points'] as num?)?.toInt() ?? 0,
      team3Points: (data['team3Points'] as num?)?.toInt(),
      team4Points: (data['team4Points'] as num?)?.toInt(),
      events: events is List
          ? events
                .map(
                  (item) => RoundEvent.fromMap(
                    Map<String, dynamic>.from(item as Map),
                  ),
                )
                .toList()
          : const [],
    );
  }

  Game _gameFrom(
    FirestoreDocument doc,
    List<Team> teams,
    List<Round> rounds,
  ) {
    final data = doc.data;
    final createdAt = data['createdAt'];
    return Game(
      id: _intId(doc.id),
      actualRound: (data['actualRound'] as num?)?.toInt() ?? 0,
      pointsToWin: (data['pointsToWin'] as num?)?.toInt() ?? 0,
      createdAt: createdAt is DateTime ? createdAt : DateTime.now(),
      winnerTeamName: data['winnerTeamName'] as String?,
      myTeamIndex: (data['myTeamIndex'] as num?)?.toInt(),
      liveCode: data['liveCode'] as String?,
      teams: teams,
      rounds: rounds,
    );
  }
}
