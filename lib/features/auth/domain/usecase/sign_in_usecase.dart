import 'package:dominos_score/features/auth/domain/entities/user_entity.dart';
import 'package:dominos_score/features/auth/domain/repositories/auth_repository.dart';

class SignInUseCase {
  final AuthRepository repository;

  SignInUseCase(this.repository);

  Future<User?> call(String email, String password) =>
      repository.signIn(email, password);
}
