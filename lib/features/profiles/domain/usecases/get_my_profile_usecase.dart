import 'package:dominos_score/core/error/app_exception.dart';
import 'package:dominos_score/core/network/current_user_provider.dart';
import 'package:dominos_score/features/profiles/domain/entities/profile_entity.dart';
import 'package:dominos_score/features/profiles/domain/repositories/profile_repository.dart';

/// Carga el perfil del usuario. Si todavía no existe en Firestore, devuelve un
/// perfil por defecto (sin persistir) construido con los datos de la sesión.
class GetMyProfileUseCase {
  final ProfileRepository _repository;
  final CurrentUserProvider _currentUser;

  GetMyProfileUseCase(this._repository, this._currentUser);

  Future<Profile> call({
    required String email,
    required String displayName,
  }) async {
    final uid = await _currentUser.currentUserId();
    if (uid == null || uid.isEmpty) {
      throw AppException('Sesión no válida. Inicia sesión de nuevo.');
    }

    final remote = await _repository.getMyProfile();
    if (remote != null) return remote;

    final now = DateTime.now();
    final name = displayName.trim().isEmpty ? 'Usuario' : displayName.trim();
    return Profile(
      id: uid,
      email: email,
      displayName: name,
      nickname: name,
      createdAt: now,
      updatedAt: now,
    );
  }
}
