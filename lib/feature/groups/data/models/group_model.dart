import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/group_entity.dart';

class GroupModel extends GroupEntity {
  const GroupModel({
    required super.id,
    required super.name,
    super.description,
    required super.joinCode,
    required super.ownerId,
    super.membersCount,
    super.gamesCount,
    super.currentLeaderId,
    super.currentLeaderName,
    required super.createdAt,
  });

  factory GroupModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return GroupModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'],
      joinCode: data['joinCode'] ?? '',
      ownerId: data['ownerId'] ?? '',
      membersCount: data['membersCount'] ?? 0,
      gamesCount: data['gamesCount'] ?? 0,
      currentLeaderId: data['currentLeaderId'],
      currentLeaderName: data['currentLeaderName'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'joinCode': joinCode,
      'ownerId': ownerId,
      'membersCount': membersCount,
      'gamesCount': gamesCount,
      'currentLeaderId': currentLeaderId,
      'currentLeaderName': currentLeaderName,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
