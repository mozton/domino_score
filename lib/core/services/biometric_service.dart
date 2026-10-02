import 'package:dominos_score/core/services/biometric_authenticator.dart';
import 'package:dominos_score/core/services/biometric_credentials_storage.dart';

/// Resultado de intentar entrar con Face ID / huella.
enum BiometricStatus {
  /// Autenticó y hay credenciales para iniciar sesión.
  success,

  /// Nunca se guardaron credenciales (o se desactivó el acceso).
  noCredentials,

  /// El usuario canceló el diálogo del sistema (no hay que avisar de nada).
  canceled,

  /// El dispositivo no tiene Face ID / huella configurados.
  unavailable,

  /// Otro fallo (lectura del llavero, error del sistema...).
  failed,
}

class BiometricSignInResult {
  const BiometricSignInResult(this.status, {this.email, this.password});

  final BiometricStatus status;
  final String? email;
  final String? password;

  bool get isSuccess => status == BiometricStatus.success;
}

/// Acceso con Face ID / huella usando las credenciales guardadas.
///
/// Guardar la contraseña es lo que se pidió ("guardar las credenciales para
/// iniciar con el Face ID"): queda en el almacén seguro del sistema (llavero en
/// iOS, almacenamiento cifrado en Android), nunca en texto plano en la app.
class BiometricService {
  static const String _emailKey = 'bio_email';
  static const String _passwordKey = 'bio_password';
  static const String _enabledKey = 'bio_enabled';

  static const String _promptReason = 'Autentícate para entrar a Domino Score';

  final BiometricAuthenticator _authenticator;
  final BiometricCredentialsStorage _storage;

  BiometricService({
    BiometricAuthenticator? authenticator,
    BiometricCredentialsStorage? storage,
  }) : _authenticator = authenticator ?? LocalBiometricAuthenticator(),
       _storage = storage ?? const SecureBiometricCredentialsStorage();

  /// ¿El dispositivo puede pedir biometría (Face ID / huella)?
  Future<bool> isAvailable() => _authenticator.isAvailable();

  /// ¿Hay credenciales guardadas y activadas?
  Future<bool> isEnabled() async => await _readCredentials() != null;

  /// Correo guardado (para mostrarlo en la pantalla de login).
  Future<String?> savedEmail() async {
    final credentials = await _readCredentials();
    return credentials?['email'];
  }

  /// ¿Las credenciales guardadas son de [email]?
  Future<bool> isEnabledFor(String email) async {
    final saved = await savedEmail();
    return saved != null && saved.toLowerCase() == email.trim().toLowerCase();
  }

  /// Guarda las credenciales para poder entrar con Face ID.
  Future<bool> enableFor({
    required String email,
    required String password,
  }) async {
    final cleanEmail = email.trim();
    if (cleanEmail.isEmpty || password.isEmpty) return false;

    try {
      await _storage.write(_emailKey, cleanEmail);
      await _storage.write(_passwordKey, password);
      await _storage.write(_enabledKey, 'true');
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Borra las credenciales (desactivar Face ID, eliminar la cuenta...).
  Future<void> disable() async {
    for (final key in [_emailKey, _passwordKey, _enabledKey]) {
      try {
        await _storage.delete(key);
      } catch (_) {
        // Si el llavero falla no hay nada más que hacer aquí.
      }
    }
  }

  /// Pide la autenticación y, si pasa, devuelve las credenciales guardadas.
  Future<BiometricSignInResult> signIn() async {
    final credentials = await _readCredentials();
    if (credentials == null) {
      return const BiometricSignInResult(BiometricStatus.noCredentials);
    }

    if (!await isAvailable()) {
      return const BiometricSignInResult(BiometricStatus.unavailable);
    }

    switch (await _authenticator.prompt(_promptReason)) {
      case BiometricPromptResult.success:
        return BiometricSignInResult(
          BiometricStatus.success,
          email: credentials['email'],
          password: credentials['password'],
        );
      case BiometricPromptResult.canceled:
        return const BiometricSignInResult(BiometricStatus.canceled);
      case BiometricPromptResult.unavailable:
        return const BiometricSignInResult(BiometricStatus.unavailable);
      case BiometricPromptResult.failed:
        return const BiometricSignInResult(BiometricStatus.failed);
    }
  }

  Future<Map<String, String>?> _readCredentials() async {
    try {
      final enabled = await _storage.read(_enabledKey);
      if (enabled != 'true') return null;

      final email = await _storage.read(_emailKey);
      final password = await _storage.read(_passwordKey);
      if (email == null || email.isEmpty || password == null) return null;

      return {'email': email, 'password': password};
    } catch (_) {
      return null;
    }
  }
}
