import 'package:dominos_score/domain/models/auth/user_model.dart';

abstract class AuthRepository {
  Future<UserModel?> signIn(String email, String password);
  Future<UserModel?> signUp(String email, String password);
  Future<void> signOut();
  Future<UserModel?> checkAuthStatus();
  Future<void> sendEmailVerification();
  Future<bool> isEmailVerified();
}
