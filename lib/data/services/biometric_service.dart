import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> authenticateWithFace() async {
    try {
      final canAuthenticate =
          await _auth.canCheckBiometrics || await _auth.isDeviceSupported();

      if (!canAuthenticate) return false;

      final didAuthenticate = await _auth.authenticate(
        localizedReason: 'Por favor autentíquese para iniciar sesión',
      );

      return didAuthenticate;
    } on PlatformException {
      return false;
    }
  }

  final _storage = const FlutterSecureStorage();

  Future<void> saveCredentials(String email, String password) async {
    await _storage.write(key: 'bio_email', value: email);
    await _storage.write(key: 'bio_password', value: password);
  }

  Future<Map<String, String>?> getCredentials() async {
    final email = await _storage.read(key: 'bio_email');
    final password = await _storage.read(key: 'bio_password');

    if (email != null && password != null) {
      return {'email': email, 'password': password};
    }
    return null;
  }
}
