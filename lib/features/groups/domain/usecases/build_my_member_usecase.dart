import 'package:dominos_score/core/error/app_exception.dart';
import 'package:dominos_score/core/network/current_user_provider.dart';
import 'package:dominos_score/features/groups/domain/entities/group_member_entity.dart';
import 'package:dominos_score/features/profiles/domain/repositories/profile_repository.dart';
import 'package:dominos_score/features/profiles/domain/usecases/get_my_stats_usecase.dart';

/// Construye el [GroupMember] del usuario actual con su perfil y estadísticas.
class BuildMyMemberUseCase {
  final ProfileRepository _profileRepository;
  final GetMyStatsUseCase _getMyStats;
  final CurrentUserProvider _currentUser;

  BuildMyMemberUseCase(
    this._profileRepository,
    this._getMyStats,
    this._currentUser,
  );

  Future<GroupMember> call({
    GroupRole role = GroupRole.viewer,
    DateTime? joinedAt,
  }) async {
    final uid = await _currentUser.currentUserId();
    if (uid == null || uid.isEmpty) {
      throw AppException('Sesión no válida. Inicia sesión de nuevo.');
    }

    final profile = await _profileRepository.getMyProfile();
    final stats = await _getMyStats();
    final displayName = (profile?.displayName ?? '').trim().isEmpty
        ? 'Usuario'
        : profile!.displayName;

    return GroupMember(
      userId: uid,
      isGuest: false,
      displayName: displayName,
      nickname: (profile?.nickname ?? '').trim().isEmpty
          ? displayName
          : profile!.nickname,
      avatarUrl: profile?.avatarUrl,
      role: role,
      stats: stats,
      joinedAt: joinedAt ?? DateTime.now(),
    );
  }
}
