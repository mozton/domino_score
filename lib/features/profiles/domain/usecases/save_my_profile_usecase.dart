import 'package:dominos_score/features/profiles/domain/entities/profile_entity.dart';
import 'package:dominos_score/features/profiles/domain/repositories/profile_repository.dart';

/// Guarda el perfil del usuario autenticado.
class SaveMyProfileUseCase {
  final ProfileRepository _repository;

  SaveMyProfileUseCase(this._repository);

  Future<Profile> call(Profile profile) {
    return _repository.saveMyProfile(
      profile.copyWith(updatedAt: DateTime.now()),
    );
  }
}
