import 'package:dominos_score/features/profiles/domain/entities/profile_entity.dart';

/// Mapea un perfil entre la entidad de dominio y el documento de Firestore.
class ProfileModel {
  static Profile fromMap(String id, Map<String, dynamic> map) {
    final createdAt = map['createdAt'];
    final updatedAt = map['updatedAt'];
    return Profile(
      id: id,
      email: map['email'] as String? ?? '',
      displayName: map['displayName'] as String? ?? '',
      nickname: map['nickname'] as String? ?? '',
      avatarUrl: map['avatarUrl'] as String?,
      createdAt: createdAt is DateTime ? createdAt : DateTime.now(),
      updatedAt: updatedAt is DateTime ? updatedAt : DateTime.now(),
    );
  }

  static Map<String, dynamic> toMap(Profile profile) {
    return {
      'email': profile.email,
      'displayName': profile.displayName,
      'nickname': profile.nickname,
      'avatarUrl': profile.avatarUrl,
      'createdAt': profile.createdAt,
      'updatedAt': profile.updatedAt,
    };
  }
}
