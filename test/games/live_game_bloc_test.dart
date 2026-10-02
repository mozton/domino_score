import 'package:dominos_score/features/games/domain/usecases/get_live_game_usecase.dart';
import 'package:dominos_score/features/games/presentation/bloc/live_game_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'live_game_fakes.dart';

void main() {
  late FakeLiveGameRepository repository;
  late LiveGameBloc bloc;

  setUp(() {
    repository = FakeLiveGameRepository();
    bloc = LiveGameBloc(getLiveGame: GetLiveGameUseCase(repository));
  });

  tearDown(() => bloc.close());

  Future<LiveGameState> waitFor(LiveGameStatus status) =>
      bloc.stream.firstWhere((state) => state.status == status);

  test('sin código no consulta y avisa al invitado', () async {
    bloc.add(const LiveGameWatched(code: '   '));

    await waitFor(LiveGameStatus.idle);
    expect(bloc.state.errorMessage, contains('código'));
    expect(repository.fetches, 0);
  });

  test('con un código inexistente avisa que no hay partida', () async {
    bloc.add(const LiveGameWatched(code: 'nope12'));

    await waitFor(LiveGameStatus.notFound);
    expect(bloc.state.code, 'NOPE12');
    expect(bloc.state.errorMessage, contains('NOPE12'));
    expect(bloc.state.liveGame, isNull);
  });

  test('pasa por loading y llega a loaded normalizando el código', () async {
    repository.games['ABC123'] = buildLiveGame();

    final statuses = <LiveGameStatus>[];
    final subscription = bloc.stream.listen((state) => statuses.add(state.status));

    bloc.add(const LiveGameWatched(code: '#abc123'));
    await waitFor(LiveGameStatus.loaded);

    expect(statuses, containsAllInOrder([
      LiveGameStatus.loading,
      LiveGameStatus.loaded,
    ]));
    expect(bloc.state.code, 'ABC123');
    expect(bloc.state.liveGame!.groupName, 'Los Tigres');
    expect(bloc.state.liveGame!.game.teams.first.totalScore, 25);
    expect(bloc.state.errorMessage, isNull);

    await subscription.cancel();
  });

  test('si falla la consulta queda en error y no revienta', () async {
    repository.error = Exception('sin red');

    bloc.add(const LiveGameWatched(code: 'ABC123'));

    await waitFor(LiveGameStatus.error);
    expect(bloc.state.errorMessage, contains('sin red'));
  });

  test('el refresco manual trae el marcador actualizado', () async {
    repository.games['ABC123'] = buildLiveGame(points: 25);
    bloc.add(const LiveGameWatched(code: 'ABC123'));
    await waitFor(LiveGameStatus.loaded);

    repository.games['ABC123'] = buildLiveGame(points: 60);
    bloc.add(const LiveGameRefreshed());

    final refreshed = await bloc.stream.firstWhere(
      (state) => state.liveGame?.game.teams.first.totalScore == 60,
    );
    expect(refreshed.status, LiveGameStatus.loaded);
  });

  test('si la partida desaparece pasa a notFound', () async {
    repository.games['ABC123'] = buildLiveGame();
    bloc.add(const LiveGameWatched(code: 'ABC123'));
    await waitFor(LiveGameStatus.loaded);

    repository.games.remove('ABC123');
    bloc.add(const LiveGameRefreshed());

    await waitFor(LiveGameStatus.notFound);
    expect(bloc.state.errorMessage, contains('ya no está disponible'));
  });

  test('se refresca sola cada pocos segundos (sin volver a escribir el código)',
      () async {
    repository.games['ABC123'] = buildLiveGame(points: 25);
    bloc.add(const LiveGameWatched(code: 'ABC123'));
    await waitFor(LiveGameStatus.loaded);

    expect(repository.fetches, 1);

    // El anfitrión anota puntos: el invitado debe verlos solos.
    repository.games['ABC123'] = buildLiveGame(points: 75);
    await Future<void>.delayed(const Duration(seconds: 6));

    expect(repository.fetches, greaterThan(1));
    expect(bloc.state.liveGame!.game.teams.first.totalScore, 75);
  }, timeout: const Timeout(Duration(seconds: 30)));

  group('volver a la última partida vista', () {
    late FakeLastLiveCodeStore store;
    late LiveGameBloc restored;

    setUp(() {
      store = FakeLastLiveCodeStore();
      restored = LiveGameBloc(
        getLiveGame: GetLiveGameUseCase(repository),
        lastLiveCodeStore: store,
      );
    });

    tearDown(() => restored.close());

    Future<LiveGameState> waitForStatus(LiveGameStatus status) =>
        restored.stream.firstWhere((state) => state.status == status);

    test('al abrir una partida se recuerda su código', () async {
      repository.games['ABC123'] = buildLiveGame();

      restored.add(const LiveGameWatched(code: '#abc123'));
      await waitForStatus(LiveGameStatus.loaded);

      expect(store.code, 'ABC123');
      expect(store.saves, 1);
    });

    test('la última partida vista se reabre sola', () async {
      store.code = 'ABC123';
      repository.games['ABC123'] = buildLiveGame(groupName: 'Los Tigres');

      restored.add(const LiveGameRestored());

      await waitForStatus(LiveGameStatus.loaded);
      expect(restored.state.liveGame!.groupName, 'Los Tigres');
      expect(restored.state.code, 'ABC123');
    });

    test('si la partida guardada ya no existe, deja el código escrito',
        () async {
      store.code = 'VIEJO1';

      restored.add(const LiveGameRestored());

      await waitForStatus(LiveGameStatus.idle);
      expect(restored.state.code, 'VIEJO1');
      expect(restored.state.liveGame, isNull);
      expect(restored.state.errorMessage, isNull);
    });

    test('sin nada guardado no consulta ni molesta', () async {
      restored.add(const LiveGameRestored());
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(restored.state.status, LiveGameStatus.idle);
      expect(restored.state.code, isNull);
      expect(repository.fetches, 0);
    });
  });
}
