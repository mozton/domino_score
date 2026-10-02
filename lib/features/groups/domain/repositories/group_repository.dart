import 'package:dominos_score/features/groups/domain/entities/group_detail_entity.dart';
import 'package:dominos_score/features/groups/domain/entities/group_entity.dart';
import 'package:dominos_score/features/groups/domain/entities/group_member_entity.dart';

abstract class GroupRepository {
  Future<Group> createGroup({
    required String name,
    String? description,
    required GroupMember owner,
  });

  Future<Group?> findByJoinCode(String joinCode);

  Future<Group> joinGroup({
    required Group group,
    required GroupMember member,
  });

  Future<List<Group>> getMyGroups();

  Future<GroupDetail> getGroupDetail(String groupId);

  Future<Group> updateGroup({
    required String groupId,
    required String name,
    String? description,
  });

  Future<void> deleteGroup(String groupId);

  /// Devuelve el grupo actualizado, o `null` si el grupo se eliminó porque el
  /// usuario era el único miembro.
  Future<Group?> leaveGroup({required Group group, required String userId});

  /// Quita a otro miembro del grupo (gestión desde el detalle).
  Future<Group> removeMember({required Group group, required String userId});

  /// Añade un invitado (sin cuenta) al grupo.
  Future<Group> addGuest({
    required Group group,
    required String displayName,
    String? nickname,
  });

  Future<Group> setGroupLeader({
    required Group group,
    required GroupMember leader,
  });

  Future<void> upsertMember(String groupId, GroupMember member);
}
