import 'dart:io';

import 'package:dominos_score/features/games/data/database/app_database.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Gestiona el ciclo de vida de la base de datos Drift, que es **por usuario**.
///
/// Al iniciar sesión se llama a [open] con el id del usuario; al cerrar sesión
/// o eliminar la cuenta se llama a [close] o [deleteDatabase] respectivamente.
class DatabaseManager {
  AppDatabase? _database;
  String? _userId;

  AppDatabase get database {
    final db = _database;
    if (db == null) {
      throw StateError('DatabaseManager no inicializado. Llama open(userId) primero.');
    }
    return db;
  }

  bool get isOpen => _database != null;

  /// Usuario dueño de la base de datos abierta (o `null` si está cerrada).
  String? get userId => _userId;

  Future<void> open(String userId) async {
    // Si ya está abierta para el mismo usuario no se toca. Cerrar y volver a
    // abrir una base en caliente mataba las consultas en curso y Drift lanzaba
    // "Channel was closed before receiving a response".
    if (_database != null && _userId == userId) return;

    if (_database != null) await close();

    _userId = userId;
    _database = AppDatabase(AppDatabase.connectionForUser(userId));
  }

  Future<void> close() async {
    // Se suelta la referencia ANTES de cerrar de verdad, para que ninguna
    // consulta nueva pueda agarrar una base de datos a medio cerrar.
    final db = _database;
    _database = null;
    _userId = null;
    if (db == null) return;

    try {
      await db.close();
    } catch (_) {
      // Cerrar la base local nunca debe romper el cierre de sesión.
    }
  }

  Future<void> deleteDatabase(String userId) async {
    await close();
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'DominoScoreDB_$userId.db'));
    if (await file.exists()) {
      await file.delete();
    }
  }

  /// Indica si ya existe una base de datos para el usuario dado.
  Future<bool> databaseExists(String userId) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'DominoScoreDB_$userId.db'));
    return file.exists();
  }
}

/// ¿El error viene de que la base local está cerrada o a medio cerrar?
///
/// Drift lanza `ConnectionClosedException` ("Channel was closed before
/// receiving a response") cuando se cierra la base con consultas en vuelo, y
/// [DatabaseManager.database] lanza [StateError] si nunca se abrió. En ambos
/// casos la app debe seguir funcionando sin datos locales en vez de mostrar el
/// error crudo.
bool isDatabaseClosedError(Object error) {
  if (error is StateError) return true;
  final message = error.toString();
  return message.contains('Channel was closed before receiving a response') ||
      message.contains('DatabaseManager no inicializado') ||
      message.contains('Connection closed');
}
