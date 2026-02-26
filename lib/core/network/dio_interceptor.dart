import 'package:dio/dio.dart';
import 'package:dominos_score/core/error/app_exception.dart';

class NetworkInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppException exception;

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        exception = NetworkException();
        break;
      case DioExceptionType.badResponse:
        exception = ServerException(
          "Código de error: ${err.response?.statusCode} - ${err.response?.statusMessage}",
        );
        break;
      case DioExceptionType.cancel:
        exception = UnknownException("Petición cancelada");
        break;
      default:
        exception = UnknownException("Error de red no identificado");
    }

    // Pass the custom exception along
    return handler.next(
      DioException(
        requestOptions: err.requestOptions,
        error: exception,
        type: err.type,
      ),
    );
  }
}
