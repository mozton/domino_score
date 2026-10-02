import 'package:dominos_score/features/groups/domain/entities/group_entity.dart';
import 'package:dominos_score/features/groups/domain/repositories/group_repository.dart';

class RemoveGroupMemberUseCase {
  final GroupRepository _groupRepository;

  RemoveGroupMemberUseCase(this._groupRepository);

  Future<Group> call(Group group, String userId) =>
      _groupRepository.removeMember(group: group, userId: userId);
}
