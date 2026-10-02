import 'package:dominos_score/core/utils/code_generator.dart';
import 'package:dominos_score/features/games/domain/repositories/live_game_repository.dart';

/// Genera el código de una partida en vivo procurando que no esté en uso.
///
/// Comprueba contra `liveGames/{code}` y reintenta unas cuantas veces. Si no se
/// puede comprobar (sin red, sin permisos) devuelve el código igual: el código
/// es un extra para compartir y nunca debe impedir empezar la partida.
class GenerateLiveCodeUseCase {
  /// Cuántos códigos se prueban antes de rendirse.
  static const int maxAttempts = 5;

  final LiveGameRepository repository;

  GenerateLiveCodeUseCase(this.repository);

  Future<String> call() async {
    for (var attempt = 0; attempt < maxAttempts; attempt++) {
      final code = CodeGenerator.generate();
      try {
        final existing = await repository.getByCode(code);
        if (existing == null) return code;
      } catch (_) {
        return code;
      }
    }
    // Muy improbable: se devuelve uno igualmente para no bloquear el juego.
    return CodeGenerator.generate();
  }
}
