import 'package:dominos_score/features/groups/domain/entities/group_detail_entity.dart';
import 'package:dominos_score/features/groups/domain/repositories/group_repository.dart';

class GetGroupDetailUseCase {
  final GroupRepository _groupRepository;

  GetGroupDetailUseCase(this._groupRepository);

  Future<GroupDetail> call(String groupId) =>
      _groupRepository.getGroupDetail(groupId);
}
