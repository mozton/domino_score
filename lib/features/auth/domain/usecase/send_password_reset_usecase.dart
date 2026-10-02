import 'package:dominos_score/features/auth/domain/repositories/auth_repository.dart';

class SendPasswordResetUseCase {
  final AuthRepository repository;

  SendPasswordResetUseCase(this.repository);

  Future<void> call(String email) => repository.sendPasswordResetEmail(email);
}
