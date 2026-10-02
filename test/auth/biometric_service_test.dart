import 'package:dominos_score/core/services/biometric_authenticator.dart';
import 'package:dominos_score/core/services/biometric_credentials_storage.dart';
import 'package:dominos_score/core/services/biometric_service.dart';
import 'package:flutter_test/flutter_test.dart';

/// Almacén en memoria (sustituye al llavero del sistema).
class MemoryCredentialsStorage implements BiometricCredentialsStorage {
  final Map<String, String> values = {};

  /// Si es `true`, cualquier operación falla (llavero no disponible).
  bool failing = false;

  @override
  Future<void> write(String key, String value) async {
    if (failing) throw Exception('llavero no disponible');
    values[key] = value;
  }

  @override
  Future<String?> read(String key) async {
    if (failing) throw Exception('llavero no disponible');
    return values[key];
  }

  @override
  Future<void> delete(String key) async {
    if (failing) throw Exception('llavero no disponible');
    values.remove(key);
  }
}

/// Autenticador de prueba: no llama a la plataforma.
class FakeBiometricAuthenticator implements BiometricAuthenticator {
  FakeBiometricAuthenticator({
    this.available = true,
    this.result = BiometricPromptResult.success,
  });

  bool available;
  BiometricPromptResult result;
  int prompts = 0;

  @override
  Future<bool> isAvailable() async => available;

  @override
  Future<BiometricPromptResult> prompt(String reason) async {
    prompts++;
    return result;
  }
}

void main() {
  late MemoryCredentialsStorage storage;
  late FakeBiometricAuthenticator authenticator;
  late BiometricService service;

  setUp(() {
    storage = MemoryCredentialsStorage();
    authenticator = FakeBiometricAuthenticator();
    service = BiometricService(
      authenticator: authenticator,
      storage: storage,
    );
  });

  test('sin credenciales guardadas el acceso está desactivado', () async {
    expect(await service.isEnabled(), isFalse);
    expect(await service.savedEmail(), isNull);
    expect(await service.isAvailable(), isTrue);
  });

  test('guardar credenciales las deja activadas y visibles', () async {
    final saved = await service.enableFor(
      email: '  ana@correo.com ',
      password: 'Secreta1!',
    );

    expect(saved, isTrue);
    expect(await service.isEnabled(), isTrue);
    expect(await service.savedEmail(), 'ana@correo.com');
    expect(await service.isEnabledFor('ANA@correo.com'), isTrue);
    expect(await service.isEnabledFor('otro@correo.com'), isFalse);
  });

  test('no guarda credenciales incompletas', () async {
    expect(await service.enableFor(email: '   ', password: 'x'), isFalse);
    expect(await service.enableFor(email: 'a@b.com', password: ''), isFalse);
    expect(await service.isEnabled(), isFalse);
  });

  test('desactivar borra todo lo guardado', () async {
    await service.enableFor(email: 'ana@correo.com', password: 'Secreta1!');

    await service.disable();

    expect(await service.isEnabled(), isFalse);
    expect(storage.values, isEmpty);
  });

  test('con las credenciales ya guardadas, el segundo login pide Face ID', () async {
    await service.enableFor(email: 'ana@correo.com', password: 'Secreta1!');

    final result = await service.signIn();

    expect(result.status, BiometricStatus.success);
    expect(result.email, 'ana@correo.com');
    expect(result.password, 'Secreta1!');
    expect(result.isSuccess, isTrue);
    expect(authenticator.prompts, 1);
  });

  test('sin credenciales no se molesta al usuario con el diálogo', () async {
    final result = await service.signIn();

    expect(result.status, BiometricStatus.noCredentials);
    expect(result.email, isNull);
    expect(authenticator.prompts, 0);
  });

  test('si el usuario cancela no se devuelven credenciales', () async {
    await service.enableFor(email: 'ana@correo.com', password: 'Secreta1!');
    authenticator.result = BiometricPromptResult.canceled;

    final result = await service.signIn();

    expect(result.status, BiometricStatus.canceled);
    expect(result.email, isNull);
    expect(result.password, isNull);
  });

  test('si el dispositivo no puede autenticar se avisa', () async {
    await service.enableFor(email: 'ana@correo.com', password: 'Secreta1!');
    authenticator.available = false;

    final result = await service.signIn();

    expect(result.status, BiometricStatus.unavailable);
    expect(authenticator.prompts, 0);
  });

  test('si la autenticación falla no se devuelven credenciales', () async {
    await service.enableFor(email: 'ana@correo.com', password: 'Secreta1!');
    authenticator.result = BiometricPromptResult.failed;

    final result = await service.signIn();

    expect(result.status, BiometricStatus.failed);
    expect(result.email, isNull);
  });

  test('si el llavero falla, guardar devuelve false y no revienta', () async {
    storage.failing = true;

    expect(
      await service.enableFor(email: 'ana@correo.com', password: 'x'),
      isFalse,
    );
    expect(await service.isEnabled(), isFalse);
    expect((await service.signIn()).status, BiometricStatus.noCredentials);
  });
}
