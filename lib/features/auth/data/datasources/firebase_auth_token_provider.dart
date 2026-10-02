import 'package:dominos_score/core/network/auth_token_provider.dart';
import 'package:dominos_score/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Implementación basada en el almacenamiento seguro y el datasource de auth.
class FirebaseAuthTokenProvider implements AuthTokenProvider {
  static const _idTokenKey = 'idToken';
  static const _fallbackTokenKey = 'token';

  final FlutterSecureStorage _storage;
  final AuthRemoteDataSource _authDataSource;

  FirebaseAuthTokenProvider(this._storage, this._authDataSource);

  @override
  Future<String?> getToken() async {
    final token = await _storage.read(key: _idTokenKey);
    if (token != null && token.isNotEmpty) return token;
    return _storage.read(key: _fallbackTokenKey);
  }

  @override
  Future<String?> refreshToken() async {
    final newToken = await _authDataSource.refreshIdToken();
    if (newToken != null && newToken.isNotEmpty) {
      await _storage.write(key: _idTokenKey, value: newToken);
    }
    return newToken;
  }
}
