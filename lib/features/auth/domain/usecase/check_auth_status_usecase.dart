import 'package:dominos_score/features/auth/domain/entities/user_entity.dart';
import 'package:dominos_score/features/auth/domain/repositories/auth_repository.dart';

class CheckAuthStatusUseCase {
  final AuthRepository repository;

  CheckAuthStatusUseCase(this.repository);

  Future<User?> call() => repository.checkAuthStatus();
}
