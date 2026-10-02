import 'package:dominos_score/features/groups/domain/entities/group_member_entity.dart';
import 'package:dominos_score/features/groups/domain/repositories/group_repository.dart';

class UpdateGroupMemberUseCase {
  final GroupRepository _groupRepository;

  UpdateGroupMemberUseCase(this._groupRepository);

  Future<void> call(String groupId, GroupMember member) =>
      _groupRepository.upsertMember(groupId, member);
}
