import 'package:dominos_score/features/games/data/database/tables/games_table.dart';
import 'package:drift/drift.dart';

/// Tabla de equipos. El nombre de la clase generada es [TeamRow] para no
/// colisionar con la entidad de dominio `Team`.
@DataClassName('TeamRow')
class Teams extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get gameId =>
      integer().references(Games, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  TextColumn get player1 => text().nullable()();
  TextColumn get player2 => text().nullable()();
  IntColumn get totalScore => integer()();
}
