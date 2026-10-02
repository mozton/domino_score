import 'package:dominos_score/core/network/auth_token_provider.dart';
import 'package:dominos_score/core/utils/jwt_utils.dart';

/// Permite conocer el id del usuario autenticado actual.
abstract class CurrentUserProvider {
  Future<String?> currentUserId();
}

class TokenCurrentUserProvider implements CurrentUserProvider {
  final AuthTokenProvider _tokenProvider;

  TokenCurrentUserProvider(this._tokenProvider);

  @override
  Future<String?> currentUserId() async {
    final token = await _tokenProvider.getToken();
    return JwtUtils.userIdFromIdToken(token);
  }
}
