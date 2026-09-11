import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/group_member_entity.dart';

class GroupMemberModel extends GroupMemberEntity {
  const GroupMemberModel({
    required super.id,
    required super.isGuest,
    required super.displayName,
    required super.nickname,
    super.avatarUrl,
    super.level,
    super.gamesPlayed,
    super.wins,
    super.losses,
    super.capicuasCount,
    super.zapaterosCount,
    super.totalPoints,
    super.currentStreak,
    super.unlockedBadges,
    required super.joinedAt,
  });

  factory GroupMemberModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return GroupMemberModel(
      id: doc.id,
      isGuest: data['isGuest'] ?? false,
      displayName: data['displayName'] ?? '',
      nickname: data['nickname'] ?? '',
      avatarUrl: data['avatarUrl'],
      level: data['level'] ?? 1,
      gamesPlayed: data['gamesPlayed'] ?? 0,
      wins: data['wins'] ?? 0,
      losses: data['losses'] ?? 0,
      capicuasCount: data['capicuasCount'] ?? 0,
      zapaterosCount: data['zapaterosCount'] ?? 0,
      totalPoints: data['totalPoints'] ?? 0,
      currentStreak: data['currentStreak'] ?? 0,
      unlockedBadges: List<String>.from(data['unlockedBadges'] ?? []),
      joinedAt: (data['joinedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'isGuest': isGuest,
      'displayName': displayName,
      'nickname': nickname,
      'avatarUrl': avatarUrl,
      'level': level,
      'gamesPlayed': gamesPlayed,
      'wins': wins,
      'losses': losses,
      'capicuasCount': capicuasCount,
      'zapaterosCount': zapaterosCount,
      'totalPoints': totalPoints,
      'currentStreak': currentStreak,
      'unlockedBadges': unlockedBadges,
      'joinedAt': Timestamp.fromDate(joinedAt),
    };
  }
}
