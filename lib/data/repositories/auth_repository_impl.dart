import 'package:dominos_score/domain/datasourse/remote_auth_data_source.dart';
import 'package:dominos_score/domain/exceptions/auth_exception.dart';
import 'package:flutter/material.dart';
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
      try {
        final newToken = await _dataSource.refreshIdToken();
        if (newToken != null) {
          await _storage.write(key: 'token', value: newToken);
          final userData = await _dataSource.getUserData(newToken);
          return _mapToUser(userData);
        } else {
          await signOut();
          return null;
        }
      } catch (refreshError) {
        await signOut();
        return null;
      }
    }
  }

  @override
  Future<UserModel?> signIn(String email, String password) async {
    try {
      final response = await _dataSource.login(email, password);
      final idToken = response['idToken'] as String?;

      if (idToken == null) {
        throw AuthException(
          'No se recibió token del servidor',
          code: 'NO_TOKEN',
        );
      }

      await _storage.write(key: 'token', value: idToken);
      final verified = await _dataSource.isEmailVerified();

      if (!verified) {
        throw AuthException(
          'Debe verificar su correo antes de iniciar sesión.',
          code: 'EMAIL_NOT_VERIFIED',
        );
      }

      return _mapToUser(response);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    await _dataSource.logout();
    await _storage.delete(key: 'token');
  }

  @override
  Future<UserModel?> signUp(String email, String password) async {
    final response = await _dataSource.createUser(email, password);

    // Intentamos enviar el correo, pero no rompemos el flujo si falla
    try {
      await _dataSource.sendEmailVerification();
    } catch (e) {
      // Log opcional
      debugPrint('No se pudo enviar el correo de verificación: $e');
    }

    return _mapToUser(response);
  }

  UserModel _mapToUser(Map<String, dynamic> data) {
    final uid = data['localId'] ?? data['uid'] ?? '';
    final email = data['email'] ?? '';
    final displayName = data['displayName'] ?? '';
    final photoUrl = data['photoUrl'];
    final createdAt = data['createdAt'] != null
        ? DateTime.tryParse(data['createdAt']) ?? DateTime.now()
        : DateTime.now();

    return UserModel(
      id: uid,
      email: email,
      name: displayName.isNotEmpty ? displayName : 'Usuario',
      username: email.split('@').first,
      photoUrl: photoUrl,
      createdAt: createdAt,
      groupIds: [],
    );
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _dataSource.sendPasswordResetEmail(email);
  }

  @override
  Future<void> deleteUser() async {
    final token = await _storage.read(key: 'token');
    if (token == null) {
      throw AuthException(
        'No se encontró sesión activa para eliminar.',
        code: 'NO_SESSION',
      );
    }

    // Primero eliminamos en remoto
    await _dataSource.deleteUser(token);
    // Luego limpiamos sesión local
    await signOut();
  }

  @override
  Future<void> acceptPrivacyPolicy() async {
    await _storage.write(key: 'privacy_policy_accepted', value: 'true');
  }

  @override
  Future<void> rejectPrivacyPolicy() async {
    await _storage.delete(key: 'privacy_policy_accepted');
  }

  @override
  Future<bool> isPrivacyPolicyAccepted() async {
    final accepted = await _storage.read(key: 'privacy_policy_accepted');
    return accepted == 'true';
  }
}
