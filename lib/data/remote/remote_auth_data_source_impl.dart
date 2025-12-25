import 'package:dominos_score/domain/datasourse/remote_auth_data_source.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';

// Definición de las claves para SecureStorage
const String _ID_TOKEN_KEY = 'idToken';
const String _REFRESH_TOKEN_KEY =
    'refreshToken'; // 🚨 NUEVA CLAVE PARA REFRESH TOKEN

/// Implementación de la fuente de datos remota para la autenticación.
class RemoteAuthDataSourceImpl implements RemoteAuthDataSource {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  final String _firebaseToken = dotenv.env['FIREBASE_TOKEN'] ?? '';
  // Usamos el mismo Base URL para identitytoolkit.googleapis.com
  final String _authBaseUrl = 'https://identitytoolkit.googleapis.com';

  RemoteAuthDataSourceImpl(this._storage, {Dio? dio}) : _dio = dio ?? Dio() {
    _dio.options.baseUrl = _authBaseUrl;
  }

  // Helper para manejar errores de Dio/Firebase
  String _handleDioError(DioException e) {
    final errorData = e.response?.data['error'] as Map<String, dynamic>?;
    return errorData?['message'] ?? 'Error de conexión o servidor.';
  }

  // ===================== CORE AUTHENTICATION =====================

  /// 🚨 NUEVO MÉTODO HELPER: Para guardar ambos tokens de forma consistente.
  Future<void> _saveTokens(Map<String, dynamic> data) async {
    // 1. Guardar el ID Token (el de corta duración)
    if (data.containsKey('idToken')) {
      await _storage.write(key: _ID_TOKEN_KEY, value: data['idToken']);
    }

    // 2. Guardar el Refresh Token (el de larga duración)
    // El endpoint de login devuelve 'refreshToken'. El endpoint de refresh devuelve 'refresh_token'.
    final refreshToken = data['refreshToken'] ?? data['refresh_token'];
    if (refreshToken != null) {
      await _storage.write(key: _REFRESH_TOKEN_KEY, value: refreshToken);
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
      // Ignoramos errores menores de reenvío, pero podemos loguearlos

      SnackBar(
        content: Text(
          'Error al enviar correo de verificación en background: ${_handleDioError(e)}',
        ),
      );
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
        // 🚨 CORRECCIÓN: Usar _saveTokens para guardar ambos tokens
        await _saveTokens(userData);

        // Enviar verificación inmediatamente
        await _sendVerificationRequest(userData['idToken'] as String);

        return userData;
      }
      throw Exception('Error desconocido al registrar usuario');
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      throw Exception('Ocurrió un error inesperado: $e');
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
      throw Exception('Error desconocido al iniciar sesión');
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      throw Exception('Ocurrió un error inesperado: $e');
    }
  }

  // ===================== TOKEN MANAGEMENT =====================

  @override
  Future<void> logout() async {
    await _storage.delete(key: _ID_TOKEN_KEY);
    await _storage.delete(key: _REFRESH_TOKEN_KEY);
    return;
  }

  @override
  Future<String> readToken() async {
    return await _storage.read(key: _ID_TOKEN_KEY) ?? '';
  }

  Future<String?> refreshIdToken() async {
    final refreshToken = await _storage.read(key: _REFRESH_TOKEN_KEY);

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
    final idToken = await _storage.read(key: _ID_TOKEN_KEY);
    if (idToken == null) throw Exception('No se encontró token');

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
      throw Exception('No se encontraron datos del usuario');
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final token = await _storage.read(
      key: _ID_TOKEN_KEY,
    ); // Usar clave correcta
    if (token == null) throw Exception('No se encontró token');

    try {
      final resp = await _dio.post(
        '/v1/accounts:sendOobCode',
        queryParameters: {'key': _firebaseToken},
        data: {'idToken': token, 'requestType': 'VERIFY_EMAIL'},
      );

      final data = resp.data;

      if (!data.containsKey('email')) {
        throw Exception('No se pudo enviar el correo de verificación');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  @override
  Future<void> resendVerificationEmail() async {
    final token = await _storage.read(
      key: _ID_TOKEN_KEY,
    ); // Usar clave correcta

    if (token == null) {
      throw Exception('No se encontró el token del usuario.');
    }

    try {
      final resp = await _dio.post(
        '/v1/accounts:sendOobCode',
        queryParameters: {'key': _firebaseToken},
        data: {'requestType': 'VERIFY_EMAIL', 'idToken': token},
      );

      final data = resp.data;

      if (!data.containsKey('email')) {
        throw Exception('No se pudo reenviar el correo de verificación.');
      }

      // print("Correo de verificación reenviado a: ${data['email']}");
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getUserData(String token) async {
    try {
      final resp = await _dio.post(
        '/v1/accounts:lookup',
        queryParameters: {'key': _firebaseToken},
        data: {'idToken': token},
      );

      final decodeResp = resp.data as Map<String, dynamic>;
      if (decodeResp.containsKey('users')) {
        return (decodeResp['users'] as List).first as Map<String, dynamic>;
      }
      throw Exception('No se encontraron datos del usuario');
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }
}
