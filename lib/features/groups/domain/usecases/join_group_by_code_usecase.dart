import 'package:dominos_score/core/error/app_exception.dart';
import 'package:dominos_score/features/groups/domain/entities/group_entity.dart';
import 'package:dominos_score/features/groups/domain/entities/group_member_entity.dart';
import 'package:dominos_score/features/groups/domain/repositories/group_repository.dart';
import 'package:dominos_score/features/groups/domain/usecases/build_my_member_usecase.dart';

class JoinGroupByCodeUseCase {
  final GroupRepository _groupRepository;
  final BuildMyMemberUseCase _buildMyMember;

  JoinGroupByCodeUseCase(this._groupRepository, this._buildMyMember);

  Future<Group> call(String joinCode) async {
    final code = joinCode.trim().replaceAll('#', '').toUpperCase();
    if (code.isEmpty) {
      throw AppException('Ingresa un código válido.');
    }

    final found = await _groupRepository.findByJoinCode(code);
    if (found == null) {
      throw AppException('No existe ningún grupo con ese código.');
    }

    final member = await _buildMyMember(role: GroupRole.viewer);
    if (found.isMember(member.userId)) {
      throw AppException('Ya eres miembro de este grupo.');
    }

    return _groupRepository.joinGroup(group: found, member: member);
  }
}
