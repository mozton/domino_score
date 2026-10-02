import 'package:dominos_score/features/groups/domain/entities/group_entity.dart';
import 'package:dominos_score/features/groups/domain/entities/group_member_entity.dart';

abstract class GroupRemoteDataSource {
  Future<Group> createGroup(Group group, GroupMember owner);
  Future<Group?> getGroup(String groupId);
  Future<Group?> findByJoinCode(String joinCode);
  Future<List<Group>> getGroupsByMember(String userId);
  Future<Group> updateGroup(Group group);
  Future<void> deleteGroup(String groupId);
  Future<List<GroupMember>> getMembers(String groupId);
  Future<void> upsertMember(String groupId, GroupMember member);
  Future<void> deleteMember(String groupId, String userId);
}
