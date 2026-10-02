import 'dart:math';

import 'package:dominos_score/core/error/app_exception.dart';
import 'package:dominos_score/core/network/current_user_provider.dart';
import 'package:dominos_score/features/groups/data/datasources/group_remote_data_source.dart';
import 'package:dominos_score/features/groups/domain/entities/group_detail_entity.dart';
import 'package:dominos_score/features/groups/domain/entities/group_entity.dart';
import 'package:dominos_score/features/groups/domain/entities/group_member_entity.dart';
import 'package:dominos_score/features/groups/domain/repositories/group_repository.dart';
import 'package:dominos_score/features/profiles/domain/entities/player_stats_entity.dart';

class GroupRepositoryImpl implements GroupRepository {
  static const _idChars =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  static const _codeChars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

  final GroupRemoteDataSource _remoteDataSource;
  final CurrentUserProvider _currentUser;
  final Random _random;

  GroupRepositoryImpl(
    this._remoteDataSource,
    this._currentUser, {
    Random? random,
  }) : _random = random ?? Random();

  String _generateId() => List.generate(
    20,
    (_) => _idChars[_random.nextInt(_idChars.length)],
  ).join();

  String _generateJoinCode() => List.generate(
    6,
    (_) => _codeChars[_random.nextInt(_codeChars.length)],
  ).join();

  Future<String> _requireUserId() async {
    final uid = await _currentUser.currentUserId();
    if (uid == null || uid.isEmpty) {
      throw AppException('Sesión no válida. Inicia sesión de nuevo.');
    }
    return uid;
  }

  @override
  Future<Group> createGroup({
    required String name,
    String? description,
    required GroupMember owner,
  }) async {
    var joinCode = _generateJoinCode();
    for (var attempt = 0; attempt < 5; attempt++) {
      final existing = await _remoteDataSource.findByJoinCode(joinCode);
      if (existing == null) break;
      joinCode = _generateJoinCode();
    }

    final group = Group(
      id: _generateId(),
      name: name,
      description: description,
      joinCode: joinCode,
      ownerId: owner.userId,
      memberIds: [owner.userId],
      membersCount: 1,
      gamesCount: 0,
      currentLeaderId: owner.userId,
      currentLeaderName: owner.displayName,
      createdAt: DateTime.now(),
    );

    return _remoteDataSource.createGroup(group, owner);
  }

  @override
  Future<Group?> findByJoinCode(String joinCode) =>
      _remoteDataSource.findByJoinCode(joinCode);

  @override
  Future<Group> joinGroup({
    required Group group,
    required GroupMember member,
  }) async {
    final memberIds = [...group.memberIds];
    if (!memberIds.contains(member.userId)) {
      memberIds.add(member.userId);
    }

    final updated = Group(
      id: group.id,
      name: group.name,
      description: group.description,
      joinCode: group.joinCode,
      ownerId: group.ownerId,
      memberIds: memberIds,
      membersCount: memberIds.length,
      gamesCount: group.gamesCount,
      currentLeaderId: group.currentLeaderId ?? member.userId,
      currentLeaderName: group.currentLeaderName ?? member.displayName,
      createdAt: group.createdAt,
    );

    await _remoteDataSource.updateGroup(updated);
    await _remoteDataSource.upsertMember(group.id, member);
    return updated;
  }

  @override
  Future<List<Group>> getMyGroups() async {
    final uid = await _requireUserId();
    final groups = await _remoteDataSource.getGroupsByMember(uid);
    groups.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return groups;
  }

  @override
  Future<GroupDetail> getGroupDetail(String groupId) async {
    final group = await _remoteDataSource.getGroup(groupId);
    if (group == null) {
      throw AppException('El grupo no existe o fue eliminado.');
    }
    final members = await _remoteDataSource.getMembers(groupId);
    members.sort(
      (a, b) => b.stats.totalPoints.compareTo(a.stats.totalPoints),
    );
    return GroupDetail(group: group, members: members);
  }

  @override
  Future<Group> updateGroup({
    required String groupId,
    required String name,
    String? description,
  }) async {
    final group = await _remoteDataSource.getGroup(groupId);
    if (group == null) {
      throw AppException('El grupo no existe o fue eliminado.');
    }

    final updated = Group(
      id: group.id,
      name: name,
      description: description,
      joinCode: group.joinCode,
      ownerId: group.ownerId,
      memberIds: group.memberIds,
      membersCount: group.membersCount,
      gamesCount: group.gamesCount,
      currentLeaderId: group.currentLeaderId,
      currentLeaderName: group.currentLeaderName,
      createdAt: group.createdAt,
    );

    return _remoteDataSource.updateGroup(updated);
  }

