abstract class RemoteAuthDataSource {
  Future<Map<String, dynamic>> createUser(String email, String password);
  Future<Map<String, dynamic>> login(String email, String password);
  Future<Map<String, dynamic>> getUserData(String token);

  Future<void> logout();
  Future<String> readToken();

  Future<void> verifyEmail(String token) async {}
}
