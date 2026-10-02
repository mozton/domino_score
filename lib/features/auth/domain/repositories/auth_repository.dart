import 'package:dominos_score/features/auth/domain/entities/user_entity.dart';

/// Contrato del repositorio de autenticación.
abstract class AuthRepository {
  Future<User?> signIn(String email, String password);
  Future<User?> signUp(String email, String password);
  Future<void> signOut();
  Future<User?> checkAuthStatus();
  Future<void> sendPasswordResetEmail(String email);
  Future<void> deleteUser();
  Future<void> acceptPrivacyPolicy();
  Future<bool> isPrivacyPolicyAccepted();
  Future<void> rejectPrivacyPolicy();
}
