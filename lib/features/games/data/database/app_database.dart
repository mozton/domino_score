import 'dart:io';

import 'package:dominos_score/features/games/data/database/tables/games_table.dart';
import 'package:dominos_score/features/games/data/database/tables/rounds_table.dart';
import 'package:dominos_score/features/games/data/database/tables/teams_table.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

/// Base de datos Drift de la aplicación.
///
/// Se abre un archivo `.db` distinto por usuario (igual que hacía la antigua
/// capa de sqflite) para aislar las partidas de cada cuenta.
@DriftDatabase(tables: [Games, Teams, Rounds])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) => m.createAll(),
      onUpgrade: (m, from, to) async {
        // v2: metodología de juego ("mi equipo" y acciones por ronda).
        if (from < 2) {
          await m.addColumn(games, games.myTeamIndex);
          await m.addColumn(rounds, rounds.eventsJson);
        }
      },
    );
  }

  /// Crea la conexión per-usuario. La conexión se abre de forma perezosa en
  /// background para no bloquear el hilo principal.
  static QueryExecutor connectionForUser(String userId) {
    return LazyDatabase(() async {
      final dir = await getApplicationDocumentsDirectory();
      final file = File(p.join(dir.path, 'DominoScoreDB_$userId.db'));
      return NativeDatabase.createInBackground(file);
    });
  }
}
