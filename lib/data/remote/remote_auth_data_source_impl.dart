import 'package:dominos_score/domain/datasourse/remote_auth_data_source.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';

class RemoteAuthDataSourceImpl implements RemoteAuthDataSource {
  final Dio _dio;
  final FlutterSecureStorage _storage;
  final String _firebaseToken = dotenv.env['FIREBASE_TOKEN'] ?? '';
  final String _authBaseUrl = 'https://identitytoolkit.googleapis.com';

  RemoteAuthDataSourceImpl(this._storage, {Dio? dio}) : _dio = dio ?? Dio() {
    _dio.options.baseUrl = _authBaseUrl;
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

      final decodeResp = resp.data as Map<String, dynamic>;

      if (decodeResp.containsKey('idToken')) {
        await _storage.write(key: 'token', value: decodeResp['idToken']);
        return decodeResp;
      }
      throw Exception('Error desconocido al registrar usuario');
    } on DioException catch (e) {
      final errorData = e.response?.data['error'] as Map<String, dynamic>?;
      throw Exception(errorData?['message'] ?? 'Error de conexión o servidor');
    } catch (e) {
      throw Exception('Ocurrió un error inesperado: $e');
    }
  }

  Future<void> verifyEmail(String idToken) async {
    try {
      await _dio.post(
        '/v1/accounts:sendVerificationCode',
        queryParameters: {'key': _firebaseToken},
        data: {'idToken': idToken},
      );
    } on DioException catch (e) {
      final errorData = e.response?.data['error'] as Map<String, dynamic>?;
      throw Exception(errorData?['message'] ?? 'Error de conexión o servidor');
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
        await _storage.write(key: 'token', value: decodeResp['idToken']);
        return decodeResp;
      }
      throw Exception('Error desconocido al iniciar sesión');
    } on DioException catch (e) {
      final errorData = e.response?.data['error'] as Map<String, dynamic>?;
      throw Exception(errorData?['message'] ?? 'Error de conexión o servidor');
    } catch (e) {
      throw Exception('Ocurrió un error inesperado: $e');
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
      final errorData = e.response?.data['error'] as Map<String, dynamic>?;
      throw Exception(errorData?['message'] ?? 'Error al obtener datos');
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  @override
  Future<void> logout() async {
    await _storage.delete(key: 'token');
    return;
  }

  @override
  Future<String> readToken() async {
    return await _storage.read(key: 'token') ?? '';
  }
}
