import 'package:dominos_score/features/auth/domain/repositories/auth_repository.dart';

class AcceptPrivacyPolicyUseCase {
  final AuthRepository repository;

  AcceptPrivacyPolicyUseCase(this.repository);

  Future<void> call() => repository.acceptPrivacyPolicy();
}

class RejectPrivacyPolicyUseCase {
  final AuthRepository repository;

  RejectPrivacyPolicyUseCase(this.repository);

  Future<void> call() => repository.rejectPrivacyPolicy();
}

class IsPrivacyPolicyAcceptedUseCase {
  final AuthRepository repository;

  IsPrivacyPolicyAcceptedUseCase(this.repository);

  Future<bool> call() => repository.isPrivacyPolicyAccepted();
}
