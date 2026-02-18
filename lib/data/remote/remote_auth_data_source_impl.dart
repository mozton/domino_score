import 'package:dominos_score/domain/datasourse/remote_auth_data_source.dart';
import 'package:dominos_score/domain/exceptions/auth_exception.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';

// Definición de las claves para SecureStorage
String _idTokenKey = 'idToken';
String _refreshTokenKey = 'refreshToken';

class RemoteAuthDataSourceImpl implements RemoteAuthDataSource {
  final Dio _dio;
  final FlutterSecureStorage _storage;
  final String _firebaseToken = dotenv.env['FIREBASE_TOKEN'] ?? '';
  final String _authBaseUrl = 'https://identitytoolkit.googleapis.com';

  RemoteAuthDataSourceImpl(this._storage, {Dio? dio}) : _dio = dio ?? Dio() {
    _dio.options.baseUrl = _authBaseUrl;
  }

  void _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      throw AuthException(
        'Error de conexión. Verifique su internet.',
        code: 'NETWORK_ERROR',
      );
    }

    final errorData = e.response?.data['error'] as Map<String, dynamic>?;
    final message = errorData?['message'] as String? ?? 'UNKNOWN_ERROR';

    if (message.contains('EMAIL_EXISTS')) {
      throw AuthException(
        'Este correo electrónico ya está registrado.',
        code: 'EMAIL_EXISTS',
      );
    }
    if (message.contains('INVALID_LOGIN_CREDENTIALS') ||
        message.contains('INVALID_PASSWORD') ||
        message.contains('EMAIL_NOT_FOUND') ||
        message.contains('USER_NOT_FOUND')) {
      throw AuthException(
        'Correo o contraseña incorrectos.',
        code: 'INVALID_CREDENTIALS',
      );
    }
    if (message.contains('WEAK_PASSWORD')) {
      throw AuthException(
        'La contraseña es muy débil. Debe tener al menos 6 caracteres.',
        code: 'WEAK_PASSWORD',
      );
    }
    if (message.contains('TOO_MANY_ATTEMPTS_TRY_LATER')) {
      throw AuthException(
        'Demasiados intentos fallidos. Inténtelo más tarde.',
        code: 'TOO_MANY_ATTEMPTS',
      );
    }
    if (message.contains('USER_DISABLED')) {
      throw AuthException(
        'Esta cuenta ha sido deshabilitada.',
        code: 'USER_DISABLED',
      );
    }

    throw AuthException(
      'Ocurrió un error inesperado al procesar su solicitud.',
      code: message,
    );
  }

  // ===================== CORE AUTHENTICATION =====================

  Future<void> _saveTokens(Map<String, dynamic> data) async {
    if (data.containsKey('idToken')) {
      await _storage.write(key: _idTokenKey, value: data['idToken']);
    }
    final refreshToken = data['refreshToken'] ?? data['refresh_token'];
    if (refreshToken != null) {
      await _storage.write(key: _refreshTokenKey, value: refreshToken);
    }
  }

  Future<void> _sendVerificationRequest(String idToken) async {
    try {
      await _dio.post(
        '/v1/accounts:sendOobCode',
        queryParameters: {'key': _firebaseToken},
        data: {'idToken': idToken, 'requestType': 'VERIFY_EMAIL'},
      );
    } on DioException catch (e) {
      debugPrint('Error al enviar correo de verificación en background: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> createUser(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    };

    try {
      final resp = await _dio.post(
        '/v1/accounts:signUp',
        queryParameters: {'key': _firebaseToken},
        data: authData,
      );

      final userData = resp.data as Map<String, dynamic>;

      if (userData.containsKey('idToken')) {
        await _saveTokens(userData);
        await _sendVerificationRequest(userData['idToken'] as String);

        return userData;
      }
      throw AuthException('Error desconocido al registrar usuario');
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow; // Should not reach here as _handleDioError throws
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Ocurrió un error inesperado: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    };

    try {
      final resp = await _dio.post(
        '/v1/accounts:signInWithPassword',
        queryParameters: {'key': _firebaseToken},
        data: authData,
      );

      final decodeResp = resp.data as Map<String, dynamic>;

      if (decodeResp.containsKey('idToken')) {
        await _saveTokens(decodeResp);
        return decodeResp;
      }
      throw AuthException('Error desconocido al iniciar sesión');
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Ocurrió un error inesperado: $e');
    }
  }

  // ===================== TOKEN MANAGEMENT =====================

  @override
  Future<void> logout() async {
    await _storage.delete(key: _idTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    return;
  }

  @override
  Future<String> readToken() async {
    return await _storage.read(key: _idTokenKey) ?? '';
  }

  @override
  Future<String?> refreshIdToken() async {
    final refreshToken = await _storage.read(key: _refreshTokenKey);

    if (refreshToken == null) {
      return null;
    }

    final Map<String, dynamic> refreshData = {
      'grant_type': 'refresh_token',
      'refresh_token': refreshToken,
    };

    try {
      final resp = await _dio.post(
        // Este endpoint es diferente al de identitytoolkit
        'https://securetoken.googleapis.com/v1/token',
        queryParameters: {'key': _firebaseToken},
        data: refreshData,
      );

      final data = resp.data as Map<String, dynamic>;

      if (data.containsKey('id_token')) {
        await _saveTokens(data);

        return data['id_token'];
      }
      return null; // Error al refrescar
    } on DioException {
      // El refresh token expiró o es inválido. Forzar cierre de sesión.
      await logout();
      return null;
    }
  }

  // ===================== EMAIL VERIFICATION (Mantenido) =====================

  @override
  Future<bool> isEmailVerified() async {
    final idToken = await _storage.read(key: _idTokenKey);
    if (idToken == null) throw AuthException('No se encontró token');

    try {
      final resp = await _dio.post(
        '/v1/accounts:lookup',
        queryParameters: {'key': _firebaseToken},
        data: {'idToken': idToken},
      );

      final decodeResp = resp.data as Map<String, dynamic>;
      if (decodeResp.containsKey('users')) {
        return (decodeResp['users'] as List).first['emailVerified'] as bool;
      }
      throw AuthException('No se encontraron datos del usuario');
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Error inesperado: $e');
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final token = await _storage.read(key: _idTokenKey); // Usar clave correcta
    if (token == null) throw AuthException('No se encontró token');

    try {
      final resp = await _dio.post(
        '/v1/accounts:sendOobCode',
        queryParameters: {'key': _firebaseToken},
        data: {'idToken': token, 'requestType': 'VERIFY_EMAIL'},
      );

      final data = resp.data;

      if (data == null || !data.containsKey('email')) {
        throw AuthException('No se pudo enviar el correo de verificación');
      }
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Error inesperado: $e');
    }
  }

  @override
  Future<void> resendVerificationEmail() async {
    final token = await _storage.read(key: _idTokenKey); // Usar clave correcta

    if (token == null) {
      throw AuthException('No se encontró el token del usuario.');
    }

    try {
      final resp = await _dio.post(
        '/v1/accounts:sendOobCode',
        queryParameters: {'key': _firebaseToken},
        data: {'requestType': 'VERIFY_EMAIL', 'idToken': token},
      );

      final data = resp.data;

      if (data == null || !data.containsKey('email')) {
        throw AuthException('No se pudo reenviar el correo de verificación.');
      }

      // print("Correo de verificación reenviado a: ${data['email']}");
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Error inesperado: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getUserData(String idToken) async {
    try {
      final resp = await _dio.post(
        '/v1/accounts:lookup',
        queryParameters: {'key': _firebaseToken},
        data: {'idToken': idToken},
      );

      final decodeResp = resp.data as Map<String, dynamic>;
      if (decodeResp.containsKey('users')) {
        return (decodeResp['users'] as List).first as Map<String, dynamic>;
      }
      throw AuthException('No se encontraron datos del usuario');
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Error inesperado: $e');
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      final resp = await _dio.post(
        '/v1/accounts:sendOobCode',
        queryParameters: {'key': _firebaseToken},
        data: {'requestType': 'PASSWORD_RESET', 'email': email},
      );

      final data = resp.data;

      if (data == null || !data.containsKey('email')) {
        throw AuthException('No se pudo enviar el correo de recuperación.');
      }
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<void> deleteUser(String idToken) async {
    try {
      final resp = await _dio.post(
        '/v1/accounts:delete',
        queryParameters: {'key': _firebaseToken},
        data: {'idToken': idToken},
      );

      final data = resp.data;

      if (data != null &&
          data['kind'] == 'identitytoolkit#DeleteAccountResponse') {
        // Éxito confirmado
      }
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Error inesperado al eliminar la cuenta: $e');
    }
  }
}
