import 'package:dominos_score/features/auth/domain/repositories/auth_repository.dart';

class DeleteAccountUseCase {
  final AuthRepository repository;

  DeleteAccountUseCase(this.repository);

  Future<void> call() => repository.deleteUser();
}
