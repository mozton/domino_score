import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dominos_score/feature/profiles/domain/entities/profile_entity.dart';

class UserProfileModel extends UserProfileEntity {
  const UserProfileModel({
    required super.id,
    required super.email,
    required super.displayName,
    super.globalAvatarUrl,
    required super.createdAt,
  });

  factory UserProfileModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserProfileModel(
      id: doc.id,
      email: data['email'] ?? '',
      displayName: data['displayName'] ?? '',
      globalAvatarUrl: data['globalAvatarUrl'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': displayName,
      'globalAvatarUrl': globalAvatarUrl,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
