import 'package:dominos_score/features/auth/domain/entities/user_entity.dart';
import 'package:dominos_score/features/auth/domain/repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  Future<User?> call(String email, String password) =>
      repository.signUp(email, password);
}
