import 'package:dominos_score/core/network/current_user_provider.dart';
import 'package:dominos_score/features/groups/domain/entities/group_detail_entity.dart';
import 'package:dominos_score/features/groups/domain/entities/group_member_entity.dart';
import 'package:dominos_score/features/groups/domain/repositories/group_repository.dart';
import 'package:dominos_score/features/groups/domain/usecases/build_my_member_usecase.dart';

/// Actualiza el documento del miembro actual con su perfil y estadísticas
/// frescas (preservando su rol y fecha de ingreso).
class SyncMyMemberUseCase {
  final GroupRepository _groupRepository;
  final BuildMyMemberUseCase _buildMyMember;
  final CurrentUserProvider _currentUser;

  SyncMyMemberUseCase(
    this._groupRepository,
    this._buildMyMember,
    this._currentUser,
  );

  Future<GroupMember?> call(GroupDetail detail) async {
    final uid = await _currentUser.currentUserId();
    if (uid == null || uid.isEmpty) return null;

    GroupMember? existing;
    for (final member in detail.members) {
      if (member.userId == uid) {
        existing = member;
        break;
      }
    }
    if (existing == null) return null;

    final updated = await _buildMyMember(
      role: existing.role,
      joinedAt: existing.joinedAt,
    );
    await _groupRepository.upsertMember(detail.group.id, updated);
    return updated;
  }
}
