import 'package:dominos_score/core/error/app_exception.dart';
import 'package:dominos_score/core/network/current_user_provider.dart';
import 'package:dominos_score/features/groups/domain/entities/group_entity.dart';
import 'package:dominos_score/features/groups/domain/repositories/group_repository.dart';

class LeaveGroupUseCase {
  final GroupRepository _groupRepository;
  final CurrentUserProvider _currentUser;

  LeaveGroupUseCase(this._groupRepository, this._currentUser);

  Future<Group?> call(Group group) async {
    final uid = await _currentUser.currentUserId();
    if (uid == null || uid.isEmpty) {
      throw AppException('Sesión no válida. Inicia sesión de nuevo.');
    }
    return _groupRepository.leaveGroup(group: group, userId: uid);
  }
}
