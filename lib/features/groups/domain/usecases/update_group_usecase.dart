import 'package:dominos_score/core/error/app_exception.dart';
import 'package:dominos_score/features/groups/domain/entities/group_entity.dart';
import 'package:dominos_score/features/groups/domain/repositories/group_repository.dart';

class UpdateGroupUseCase {
  final GroupRepository _groupRepository;

  UpdateGroupUseCase(this._groupRepository);

  Future<Group> call({
    required String groupId,
    required String name,
    String? description,
  }) {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      throw AppException('El nombre del grupo es obligatorio.');
    }
    final trimmedDescription = description?.trim();
    return _groupRepository.updateGroup(
      groupId: groupId,
      name: trimmedName,
      description: (trimmedDescription == null || trimmedDescription.isEmpty)
          ? null
          : trimmedDescription,
    );
  }
}
