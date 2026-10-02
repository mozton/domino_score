import 'package:drift/drift.dart';

/// Tabla de partidas. El nombre de la clase generada es [GameRow] para no
/// colisionar con la entidad de dominio `Game`.
@DataClassName('GameRow')
class Games extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get actualRound => integer()();
  IntColumn get pointsToWin => integer()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get winnerTeamName => text().nullable()();

  /// Equipo en el que juega el usuario (metodología de juego).
  IntColumn get myTeamIndex => integer().nullable()();
}
