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

      final userData = resp.data as Map<String, dynamic>;

      if (userData.containsKey('idToken')) {
        await _storage.write(key: 'token', value: userData['idToken']);
        return userData;
      }
      throw Exception('Error desconocido al registrar usuario');
    } on DioException catch (e) {
      final errorData = e.response?.data['error'] as Map<String, dynamic>?;
      throw Exception(errorData?['message'] ?? 'Error de conexión o servidor');
    } catch (e) {
      throw Exception('Ocurrió un error inesperado: $e');
    }
  }

  Future<void> sendEmailVerification() async {
    final token = await _storage.read(key: 'token');
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
      final error = e.response?.data['error']?['message'];
      throw Exception(error ?? 'Error al enviar correo de verificación');
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  @override
  Future<bool> isEmailVerified() async {
    final idToken = await _storage.read(key: 'token');
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
      final errorData = e.response?.data['error'] as Map<String, dynamic>?;
      throw Exception(errorData?['message'] ?? 'Error al obtener datos');
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  @override
  Future<void> resendVerificationEmail() async {
    // 1. Recuperar el token almacenado
    final token = await _storage.read(key: 'token');

    if (token == null) {
      throw Exception('No se encontró el token del usuario.');
    }

    try {
      // 2. Llamar al endpoint de Firebase
      final resp = await _dio.post(
        '/v1/accounts:sendOobCode',
        queryParameters: {'key': _firebaseToken},
        data: {'requestType': 'VERIFY_EMAIL', 'idToken': token},
      );

      final data = resp.data;

      // 3. Firebase devuelve { email: "algo@gmail.com" } si salió bien
      if (!data.containsKey('email')) {
        throw Exception('No se pudo reenviar el correo de verificación.');
      }

      print("Correo de verificación reenviado a: ${data['email']}");
    } on DioException catch (e) {
      final error = e.response?.data['error']?['message'];
      throw Exception(error ?? 'Error al reenviar el correo de verificación.');
    } catch (e) {
      throw Exception('Error inesperado: $e');
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
