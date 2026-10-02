import 'package:dominos_score/features/games/data/database/database_manager.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DatabaseManager', () {
    late DatabaseManager manager;

    setUp(() => manager = DatabaseManager());
    tearDown(() => manager.close());

    test('empieza cerrada y abre la base del usuario', () async {
      expect(manager.isOpen, isFalse);
      expect(manager.userId, isNull);

      await manager.open('user-1');

      expect(manager.isOpen, isTrue);
      expect(manager.userId, 'user-1');
    });

    test(
      'no cierra ni reabre la base si es el mismo usuario (causa del error '
      '"Channel was closed before receiving a response")',
      () async {
        await manager.open('user-1');
        final first = manager.database;

        await manager.open('user-1');

        expect(identical(manager.database, first), isTrue);
      },
    );

    test('cambia de base al cambiar de usuario', () async {
      await manager.open('user-1');
      final first = manager.database;

      await manager.open('user-2');

      expect(manager.userId, 'user-2');
      expect(identical(manager.database, first), isFalse);
    });

    test('deja de estar abierta antes de terminar de cerrar', () async {
      await manager.open('user-1');

      final closing = manager.close();

      // Mientras cierra, ninguna consulta nueva puede agarrar esa base.
      expect(manager.isOpen, isFalse);
      await closing;
      expect(manager.userId, isNull);
      expect(() => manager.database, throwsStateError);
    });

    test('cerrar dos veces no falla', () async {
      await manager.open('user-1');
      await manager.close();
      await manager.close();

      expect(manager.isOpen, isFalse);
    });

    test('se puede reabrir al mismo usuario después de cerrar', () async {
      await manager.open('user-1');
      await manager.close();
      await manager.open('user-1');

      expect(manager.isOpen, isTrue);
      expect(manager.userId, 'user-1');
    });
  });

  group('isDatabaseClosedError', () {
    test('reconoce el error de Drift y la base sin inicializar', () {
      expect(
        isDatabaseClosedError(
          Exception('Channel was closed before receiving a response'),
        ),
        isTrue,
      );
      expect(
        isDatabaseClosedError(
          StateError('DatabaseManager no inicializado. Llama open(userId) primero.'),
        ),
        isTrue,
      );
    });

    test('no confunde otros errores', () {
      expect(isDatabaseClosedError(Exception('sin conexión')), isFalse);
      expect(isDatabaseClosedError(ArgumentError('otra cosa')), isFalse);
    });
  });
}
