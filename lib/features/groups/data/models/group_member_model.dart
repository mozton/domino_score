import 'package:dominos_score/features/groups/domain/entities/group_member_entity.dart';
import 'package:dominos_score/features/profiles/domain/entities/player_stats_entity.dart';

/// Mapea un miembro de grupo entre la entidad de dominio y Firestore.
class GroupMemberModel {
  static GroupMember fromMap(String id, Map<String, dynamic> map) {
    final stats = map['stats'];
    final joinedAt = map['joinedAt'];
    return GroupMember(
      userId: (map['userId'] as String?)?.trim().isNotEmpty == true
          ? map['userId'] as String
          : id,
      isGuest: map['isGuest'] as bool? ?? false,
      displayName: map['displayName'] as String? ?? '',
      nickname: map['nickname'] as String? ?? '',
      avatarUrl: map['avatarUrl'] as String?,
      role: GroupRole.fromString(map['role'] as String?),
      stats: stats is Map
          ? PlayerStats.fromMap(Map<String, dynamic>.from(stats))
          : PlayerStats.empty,
      joinedAt: joinedAt is DateTime ? joinedAt : DateTime.now(),
    );
  }

  static Map<String, dynamic> toMap(GroupMember member) {
    return {
      'userId': member.userId,
      'isGuest': member.isGuest,
      'displayName': member.displayName,
      'nickname': member.nickname,
      'avatarUrl': member.avatarUrl,
      'role': member.role.value,
      'stats': member.stats.toMap(),
      'joinedAt': member.joinedAt,
    };
  }
}
