import 'package:dominos_score/core/error/app_exception.dart';
import 'package:dominos_score/features/groups/domain/entities/group_entity.dart';
import 'package:dominos_score/features/groups/domain/entities/group_member_entity.dart';
import 'package:dominos_score/features/groups/domain/repositories/group_repository.dart';
import 'package:dominos_score/features/groups/domain/usecases/build_my_member_usecase.dart';

class CreateGroupUseCase {
  final GroupRepository _groupRepository;
  final BuildMyMemberUseCase _buildMyMember;

  CreateGroupUseCase(this._groupRepository, this._buildMyMember);

  Future<Group> call({required String name, String? description}) async {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      throw AppException('El nombre del grupo es obligatorio.');
    }

    final trimmedDescription = description?.trim();
    final owner = await _buildMyMember(role: GroupRole.owner);

    return _groupRepository.createGroup(
      name: trimmedName,
      description: (trimmedDescription == null || trimmedDescription.isEmpty)
          ? null
          : trimmedDescription,
      owner: owner,
    );
  }
}
