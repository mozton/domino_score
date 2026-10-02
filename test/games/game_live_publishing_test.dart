import 'package:dominos_score/features/games/domain/entities/game_entity.dart';
import 'package:dominos_score/features/games/domain/entities/game_mode.dart';
import 'package:dominos_score/features/games/domain/entities/round_action.dart';
import 'package:dominos_score/features/games/domain/game_scope.dart';
import 'package:dominos_score/features/games/domain/usecases/add_round_usecase.dart';
import 'package:dominos_score/features/games/domain/usecases/delete_round_usecase.dart';
import 'package:dominos_score/features/games/domain/usecases/generate_live_code_usecase.dart';
import 'package:dominos_score/features/games/domain/usecases/init_game_usecase.dart';
import 'package:dominos_score/features/games/domain/usecases/load_games_usecase.dart';
import 'package:dominos_score/features/games/domain/usecases/publish_live_game_usecase.dart';
import 'package:dominos_score/features/games/domain/usecases/rename_team_usecase.dart';
import 'package:dominos_score/features/games/domain/usecases/save_live_code_usecase.dart';
import 'package:dominos_score/features/games/domain/usecases/set_my_team_usecase.dart';
import 'package:dominos_score/features/games/domain/usecases/start_new_game_usecase.dart';
import 'package:dominos_score/features/games/domain/usecases/start_new_game_with_teams_usecase.dart';
import 'package:dominos_score/features/games/domain/usecases/update_points_to_win_usecase.dart';
import 'package:dominos_score/features/games/presentation/bloc/game_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'live_game_fakes.dart';

/// Comprueba que el marcador publica la partida de grupo en `liveGames/{code}`.
void main() {
  late FakeGameRepository games;
  late FakeLiveGameRepository live;
  late FakeSettingsRepository settings;
  late GameScope scope;
  late GameBloc bloc;

  setUp(() {
    games = FakeGameRepository();
    live = FakeLiveGameRepository();
    settings = FakeSettingsRepository();
    scope = GameScope();
    bloc = GameBloc(
      initGame: InitGameUseCase(games),
      loadGames: LoadGamesUseCase(games),
      startNewGame: StartNewGameUseCase(games),
      startNewGameWithTeams: StartNewGameWithTeamsUseCase(games),
      addRound: AddRoundUseCase(games),
      deleteRound: DeleteRoundUseCase(games),
      renameTeam: RenameTeamUseCase(games),
      setMyTeam: SetMyTeamUseCase(games),
      updatePointsToWin: UpdatePointsToWinUseCase(games),
      publishLiveGame: PublishLiveGameUseCase(live),
      saveLiveCode: SaveLiveCodeUseCase(games),
      generateLiveCode: GenerateLiveCodeUseCase(live),
      settingsRepository: settings,
      scope: scope,
    );
  });

  tearDown(() => bloc.close());

  Future<GameState> waitForGame() =>
      bloc.stream.firstWhere((state) => state.currentGame != null);

  test('al iniciar una partida de grupo genera un código y la publica',
      () async {
    bloc.add(
      const GameInitialized(groupId: 'grupo-1', groupName: 'Los Tigres'),
    );
    final state = await waitForGame();

    final game = state.currentGame!;
    final code = game.liveCode;
    expect(code, isNotNull);
    expect(
      RegExp(r'^[ABCDEFGHJKLMNPQRSTUVWXYZ23456789]{6}$').hasMatch(code!),
      isTrue,
      reason: 'código generado: $code',
    );
    // El código queda guardado en la partida (no cambia en cada apertura).
    expect(games.gameById(game.id!)!.liveCode, code);
    // Y se publica la vista en vivo con su grupo.
    expect(live.games.keys, [code]);
    final published = live.games[code]!;
    expect(published.groupId, 'grupo-1');
    expect(published.groupName, 'Los Tigres');
    expect(published.game.id, game.id);
    expect(published.game.teams.length, 2);
  });

  test('una partida local no genera código ni se publica', () async {
    bloc.add(const GameInitialized());
    final state = await waitForGame();

    expect(state.currentGame!.liveCode, isNull);
    expect(live.games, isEmpty);
    expect(games.liveCodes, isEmpty);
  });

  test('el botón Nueva Partida del grupo crea una partida nueva con código',
      () async {
    bloc.add(
      const GroupGameStarted(
        groupId: 'grupo-7',
        groupName: 'Los Bravos',
        mode: GameMode.teams2v2,
      ),
    );
    final state = await waitForGame();

    final code = state.currentGame!.liveCode;
    expect(code, isNotNull);
    expect(live.games.length, 1);
    expect(live.games[code]!.groupName, 'Los Bravos');
    expect(live.games[code]!.game.teams.length, 2);
  });

  test('una partida de grupo antigua (sin código) recibe uno y se guarda',
      () async {
    // Partida creada por una versión anterior de la app: sin liveCode.
    final old = await games.createGameWithDefaultTeams(
      Game(
        actualRound: 0,
        pointsToWin: 100,
        createdAt: DateTime(2024, 1, 1),
        teams: GameMode.teams2v2.buildDefaultTeams(),
      ),
    );
    expect(old.liveCode, isNull);

    bloc.add(
      const GameInitialized(groupId: 'grupo-1', groupName: 'Los Tigres'),
    );
    final state = await waitForGame();

    final code = state.currentGame!.liveCode;
    expect(code, isNotNull);
    expect(games.liveCodes[old.id], code);
    expect(live.games[code!]!.game.id, old.id);
  });

  test('cada ronda anotada se publica en vivo con sus acciones', () async {
    bloc.add(
      const GameInitialized(groupId: 'grupo-1', groupName: 'Los Tigres'),
    );
    final started = await waitForGame();
    final code = started.currentGame!.liveCode!;

    bloc.add(
      const RoundAdded(
        teamPoints: [15, 10],
        events: [
          RoundEvent(
            type: RoundActionType.capicua,
            teamIndex: 0,
            playerName: 'Ana',
          ),
        ],
      ),
    );
    await bloc.stream.firstWhere(
      (state) => state.currentGame!.rounds.isNotEmpty,
    );

    final published = live.games[code]!.game;
    expect(published.rounds.single.pointsFor(0), 15);
    expect(published.rounds.single.pointsFor(1), 10);
    expect(published.teams.first.totalScore, 15);
    expect(published.rounds.single.events.single.type, RoundActionType.capicua);
    expect(published.rounds.single.events.single.playerName, 'Ana');
    expect(published.actualRound, 1);
  });

  test('si Firestore falla al publicar, el marcador sigue funcionando',
      () async {
    live.publishError = Exception('permisos denegados');

    bloc.add(
      const GameInitialized(groupId: 'grupo-1', groupName: 'Los Tigres'),
    );
    final started = await waitForGame();
    expect(started.currentGame, isNotNull);
    expect(live.games, isEmpty);

    bloc.add(const RoundAdded(teamPoints: [20, 5]));
    final afterRound = await bloc.stream.firstWhere(
      (state) => state.currentGame!.rounds.isNotEmpty,
    );

    expect(afterRound.currentGame!.teams.first.totalScore, 20);
    expect(afterRound.errorMessage, isNull);
  });
}
