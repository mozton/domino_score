import 'package:dominos_score/core/di/injection.dart';
import 'package:dominos_score/features/games/domain/usecases/get_live_game_usecase.dart';
import 'package:dominos_score/features/games/presentation/bloc/live_game_bloc.dart';
import 'package:dominos_score/features/games/presentation/pages/live_game_page.dart';
import 'package:dominos_score/features/games/presentation/widgets/live_code_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_test/flutter_test.dart';

import 'live_game_fakes.dart';

void main() {
  late FakeLiveGameRepository repository;
  late FakeLastLiveCodeStore store;

  setUp(() {
    repository = FakeLiveGameRepository();
    store = FakeLastLiveCodeStore();
    getIt.registerFactory<LiveGameBloc>(
      () => LiveGameBloc(
        getLiveGame: GetLiveGameUseCase(repository),
        lastLiveCodeStore: store,
      ),
    );
  });

  tearDown(() => getIt.reset());

  /// Desmonta la pantalla para que el BLoC se cierre y cancele su temporizador.
  Future<void> unmount(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump();
  }

  testWidgets('el chip del código muestra el código y permite copiarlo', (
    tester,
  ) async {
    final calls = <MethodCall>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        calls.add(call);
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );

    var abierto = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            actions: [
              LiveCodeBadge(
                code: 'ABC123',
                onTap: () => abierto = true,
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('ABC123'), findsOneWidget);

    await tester.tap(find.byIcon(TablerIcons.copy));
    await tester.pump();
    final clipboard = calls
        .where((call) => call.method == 'Clipboard.setData')
        .toList();
    expect(clipboard, hasLength(1));
    expect((clipboard.single.arguments as Map)['text'], 'ABC123');

    await tester.tap(find.text('ABC123'));
    await tester.pump();
    expect(abierto, isTrue);
  });

  testWidgets('el invitado escribe el código y sigue la partida en vivo', (
    tester,
  ) async {
    repository.games['ABC123'] = buildLiveGame(points: 30);

    await tester.pumpWidget(const MaterialApp(home: LiveGameScreen()));
    expect(find.text('Partida en vivo'), findsOneWidget);
    expect(find.textContaining('Escribe el código'), findsOneWidget);

    // Se escribe en minúsculas y con el almohadilla: el BLoC lo normaliza.
    await tester.enterText(find.byType(TextField), '#abc123');
    await tester.tap(find.text('Ver'));
    await tester.pump();
    await tester.pump();

    expect(find.text('Los Tigres'), findsOneWidget);
    expect(find.text('ABC123'), findsOneWidget);
    expect(find.text('30'), findsOneWidget);
    expect(find.text('Team 1'), findsWidgets);
    expect(find.textContaining('Capicúa'), findsOneWidget);
    expect(find.text('Capicúa · Ana (Team 1)'), findsOneWidget);

    await unmount(tester);
  });

  testWidgets('con un código inexistente avisa al invitado', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: LiveGameScreen()));

    await tester.enterText(find.byType(TextField), 'ZZZZZZ');
    await tester.tap(find.text('Ver'));
    await tester.pump();
    await tester.pump();

    expect(find.textContaining('No hay ninguna partida'), findsOneWidget);

    await unmount(tester);
  });

  testWidgets('abierta desde una partida carga sola el marcador', (
    tester,
  ) async {
    repository.games['ABC123'] = buildLiveGame(points: 40, winnerTeamName: 'Team 1');

    await tester.pumpWidget(
      const MaterialApp(home: LiveGameScreen(initialCode: 'ABC123')),
    );
    await tester.pump();
    await tester.pump();

    // El código ya viene escrito y la partida se carga sin tocar nada.
    expect(find.text('Los Tigres'), findsOneWidget);
    expect(find.text('40'), findsOneWidget);
    expect(find.text('¡Ganó Team 1!'), findsOneWidget);
    expect(repository.fetches, 1);

    await unmount(tester);
  });

  testWidgets('vuelve sola a la última partida en vivo que se vio', (
    tester,
  ) async {
    store.code = 'ABC123';
    repository.games['ABC123'] = buildLiveGame(points: 55);

    await tester.pumpWidget(const MaterialApp(home: LiveGameScreen()));
    await tester.pump();
    await tester.pump();

    // Sin escribir nada: se reabre la última partida y el campo se rellena.
    expect(find.text('Los Tigres'), findsOneWidget);
    expect(find.text('55'), findsOneWidget);
    // El código aparece en el campo de texto y en el chip de arriba.
    expect(find.text('ABC123'), findsNWidgets(2));
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      'ABC123',
    );

    await unmount(tester);
  });
}
