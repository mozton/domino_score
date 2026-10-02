import 'package:dominos_score/features/contacts/domain/entities/contact_entity.dart';

/// Mapea un contacto entre la entidad de dominio y un documento de Firestore.
class ContactModel {
  static ContactEntity fromMap(String id, Map<String, dynamic> map) {
    final addedAt = map['addedAt'];
    return ContactEntity(
      id: id,
      registeredUserId: map['registeredUserId'] as String?,
      isRegisteredUser: map['isRegisteredUser'] as bool? ?? false,
      displayName: map['displayName'] as String? ?? '',
      nickname: map['nickname'] as String?,
      avatarUrl: map['avatarUrl'] as String?,
      addedAt: addedAt is DateTime ? addedAt : DateTime.now(),
    );
  }

  static Map<String, dynamic> toMap(ContactEntity contact) {
    return {
      'registeredUserId': contact.registeredUserId,
      'isRegisteredUser': contact.isRegisteredUser,
      'displayName': contact.displayName,
      'nickname': contact.nickname,
      'avatarUrl': contact.avatarUrl,
      'addedAt': contact.addedAt,
    };
  }
}
