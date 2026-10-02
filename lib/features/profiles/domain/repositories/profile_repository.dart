import 'package:dominos_score/features/profiles/domain/entities/profile_entity.dart';

abstract class ProfileRepository {
  /// Perfil del usuario autenticado (o `null` si aún no existe en Firestore).
  Future<Profile?> getMyProfile();

  /// Crea o actualiza el perfil del usuario autenticado.
  Future<Profile> saveMyProfile(Profile profile);
}
