import 'package:dominos_score/features/groups/domain/entities/group_entity.dart';

/// Mapea un grupo entre la entidad de dominio y el documento de Firestore.
class GroupModel {
  static Group fromMap(String id, Map<String, dynamic> map) {
    final createdAt = map['createdAt'];
    final memberIds = map['memberIds'];
    return Group(
      id: id,
      name: map['name'] as String? ?? '',
      description: map['description'] as String?,
      joinCode: map['joinCode'] as String? ?? '',
      ownerId: map['ownerId'] as String? ?? '',
      memberIds: memberIds is List
          ? memberIds.map((e) => e.toString()).toList()
          : const [],
      membersCount: (map['membersCount'] as num?)?.toInt() ?? 0,
      gamesCount: (map['gamesCount'] as num?)?.toInt() ?? 0,
      currentLeaderId: map['currentLeaderId'] as String?,
      currentLeaderName: map['currentLeaderName'] as String?,
      createdAt: createdAt is DateTime ? createdAt : DateTime.now(),
    );
  }

  static Map<String, dynamic> toMap(Group group) {
    return {
      'name': group.name,
      'description': group.description,
      'joinCode': group.joinCode,
      'ownerId': group.ownerId,
      'memberIds': group.memberIds,
      'membersCount': group.membersCount,
      'gamesCount': group.gamesCount,
      'currentLeaderId': group.currentLeaderId,
      'currentLeaderName': group.currentLeaderName,
      'createdAt': group.createdAt,
    };
  }
}
