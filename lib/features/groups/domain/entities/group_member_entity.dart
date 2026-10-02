import 'package:dominos_score/features/profiles/domain/entities/player_stats_entity.dart';
import 'package:equatable/equatable.dart';

/// Rol de un miembro dentro de un grupo.
enum GroupRole {
  owner,
  admin,
  editor,
  viewer;

  String get value => name;

  static GroupRole fromString(String? value) {
    return GroupRole.values.firstWhere(
      (e) => e.name == value,
      orElse: () => GroupRole.viewer,
    );
  }
}

/// Miembro de un grupo.
class GroupMember extends Equatable {
  final String userId;
  final bool isGuest;
  final String displayName;
  final String nickname;
  final String? avatarUrl;
  final GroupRole role;
  final PlayerStats stats;
  final DateTime joinedAt;

  const GroupMember({
    required this.userId,
    this.isGuest = false,
    required this.displayName,
    required this.nickname,
    this.avatarUrl,
    this.role = GroupRole.viewer,
    this.stats = PlayerStats.empty,
    required this.joinedAt,
  });

  bool get isOwner => role == GroupRole.owner;
  bool get isAdmin => role == GroupRole.owner || role == GroupRole.admin;

  /// Iniciales para el avatar (máx. 2 letras).
  String get initials {
    final trimmed = displayName.trim();
    if (trimmed.isEmpty) return '?';
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
  }

  GroupMember copyWith({
    String? userId,
    bool? isGuest,
    String? displayName,
    String? nickname,
    String? avatarUrl,
    GroupRole? role,
    PlayerStats? stats,
    DateTime? joinedAt,
  }) {
    return GroupMember(
      userId: userId ?? this.userId,
      isGuest: isGuest ?? this.isGuest,
      displayName: displayName ?? this.displayName,
      nickname: nickname ?? this.nickname,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      stats: stats ?? this.stats,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }

  @override
  List<Object?> get props => [
    userId,
    isGuest,
    displayName,
    nickname,
    avatarUrl,
    role,
    stats,
    joinedAt,
  ];
}
