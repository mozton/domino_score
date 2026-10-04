import 'package:dominos_score/core/network/auth_token_provider.dart';
import 'package:dominos_score/core/network/current_user_provider.dart';
import 'package:dominos_score/core/network/firestore_rest_client.dart';
import 'package:dominos_score/features/games/data/datasources/last_live_code_store.dart';
import 'package:dominos_score/features/games/domain/entities/game_entity.dart';
import 'package:dominos_score/features/games/domain/entities/live_game_entity.dart';
import 'package:dominos_score/features/games/domain/entities/round_action.dart';
import 'package:dominos_score/features/games/domain/entities/round_entity.dart';
import 'package:dominos_score/features/games/domain/entities/team_entity.dart';
import 'package:dominos_score/features/games/domain/repositories/game_repository.dart';
import 'package:dominos_score/features/games/domain/repositories/live_game_repository.dart';
import 'package:dominos_score/features/settings/domain/entities/theme_mode_option.dart';
import 'package:dominos_score/features/settings/domain/repositories/settings_repository.dart';

/// Dobles de prueba compartidos por los tests de la partida en vivo.

class FakeAuthTokenProvider implements AuthTokenProvider {
  @override
  Future<String?> getToken() async => 'token-de-prueba';

  @override
  Future<String?> refreshToken() async => 'token-de-prueba';
}

class FakeCurrentUserProvider implements CurrentUserProvider {
  FakeCurrentUserProvider([this.uid = 'uid-anfitrion']);

  final String uid;

  @override
  Future<String?> currentUserId() async => uid;
}

/// Cliente de Firestore en memoria: guarda los documentos por ruta.
class InMemoryFirestoreClient extends FirestoreRestClient {
  InMemoryFirestoreClient() : super(tokenProvider: FakeAuthTokenProvider());

  final Map<String, Map<String, dynamic>> documents = {};

  @override
  Future<FirestoreDocument> setDocument(
    String documentPath,
    Map<String, dynamic> data,
  ) async {
    final merged = {...?documents[documentPath], ...data};
    documents[documentPath] = merged;
    return FirestoreDocument(
      id: documentPath.split('/').last,
      data: merged,
    );
  }

  @override
  Future<FirestoreDocument?> getDocument(String documentPath) async {
    final data = documents[documentPath];
    if (data == null) return null;
    return FirestoreDocument(id: documentPath.split('/').last, data: data);
  }
}

/// Almacén en memoria del último código de partida en vivo visto.
class FakeLastLiveCodeStore implements LastLiveCodeStore {
  FakeLastLiveCodeStore([this.code]);

  String? code;
  int saves = 0;

  @override
  Future<String?> read() async => code;

  @override
  Future<void> save(String value) async {
    saves++;
    code = value;
  }

  @override
  Future<void> clear() async => code = null;
}

class FakeLiveGameRepository implements LiveGameRepository {
  final Map<String, LiveGame> games = {};

  /// Cuántas veces se pidió una partida (para comprobar el auto-refresco).
  int fetches = 0;

  /// Si se define, [getByCode] lanza este error (prueba de fallo de red).
  Object? error;

  /// Si se define, [publish] lanza este error (Firestore caído, sin permisos).
  Object? publishError;

  @override
  Future<void> publish(LiveGame liveGame) async {
    final failure = publishError;
    if (failure != null) throw failure;
    games[liveGame.code] = liveGame;
  }

  @override
  Future<LiveGame?> getByCode(String code) async {
    fetches++;
    final failure = error;
    if (failure != null) throw failure;
    final normalized = code.trim().replaceAll('#', '').toUpperCase();
    return games[normalized];
  }
}

/// Partida en vivo de ejemplo (2 equipos, 1 ronda con una capicúa).
LiveGame buildLiveGame({
  String code = 'ABC123',
  String groupId = 'grupo-1',
  String groupName = 'Los Tigres',
  int points = 25,
  String? winnerTeamName,
  int roundNumber = 1,
}) {
  return LiveGame(
    code: code,
    groupId: groupId,
    groupName: groupName,
    updatedAt: DateTime(2024, 5, 1, 20, 30),
    game: Game(
      id: 7,
      actualRound: roundNumber,
      pointsToWin: 100,
      createdAt: DateTime(2024, 5, 1, 20),
      winnerTeamName: winnerTeamName,
      teams: [
        Team(
          id: 1,
          gameId: 7,
          name: 'Team 1',
          player1: 'Ana',
          player2: 'Luis',
          totalScore: points,
        ),
        const Team(id: 2, gameId: 7, name: 'Team 2', totalScore: 10),
      ],
      rounds: [
        Round(
          id: 1,
          gameId: 7,
          number: 1,
          team1Points: 15,
          team2Points: 10,
          events: const [
            RoundEvent(
              type: RoundActionType.capicua,
              teamIndex: 0,
              playerName: 'Ana',
            ),
          ],
        ),
      ],
    ),
  );
}

class FakeSettingsRepository implements SettingsRepository {
  FakeSettingsRepository({this.pointToWin = 100, this.modeName = 'teams2v2'});

  int pointToWin;
  String modeName;

  @override
  Future<String?> getGameModeName() async => modeName;

  @override
  Future<int?> getPointToWin() async => pointToWin;

  @override
  Future<ThemeModeOption?> getThemeMode() async => null;