  @override
  Future<void> deleteGroup(String groupId) =>
      _remoteDataSource.deleteGroup(groupId);

  @override
  Future<Group?> leaveGroup({
    required Group group,
    required String userId,
  }) async {
    final memberIds = group.memberIds.where((id) => id != userId).toList();

    if (memberIds.isEmpty) {
      await _remoteDataSource.deleteGroup(group.id);
      return null;
    }

    var ownerId = group.ownerId;
    var leaderId = group.currentLeaderId;
    var leaderName = group.currentLeaderName;

    if (ownerId == userId) {
      ownerId = memberIds.first;
      leaderId = ownerId;
      final members = await _remoteDataSource.getMembers(group.id);
      for (final member in members) {
        if (member.userId == ownerId) {
          leaderName = member.displayName;
          break;
        }
      }
    }

    final updated = Group(
      id: group.id,
      name: group.name,
      description: group.description,
      joinCode: group.joinCode,
      ownerId: ownerId,
      memberIds: memberIds,
      membersCount: memberIds.length,
      gamesCount: group.gamesCount,
      currentLeaderId: leaderId,
      currentLeaderName: leaderName,
      createdAt: group.createdAt,
    );

    await _remoteDataSource.updateGroup(updated);
    await _remoteDataSource.deleteMember(group.id, userId);
    return updated;
  }

  @override
  Future<Group> removeMember({
    required Group group,
    required String userId,
  }) async {
    final memberIds = group.memberIds.where((id) => id != userId).toList();

    var ownerId = group.ownerId;
    var leaderId = group.currentLeaderId;
    var leaderName = group.currentLeaderName;

    if (ownerId == userId && memberIds.isNotEmpty) {
      ownerId = memberIds.first;
      leaderId = ownerId;
      final members = await _remoteDataSource.getMembers(group.id);
      for (final member in members) {
        if (member.userId == ownerId) {
          leaderName = member.displayName;
          break;
        }
      }
    }

    final updated = Group(
      id: group.id,
      name: group.name,
      description: group.description,
      joinCode: group.joinCode,
      ownerId: ownerId,
      memberIds: memberIds,
      membersCount: memberIds.length,
      gamesCount: group.gamesCount,
      currentLeaderId: leaderId,
      currentLeaderName: leaderName,
      createdAt: group.createdAt,
    );

    await _remoteDataSource.updateGroup(updated);
    await _remoteDataSource.deleteMember(group.id, userId);
    return updated;
  }

  @override
  Future<Group> addGuest({
    required Group group,
    required String displayName,
    String? nickname,
  }) async {
    final trimmedNickname = nickname?.trim();
    final guest = GroupMember(
      userId: 'guest_${_generateId()}',
      isGuest: true,
      displayName: displayName.trim(),
      nickname: (trimmedNickname == null || trimmedNickname.isEmpty)
          ? displayName.trim()
          : trimmedNickname,
      role: GroupRole.viewer,
      stats: PlayerStats.empty,
      joinedAt: DateTime.now(),
    );

    final memberIds = [...group.memberIds, guest.userId];
    final updated = Group(
      id: group.id,
      name: group.name,
      description: group.description,
      joinCode: group.joinCode,
      ownerId: group.ownerId,
      memberIds: memberIds,
      membersCount: memberIds.length,
      gamesCount: group.gamesCount,
      currentLeaderId: group.currentLeaderId,
      currentLeaderName: group.currentLeaderName,
      createdAt: group.createdAt,
    );

    await _remoteDataSource.updateGroup(updated);
    await _remoteDataSource.upsertMember(group.id, guest);
    return updated;
  }

  @override
  Future<Group> setGroupLeader({
    required Group group,
    required GroupMember leader,
  }) async {
    final updated = Group(
      id: group.id,
      name: group.name,
      description: group.description,
      joinCode: group.joinCode,
      ownerId: group.ownerId,
      memberIds: group.memberIds,
      membersCount: group.membersCount,
      gamesCount: group.gamesCount,
      currentLeaderId: leader.userId,
      currentLeaderName: leader.displayName,
      createdAt: group.createdAt,
    );
    return _remoteDataSource.updateGroup(updated);
  }

  @override
  Future<void> upsertMember(String groupId, GroupMember member) =>
      _remoteDataSource.upsertMember(groupId, member);
}
