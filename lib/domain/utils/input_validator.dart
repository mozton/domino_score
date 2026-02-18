import 'package:dominos_score/domain/exceptions/auth_exception.dart';

class InputValidator {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'El correo electrónico es requerido';
    }
    final emailRegex = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    if (!RegExp(emailRegex).hasMatch(value)) {
      return 'El correo electrónico no es válido';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es requerida';
    }
    if (value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }

    return null;
  }

  static String parseException(dynamic e) {
    if (e is AuthException) {
      return e.toString();
    }

    final message = e.toString();

    if (message.contains('email-already-in-use') ||
        message.contains('EMAIL_EXISTS')) {
      return 'Este correo electrónico ya está registrado. (Código: EMAIL_EXISTS)';
    }
    if (message.contains('invalid-email') ||
        message.contains('INVALID_EMAIL')) {
      return 'El correo electrónico no es válido. (Código: INVALID_EMAIL)';
    }
    if (message.contains('weak-password') ||
        message.contains('WEAK_PASSWORD')) {
      return 'La contraseña es muy débil. Debe tener al menos 6 caracteres. (Código: WEAK_PASSWORD)';
    }
    if (message.contains('user-not-found') ||
        message.contains('EMAIL_NOT_FOUND')) {
      return 'No se encontró ningún usuario con este correo. (Código: EMAIL_NOT_FOUND)';
    }
    if (message.contains('wrong-password') ||
        message.contains('INVALID_PASSWORD')) {
      return 'La contraseña es incorrecta. (Código: INVALID_PASSWORD)';
    }
    if (message.contains('invalid-credential') ||
        message.contains('INVALID_LOGIN_CREDENTIALS')) {
      return 'Credenciales inválidas. Verifique su correo y contraseña. (Código: INVALID_CREDENTIALS)';
    }
    if (message.contains('network-request-failed') ||
        message.contains('NETWORK_ERROR')) {
      return 'Error de conexión. Verifique su internet. (Código: NETWORK_ERROR)';
    }
    if (message.contains('too-many-requests') ||
        message.contains('TOO_MANY_ATTEMPTS')) {
      return 'Demasiados intentos fallidos. Inténtelo más tarde. (Código: TOO_MANY_ATTEMPTS)';
    }

    return message.replaceAll('Exception: ', '').replaceAll('Exception', '');
  }
}
