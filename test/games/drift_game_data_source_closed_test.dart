import 'package:dominos_score/features/games/data/database/database_manager.dart';
import 'package:dominos_score/features/games/data/datasources/drift_game_data_source.dart';
import 'package:dominos_score/features/games/domain/entities/game_entity.dart';
import 'package:dominos_score/features/games/domain/entities/round_entity.dart';
import 'package:dominos_score/features/games/domain/entities/team_entity.dart';
import 'package:flutter_test/flutter_test.dart';

/// Comprueba que el origen local nunca revienta cuando la base está cerrada:
/// al cerrar sesión (o al cerrar y reabrir la base) llegaban consultas tarde y
/// Drift lanzaba "Channel was closed before receiving a response".
void main() {
  late DatabaseManager manager;
  late DriftGameDataSource dataSource;

  setUp(() {
    manager = DatabaseManager();
    dataSource = DriftGameDataSource(manager);
  });

  tearDown(() => manager.close());

  Game buildGame() => Game(
    actualRound: 0,
    pointsToWin: 100,
    createdAt: DateTime(2024, 5, 1),
    teams: const [Team(name: 'Team 1', totalScore: 0)],
  );

  test('con la base nunca abierta, las lecturas devuelven vacío', () async {
    expect(await dataSource.getGames(), isEmpty);
    expect(await dataSource.getGameById(1), isNull);
  });

  test('con la base nunca abierta, las escrituras no fallan', () async {
    expect(await dataSource.createGame(buildGame()), 0);
    expect(
      await dataSource.insertTeam(1, const Team(name: 'T', totalScore: 0)),
      0,
    );
    expect(
      await dataSource.insertRound(
        1,
        const Round(number: 1, team1Points: 5, team2Points: 0),
      ),
      0,
    );

    // Ninguna de estas debe lanzar (antes reventaban al cerrar la base).
    await dataSource.updatePointsToWin(1, 50);
    await dataSource.updateActualRound(1, 3);
    await dataSource.updateMyTeamIndex(1, 1);
    await dataSource.updateTeamName(1, 'Otro');
    await dataSource.updateTeamScore(1, 20);
    await dataSource.deleteRound(1);
  });

  test('después de cerrar la base tampoco falla', () async {
    await manager.open('user-1');
    await manager.close();

    expect(await dataSource.getGames(), isEmpty);
    expect(await dataSource.getGameById(1), isNull);
    expect(await dataSource.createGame(buildGame()), 0);
  });
}
