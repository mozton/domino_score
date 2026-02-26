class AppException implements Exception {
  final String message;
  final String? prefix;

  AppException(this.message, [this.prefix]);

  @override
  String toString() {
    return "${prefix ?? ""}$message";
  }
}

class NetworkException extends AppException {
  NetworkException([String message = "Sin conexión a internet"])
    : super(message, "Error de red: ");
}

class ServerException extends AppException {
  ServerException([String message = "Ha ocurrido un error en el servidor"])
    : super(message, "Error del servidor: ");
}

class UnknownException extends AppException {
  UnknownException([String message = "Ha ocurrido un error inesperado"])
    : super(message, "Error: ");
}
