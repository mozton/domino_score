import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

/// Resultado de pedirle al sistema la verificación con Face ID / huella.
enum BiometricPromptResult { success, canceled, unavailable, failed }

/// Puerta de entrada a la biometría del dispositivo.
///
/// Se abstrae para poder probar el flujo de "entrar con Face ID" sin depender
/// de la plataforma.
abstract class BiometricAuthenticator {
  /// ¿El dispositivo puede pedir Face ID / huella?
  Future<bool> isAvailable();

  /// Muestra el diálogo del sistema y espera la verificación.
  Future<BiometricPromptResult> prompt(String reason);
}

/// Implementación real sobre el plugin `local_auth`.
class LocalBiometricAuthenticator implements BiometricAuthenticator {
  LocalBiometricAuthenticator([LocalAuthentication? auth])
    : _auth = auth ?? LocalAuthentication();

  final LocalAuthentication _auth;

  @override
  Future<bool> isAvailable() async {
    try {
      if (await _auth.isDeviceSupported()) return true;
      return await _auth.canCheckBiometrics;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<BiometricPromptResult> prompt(String reason) async {
    try {
      final ok = await _auth.authenticate(
        localizedReason: reason,
        biometricOnly: false,
        sensitiveTransaction: true,
        persistAcrossBackgrounding: true,
      );
      return ok ? BiometricPromptResult.success : BiometricPromptResult.canceled;
    } on LocalAuthException catch (e) {
      switch (e.code) {
        case LocalAuthExceptionCode.userCanceled:
        case LocalAuthExceptionCode.systemCanceled:
        case LocalAuthExceptionCode.userRequestedFallback:
          return BiometricPromptResult.canceled;
        case LocalAuthExceptionCode.noCredentialsSet:
        case LocalAuthExceptionCode.noBiometricsEnrolled:
        case LocalAuthExceptionCode.noBiometricHardware:
        case LocalAuthExceptionCode.biometricHardwareTemporarilyUnavailable:
        case LocalAuthExceptionCode.authInProgress:
        case LocalAuthExceptionCode.uiUnavailable:
          return BiometricPromptResult.unavailable;
        default:
          return BiometricPromptResult.failed;
      }
    } on PlatformException {
      return BiometricPromptResult.failed;
    } catch (_) {
      return BiometricPromptResult.failed;
    }
  }
}
