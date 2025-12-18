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
    final message = e.toString();

    if (message.contains('email-already-in-use')) {
      return 'El correo electrónico ya está en uso.';
    }
    if (message.contains('invalid-email')) {
      return 'El correo electrónico no es válido.';
    }
    if (message.contains('weak-password')) {
      return 'La contraseña es muy débil.';
    }
    if (message.contains('user-not-found')) {
      return 'No se encontró ningún usuario con este correo.';
    }
    if (message.contains('wrong-password')) {
      return 'La contraseña es incorrecta.';
    }
    if (message.contains('invalid-credential')) {
      return 'Credenciales inválidas.';
    }
    if (message.contains('network-request-failed')) {
      return 'Error de conexión. Verifique su internet.';
    }

    return message.replaceAll('Exception: ', '');
  }
}
