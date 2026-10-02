import 'package:dominos_score/core/error/app_exception.dart';
import 'package:dominos_score/features/groups/domain/entities/group_entity.dart';
import 'package:dominos_score/features/groups/domain/repositories/group_repository.dart';

class AddGroupGuestUseCase {
  final GroupRepository _groupRepository;

  AddGroupGuestUseCase(this._groupRepository);

  Future<Group> call(
    Group group, {
    required String displayName,
    String? nickname,
  }) {
    final trimmed = displayName.trim();
    if (trimmed.isEmpty) {
      throw AppException('El nombre del jugador es obligatorio.');
    }
    return _groupRepository.addGuest(
      group: group,
      displayName: trimmed,
      nickname: nickname,
    );
  }
}
