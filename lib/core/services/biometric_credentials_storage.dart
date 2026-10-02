import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Almacén seguro donde se guardan las credenciales del acceso con Face ID.
///
/// Es una interfaz propia para poder sustituirla en las pruebas (el
/// `FlutterSecureStorage` real necesita la plataforma).
abstract class BiometricCredentialsStorage {
  Future<void> write(String key, String value);
  Future<String?> read(String key);
  Future<void> delete(String key);
}

/// Implementación real: llavero en iOS/macOS y almacenamiento cifrado en
/// Android (a través de `flutter_secure_storage`).
class SecureBiometricCredentialsStorage implements BiometricCredentialsStorage {
  const SecureBiometricCredentialsStorage([
    this._storage = const FlutterSecureStorage(),
  ]);

  final FlutterSecureStorage _storage;

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);
}
