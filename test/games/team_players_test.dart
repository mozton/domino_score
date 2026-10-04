import 'package:dominos_score/features/games/domain/entities/game_mode.dart';
import 'package:dominos_score/features/games/domain/usecases/start_new_game_usecase.dart';
import 'package:dominos_score/features/games/presentation/widgets/team_players_dialog.dart';
import 'package:dominos_score/features/groups/domain/entities/group_member_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'live_game_fakes.dart';

GroupMember _member(String name) => GroupMember(
  userId: name.toLowerCase(),
  displayName: name,
  nickname: name.toLowerCase(),
  joinedAt: DateTime(2024, 1, 1),
);

void main() {
  group('los equipos arrancan con los miembros del grupo', () {
    late FakeGameRepository repository;
    late StartNewGameUseCase startNewGame;

    setUp(() {
      repository = FakeGameRepository();
      startNewGame = StartNewGameUseCase(repository);
    });

    test('en parejas se reparten dos por equipo', () async {
      final game = await startNewGame(
        pointsToWin: 100,
        mode: GameMode.teams2v2,
        playerNames: const ['Ana', 'Luis', 'Pedro', 'Marta'],
      );

      expect(game.teams[0].player1, 'Ana');
      expect(game.teams[0].player2, 'Luis');
      expect(game.teams[1].player1, 'Pedro');
      expect(game.teams[1].player2, 'Marta');
    });

    test('si faltan miembros el puesto queda por defecto', () async {
      final game = await startNewGame(
        pointsToWin: 100,
        mode: GameMode.teams2v2,
        playerNames: const ['Ana', 'Luis', 'Pedro'],
      );

      expect(game.teams[0].player1, 'Ana');
      expect(game.teams[0].player2, 'Luis');
      expect(game.teams[1].player1, 'Pedro');
      expect(game.teams[1].player2, 'Jugador 4');
    });

    test('en individual el equipo se llama como el jugador', () async {
      final game = await startNewGame(
        pointsToWin: 100,
        mode: GameMode.individual3,
        playerNames: const ['Ana', 'Luis', 'Pedro'],
      );

      expect(game.teams.map((t) => t.name), ['Ana', 'Luis', 'Pedro']);
      expect(game.teams.map((t) => t.player1), ['Ana', 'Luis', 'Pedro']);
    });

    test('sin nombres se queda con los equipos por defecto', () async {
      final game = await startNewGame(
        pointsToWin: 100,
        mode: GameMode.teams2v2,
      );

      expect(game.teams[0].name, 'Team 1');
      expect(game.teams[0].player1, 'Jugador 1');
      expect(game.teams[1].player2, 'Jugador 4');
    });

    test('se ignoran los nombres vacíos', () async {
      final game = await startNewGame(
        pointsToWin: 100,
        mode: GameMode.individual2,
        playerNames: const ['  ', 'Ana'],
      );

      expect(game.teams[0].name, 'Ana');
      expect(game.teams[1].name, 'Jugador 2');
    });
  });

  group('selector de jugadores', () {
    Future<void> openDialog(
      WidgetTester tester, {
      required bool isTeams,
      List<GroupMember> members = const [],
    }) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    await showDialog<TeamPlayersResult>(
                      context: context,
                      builder: (_) => TeamPlayersDialog(
                        teamName: 'Team 1',
                        isTeams: isTeams,
                        members: members,
                      ),
                    );
                  },
                  child: const Text('abrir'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('abrir'));
      await tester.pumpAndSettle();
    }

    testWidgets('en parejas muestra los dos puestos', (tester) async {
      await openDialog(tester, isTeams: true);

      expect(find.text('Jugadores del equipo'), findsOneWidget);
      expect(find.text('Jugador 1'), findsOneWidget);
      expect(find.text('Jugador 2'), findsOneWidget);
      expect(find.text('Elegir jugador'), findsNWidgets(2));
    });

    testWidgets('en individual solo hay un puesto', (tester) async {
      await openDialog(tester, isTeams: false);

      // El título del diálogo y la etiqueta del único puesto dicen "Jugador".
      expect(find.text('Jugador'), findsNWidgets(2));
      expect(find.text('Jugador 2'), findsNothing);
      expect(find.text('Elegir jugador'), findsOneWidget);
    });

    testWidgets('se elige un miembro del grupo', (tester) async {
      TeamPlayersResult? result;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    result = await showDialog<TeamPlayersResult>(
                      context: context,
                      builder: (_) => TeamPlayersDialog(
                        teamName: 'Team 1',
                        isTeams: true,
                        members: [_member('Ana'), _member('Luis')],
                      ),
                    );
                  },
                  child: const Text('abrir'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('abrir'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Elegir jugador').first);
      await tester.pumpAndSettle();
      expect(find.text('¿Quién juega?'), findsOneWidget);
      expect(find.text('Ana'), findsOneWidget);

      await tester.tap(find.text('Ana'));
      await tester.pumpAndSettle();
      expect(find.text('Ana'), findsOneWidget); // ya en el puesto

      await tester.tap(find.text('Guardar'));
      await tester.pumpAndSettle();

      expect(result!.player1, 'Ana');
      expect(result!.player2, isNull);
    });

    testWidgets('se puede escribir el nombre de un invitado', (tester) async {
      TeamPlayersResult? result;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    result = await showDialog<TeamPlayersResult>(
                      context: context,
                      builder: (_) => TeamPlayersDialog(
                        teamName: 'Team 1',
                        isTeams: true,
                        members: [_member('Ana')],
                      ),
                    );
                  },
                  child: const Text('abrir'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('abrir'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Elegir jugador').last);
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Invitado Juan');
      await tester.tap(find.text('Usar'));
      await tester.pumpAndSettle();

      expect(find.text('Invitado Juan'), findsOneWidget);

      await tester.tap(find.text('Guardar'));
      await tester.pumpAndSettle();

      expect(result!.player2, 'Invitado Juan');
    });

    testWidgets('cancelar no devuelve nada', (tester) async {
      TeamPlayersResult? result;
      var closed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    result = await showDialog<TeamPlayersResult>(
                      context: context,
                      builder: (_) => TeamPlayersDialog(
                        teamName: 'Team 1',
                        isTeams: true,
                        members: const [],
                        player1: 'Ana',
                      ),
                    );
                    closed = true;
                  },
                  child: const Text('abrir'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('abrir'));
      await tester.pumpAndSettle();

      expect(find.text('Ana'), findsOneWidget); // valor inicial

      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();

      expect(result, isNull);
      expect(closed, isTrue);
    });
  });
}
