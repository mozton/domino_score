import 'package:dominos_score/features/groups/domain/entities/group_entity.dart';
import 'package:dominos_score/features/groups/domain/entities/group_member_entity.dart';
import 'package:dominos_score/features/groups/domain/repositories/group_repository.dart';

class SetGroupLeaderUseCase {
  final GroupRepository _groupRepository;

  SetGroupLeaderUseCase(this._groupRepository);

  Future<Group> call(Group group, GroupMember leader) =>
      _groupRepository.setGroupLeader(group: group, leader: leader);
}
