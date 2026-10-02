/// Provee el ID token de Firebase para autenticar peticiones (p. ej. Firestore
/// REST) y permite refrescarlo cuando expira.
abstract class AuthTokenProvider {
  Future<String?> getToken();
  Future<String?> refreshToken();
}
