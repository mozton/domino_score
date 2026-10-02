import 'package:dominos_score/core/network/current_user_provider.dart';
import 'package:dominos_score/core/network/firestore_rest_client.dart';
import 'package:dominos_score/features/games/domain/entities/game_entity.dart';
import 'package:dominos_score/features/games/domain/entities/live_game_entity.dart';
import 'package:dominos_score/features/games/domain/entities/round_action.dart';
import 'package:dominos_score/features/games/domain/entities/round_entity.dart';
import 'package:dominos_score/features/games/domain/entities/team_entity.dart';
import 'package:dominos_score/features/games/domain/repositories/live_game_repository.dart';

/// Publica y lee la vista en vivo de una partida en `liveGames/{code}`.
class LiveGameRepositoryImpl implements LiveGameRepository {
  static const _collection = 'liveGames';

  final FirestoreRestClient _client;
  final CurrentUserProvider _currentUser;
  String? _cachedUid;

  LiveGameRepositoryImpl(this._client, this._currentUser);

  Future<String> _uid() async {
    final cached = _cachedUid;
    if (cached != null) return cached;
    final uid = await _currentUser.currentUserId() ?? '';
    _cachedUid = uid;
    return uid;
  }

  @override
  Future<void> publish(LiveGame liveGame) async {
    final game = liveGame.game;
    await _client.setDocument('$_collection/${liveGame.code}', {
      'hostId': await _uid(),
      'groupId': liveGame.groupId,
      'groupName': liveGame.groupName,
      'gameId': game.id,
      'pointsToWin': game.pointsToWin,
      'actualRound': game.actualRound,
      'createdAt': game.createdAt,
      'winnerTeamName': game.winnerTeamName,
      'updatedAt': DateTime.now(),
      'teams': game.teams
          .map(
            (team) => {
              'name': team.name,
              'player1': team.player1,
              'player2': team.player2,
              'totalScore': team.totalScore,
            },
          )
          .toList(),
      'rounds': game.rounds
          .map(
            (round) => {
              'number': round.number,
              'team1Points': round.team1Points,
              'team2Points': round.team2Points,
              'team3Points': round.team3Points,
              'team4Points': round.team4Points,
              'events': round.events.map((event) => event.toMap()).toList(),
            },
          )
          .toList(),
    });
  }

  @override
  Future<LiveGame?> getByCode(String code) async {
    final normalized = code.trim().replaceAll('#', '').toUpperCase();
    if (normalized.isEmpty) return null;

    final doc = await _client.getDocument('$_collection/$normalized');
    if (doc == null) return null;
    return _fromSnapshot(doc.id, doc.data);
  }

  LiveGame _fromSnapshot(String code, Map<String, dynamic> data) {
    final teams = data['teams'];
    final rounds = data['rounds'];
    final createdAt = data['createdAt'];
    final updatedAt = data['updatedAt'];

    return LiveGame(
      code: code,
      groupId: data['groupId'] as String? ?? '',
      groupName: data['groupName'] as String? ?? 'Grupo',
      updatedAt: updatedAt is DateTime ? updatedAt : DateTime.now(),
      game: Game(
        id: (data['gameId'] as num?)?.toInt(),
        actualRound: (data['actualRound'] as num?)?.toInt() ?? 0,
        pointsToWin: (data['pointsToWin'] as num?)?.toInt() ?? 0,
        createdAt: createdAt is DateTime ? createdAt : DateTime.now(),
        winnerTeamName: data['winnerTeamName'] as String?,
        teams: teams is List
            ? teams
                  .map(
                    (item) => _teamFrom(Map<String, dynamic>.from(item as Map)),
                  )
                  .toList()
            : const [],
        rounds: rounds is List
            ? rounds
                  .map(
                    (item) => _roundFrom(
                      Map<String, dynamic>.from(item as Map),
                    ),
                  )
                  .toList()
            : const [],
      ),
    );
  }

  Team _teamFrom(Map<String, dynamic> data) {
    return Team(
      name: data['name'] as String? ?? '',
      player1: data['player1'] as String?,
      player2: data['player2'] as String?,
      totalScore: (data['totalScore'] as num?)?.toInt() ?? 0,
    );
  }

  Round _roundFrom(Map<String, dynamic> data) {
    final events = data['events'];
    return Round(
      number: (data['number'] as num?)?.toInt() ?? 0,
      team1Points: (data['team1Points'] as num?)?.toInt() ?? 0,
      team2Points: (data['team2Points'] as num?)?.toInt() ?? 0,
      team3Points: (data['team3Points'] as num?)?.toInt(),
      team4Points: (data['team4Points'] as num?)?.toInt(),
      events: events is List
          ? events
                .map(
                  (item) =>
                      RoundEvent.fromMap(Map<String, dynamic>.from(item as Map)),
                )
                .toList()
          : const [],
    );
  }
}
