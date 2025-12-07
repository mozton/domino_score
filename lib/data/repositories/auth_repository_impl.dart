import 'package:dominos_score/domain/datasourse/remote_auth_data_source.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dominos_score/domain/models/auth/user_model.dart';
import 'package:dominos_score/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final RemoteAuthDataSource _dataSource;
  final FlutterSecureStorage _storage;

  AuthRepositoryImpl(this._dataSource, this._storage);

  @override
  Future<UserModel?> checkAuthStatus() async {
    try {
      final token = await _storage.read(key: 'token');
      if (token == null) return null;

      final userData = await _dataSource.getUserData(token);
      return _mapToUser(userData);
    } catch (e) {
      await signOut(); // Si el token es inválido, cerrar sesión
      return null;
    }
  }

  @override
  Future<UserModel?> signIn(String email, String password) async {
    try {
      final response = await _dataSource.login(email, password);
      return _mapToUser(response);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    await _dataSource.logout();
  }

  @override
  Future<UserModel?> signUp(String email, String password) async {
    try {
      final response = await _dataSource.createUser(email, password);
      return _mapToUser(response);
    } catch (e) {
      rethrow;
    }
  }

  UserModel _mapToUser(Map<String, dynamic> data) {
    // Firebase devuelve 'localId' como ID principal
    final uid = data['localId'] ?? data['uid'] ?? '';
    final email = data['email'] ?? '';
    final displayName = data['displayName'] ?? '';
    final photoUrl = data['photoUrl'];
    final createdAt = data['createdAt'] != null
        ? DateTime.tryParse(data['createdAt']) ?? DateTime.now()
        : DateTime.now(); // Firebase auth normal no devuelve createdAt en login siempre

    return UserModel(
      id: uid,
      email: email,
      name: displayName.isNotEmpty ? displayName : 'Usuario',
      username: email.split('@').first, // Fallback username
      photoUrl: photoUrl,
      createdAt: createdAt,
      groupIds: [], // Inicialmente sin grupos
    );
  }

  @override
  Future<void> sendEmailVerification() async {
    try {
      final token = await _storage.read(key: 'token');
      if (token == null) throw Exception('No se encontró token');
      await _dataSource.verifyEmail(token);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> isEmailVerified() async {
    try {
      final token = await _storage.read(key: 'token');
      if (token == null) throw Exception('No se encontró token');
      final userData = await _dataSource.getUserData(token);
      return userData['emailVerified'] ?? false;
    } catch (e) {
      rethrow;
    }
  }
}
