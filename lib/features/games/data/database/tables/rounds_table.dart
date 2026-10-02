import 'package:dominos_score/features/games/data/database/tables/games_table.dart';
import 'package:drift/drift.dart';

/// Tabla de rondas. El nombre de la clase generada es [RoundRow] para no
/// colisionar con la entidad de dominio `Round`.
@DataClassName('RoundRow')
class Rounds extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get gameId =>
      integer().references(Games, #id, onDelete: KeyAction.cascade)();
  IntColumn get number => integer()();
  IntColumn get team1Points => integer()();
  IntColumn get team2Points => integer()();
  IntColumn get team3Points => integer().nullable()();
  IntColumn get team4Points => integer().nullable()();

  /// Acciones de la ronda (capicúa, pase redondo, trancao, zapatero, pase
  /// individual) serializadas como JSON.
  TextColumn get eventsJson => text().nullable()();
}
