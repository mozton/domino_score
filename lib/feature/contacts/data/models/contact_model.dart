import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/contact_entity.dart';

class ContactModel extends ContactEntity {
  const ContactModel({
    required super.id,
    super.registeredUserId,
    required super.isRegisteredUser,
    required super.displayName,
    super.nickname,
    super.avatarUrl,
    required super.addedAt,
  });

  factory ContactModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ContactModel(
      id: doc.id,
      registeredUserId: data['registeredUserId'],
      isRegisteredUser: data['isRegisteredUser'] ?? false,
      displayName: data['displayName'] ?? '',
      nickname: data['nickname'],
      avatarUrl: data['avatarUrl'],
      addedAt: (data['addedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'registeredUserId': registeredUserId,
      'isRegisteredUser': isRegisteredUser,
      'displayName': displayName,
      'nickname': nickname,
      'avatarUrl': avatarUrl,
      'addedAt': Timestamp.fromDate(addedAt),
    };
  }
}
