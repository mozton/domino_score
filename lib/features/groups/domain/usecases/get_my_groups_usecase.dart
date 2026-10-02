import 'package:dominos_score/features/groups/domain/entities/group_entity.dart';
import 'package:dominos_score/features/groups/domain/repositories/group_repository.dart';

class GetMyGroupsUseCase {
  final GroupRepository _groupRepository;

  GetMyGroupsUseCase(this._groupRepository);

  Future<List<Group>> call() => _groupRepository.getMyGroups();
}
