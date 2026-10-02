import 'package:dominos_score/core/utils/code_generator.dart';
import 'package:dominos_score/features/games/data/repositories/live_game_repository_impl.dart';
import 'package:dominos_score/features/games/domain/entities/live_game_entity.dart';
import 'package:dominos_score/features/games/domain/entities/round_action.dart';
import 'package:dominos_score/features/games/domain/repositories/live_game_repository.dart';
import 'package:dominos_score/features/games/domain/usecases/generate_live_code_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

import 'live_game_fakes.dart';

void main() {
  group('CodeGenerator', () {
    test('genera 6 caracteres legibles en mayúscula', () {
      final codes = {for (var i = 0; i < 200; i++) CodeGenerator.generate()};

      for (final code in codes) {
        expect(code.length, 6);
        expect(RegExp(r'^[ABCDEFGHJKLMNPQRSTUVWXYZ23456789]{6}$').hasMatch(code),
            isTrue);
      }
      // 200 códigos aleatorios de 32^6 posibilidades: no deberían repetirse.
      expect(codes.length, 200);
    });

    test('respeta un largo distinto', () {
      expect(CodeGenerator.generate(4).length, 4);
    });
  });

  group('GenerateLiveCodeUseCase', () {
    test('reintenta cuando el código ya está en uso', () async {
      final repository = _CollidingLiveGameRepository(collisions: 2);

      final code = await GenerateLiveCodeUseCase(repository)();

      expect(code.length, 6);
      expect(repository.consultas, 3);
      expect(repository.codigosVistos.toSet().length, greaterThan(1));
    });

    test('si no se puede comprobar la unicidad igual devuelve un código',
        () async {
      final repository = FakeLiveGameRepository()
        ..error = Exception('sin red');

      final code = await GenerateLiveCodeUseCase(repository)();

      expect(code.length, 6);
      expect(RegExp(r'^[ABCDEFGHJKLMNPQRSTUVWXYZ23456789]{6}$').hasMatch(code),
          isTrue);
    });

    test('no se rinde si todos los intentos chocan', () async {
      final repository = _CollidingLiveGameRepository(collisions: 99);

      final code = await GenerateLiveCodeUseCase(repository)();

      expect(code.length, 6);
      expect(repository.consultas, GenerateLiveCodeUseCase.maxAttempts);
    });
  });

  group('LiveGameRepositoryImpl', () {
    late InMemoryFirestoreClient client;
    late LiveGameRepositoryImpl repository;

    setUp(() {
      client = InMemoryFirestoreClient();
      repository = LiveGameRepositoryImpl(
        client,
        FakeCurrentUserProvider('uid-anfitrion'),
      );
    });

    test('publica la partida en liveGames/{code} con equipos y rondas', () async {
      await repository.publish(_liveGame('ABC123'));

      final document = client.documents['liveGames/ABC123'];
      expect(document, isNotNull);
      expect(document!['hostId'], 'uid-anfitrion');
      expect(document['groupId'], 'grupo-1');
      expect(document['groupName'], 'Los Tigres');
      expect(document['gameId'], 7);
      expect(document['pointsToWin'], 100);
      expect(document['winnerTeamName'], isNull);
      expect((document['teams'] as List).length, 2);
      expect((document['teams'] as List).first['player1'], 'Ana');
      expect((document['rounds'] as List).length, 1);
      expect((document['rounds'] as List).first['team1Points'], 15);
      expect(
        (document['rounds'] as List).first['events'],
        [
          {'type': 'capicua', 'teamIndex': 0, 'playerName': 'Ana'},
        ],
      );
    });

    test('devuelve la partida publicada y normaliza el código', () async {
      await repository.publish(_liveGame('ABC123'));

      for (final entrada in ['ABC123', 'abc123', '#ABC123', ' ABC123 ']) {
        final live = await repository.getByCode(entrada);
        expect(live, isNotNull, reason: 'código "$entrada"');
        expect(live!.code, 'ABC123');
        expect(live.groupName, 'Los Tigres');
        expect(live.game.id, 7);
        expect(live.game.teams.map((t) => t.name), ['Team 1', 'Team 2']);
        expect(live.game.teams.first.totalScore, 25);
        expect(live.game.rounds.single.pointsFor(0), 15);
        expect(live.game.rounds.single.pointsFor(1), 10);
        expect(live.game.rounds.single.events.single.type, RoundActionType.capicua);
        expect(live.game.rounds.single.events.single.playerName, 'Ana');
      }
    });

    test('devuelve null cuando el código no existe o está vacío', () async {
      expect(await repository.getByCode('ZZZZZZ'), isNull);
      expect(await repository.getByCode('   '), isNull);
      expect(await repository.getByCode('#'), isNull);
    });

    test('volver a publicar actualiza el mismo documento', () async {
      await repository.publish(_liveGame('ABC123'));
      await repository.publish(_liveGame('ABC123', points: 30));

      expect(client.documents.length, 1);
      final live = await repository.getByCode('ABC123');
      expect(live!.game.teams.first.totalScore, 30);
    });
  });
}

LiveGame _liveGame(String code, {int points = 25}) =>
    buildLiveGame(code: code, points: points);

/// Repositorio que dice "ocupado" las primeras [collisions] consultas.
class _CollidingLiveGameRepository implements LiveGameRepository {
  _CollidingLiveGameRepository({required this.collisions});

  final int collisions;
  int consultas = 0;
  final List<String> codigosVistos = [];

  @override
  Future<LiveGame?> getByCode(String code) async {
    consultas++;
    codigosVistos.add(code);
    return consultas <= collisions ? buildLiveGame(code: code) : null;
  }

  @override
  Future<void> publish(LiveGame liveGame) async {}
}
