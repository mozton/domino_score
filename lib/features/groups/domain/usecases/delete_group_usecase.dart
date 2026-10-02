import 'package:dominos_score/features/groups/domain/repositories/group_repository.dart';

class DeleteGroupUseCase {
  final GroupRepository _groupRepository;

  DeleteGroupUseCase(this._groupRepository);

  Future<void> call(String groupId) => _groupRepository.deleteGroup(groupId);
}