  @override
  Future<void> saveGameModeName(String value) async => modeName = value;

  @override
  Future<void> savePointToWin(int value) async => pointToWin = value;

  @override
  Future<void> saveThemeMode(ThemeModeOption value) async {}
}

/// Repositorio de partidas en memoria (local y de grupo, da igual: es un fake).
class FakeGameRepository implements GameRepository {
  final Map<int, Game> _games = {};
  final Map<int, Round> _rounds = {};

  /// Código en vivo guardado por partida (para comprobar que se persiste).
  final Map<int, String> liveCodes = {};

  int _nextGameId = 1;
  int _nextTeamId = 100;
  int _nextRoundId = 1000;

  Game? gameById(int id) => _games[id];

  @override
  Future<List<Game>> fetchActiveGames() async {
    final ids = _games.keys.toList()..sort();
    final games = <Game>[];
    for (final id in ids) {
      final game = await fetchGameById(id);
      if (game != null) games.add(game);
    }
    return games;
  }

  @override
  Future<List<Game>> fetchLocalGames() => fetchActiveGames();

  @override
  Future<List<Game>> fetchGroupGames(String groupId) => fetchActiveGames();

  @override
  Future<Game?> fetchGameById(int gameId) async {
    final game = _games[gameId];
    if (game == null) return null;
    final rounds = _rounds.values.where((r) => r.gameId == gameId).toList()
      ..sort((a, b) => a.number.compareTo(b.number));
    return game.copyWith(rounds: rounds);
  }

  @override
  Future<int> saveGame(Game game) async {
    final id = _nextGameId++;
    _games[id] = game.copyWith(id: id);
    return id;
  }

  @override
  Future<Game> createGameWithDefaultTeams(Game game) async {
    final id = _nextGameId++;
    final base = game.teams.isEmpty
        ? const [
            Team(name: 'Team 1', totalScore: 0),
            Team(name: 'Team 2', totalScore: 0),
          ]
        : game.teams;
    final teams = [
      for (final team in base) team.copyWith(id: _nextTeamId++, gameId: id),
    ];
    final saved = game.copyWith(id: id, teams: teams, rounds: const []);
    _games[id] = saved;
    return saved;
  }

  @override
  Future<int> insertTeam(int gameId, Team team) async {
    final id = _nextTeamId++;
    final game = _games[gameId]!;
    _games[gameId] = game.copyWith(
      teams: [...game.teams, team.copyWith(id: id, gameId: gameId)],
    );
    return id;
  }

  @override
  Future<void> updateTeamName(int teamId, String newName) async {
    _mutateTeam(teamId, (team) => team.copyWith(name: newName));
  }

  @override
  Future<void> updateTeamScore(int teamId, int newTotalScore) async {
    _mutateTeam(teamId, (team) => team.copyWith(totalScore: newTotalScore));
  }

  @override
  Future<void> updateTeamPlayers(
    int teamId,
    String? player1,
    String? player2,
  ) async {
    _mutateTeam(
      teamId,
      (team) => Team(
        id: team.id,
        gameId: team.gameId,
        name: team.name,
        player1: player1,
        player2: player2,
        totalScore: team.totalScore,
      ),
    );
  }

  @override
  Future<int> saveRound(int gameId, Round round) async {
    final id = _nextRoundId++;
    _rounds[id] = round.copyWith(id: id, gameId: gameId);
    return id;
  }

  @override
  Future<void> deleteRound(int roundId) async {
    _rounds.remove(roundId);
  }

  @override
  Future<void> updateGamePointsToWin(int gameId, int pointsToWin) async {
    final game = _games[gameId]!;
    _games[gameId] = game.copyWith(pointsToWin: pointsToWin);
  }

  @override
  Future<void> updateGameActualRound(int gameId, int actualRound) async {
    final game = _games[gameId]!;
    _games[gameId] = game.copyWith(actualRound: actualRound);
  }

  @override
  Future<void> updateGameMyTeamIndex(int gameId, int? teamIndex) async {
    final game = _games[gameId]!;
    _games[gameId] = _rebuild(game, myTeamIndex: teamIndex);
  }

  @override
  Future<void> updateGameLiveCode(int gameId, String liveCode) async {
    final game = _games[gameId]!;
    liveCodes[gameId] = liveCode;
    _games[gameId] = _rebuild(game, liveCode: liveCode);
  }

  void _mutateTeam(int teamId, Team Function(Team) update) {
    for (final entry in _games.entries.toList()) {
      final teams = entry.value.teams;
      if (!teams.any((team) => team.id == teamId)) continue;
      _games[entry.key] = entry.value.copyWith(
        teams: [
          for (final team in teams)
            if (team.id == teamId) update(team) else team,
        ],
      );
      return;
    }
  }

  /// `copyWith` no puede limpiar `myTeamIndex`, así que se reconstruye.
  Game _rebuild(Game game, {int? myTeamIndex, String? liveCode}) {
    return Game(
      id: game.id,
      actualRound: game.actualRound,
      pointsToWin: game.pointsToWin,
      createdAt: game.createdAt,
      winnerTeamName: game.winnerTeamName,
      teams: game.teams,
      rounds: game.rounds,
      myTeamIndex: myTeamIndex,
      liveCode: liveCode ?? game.liveCode,
    );
  }
}
