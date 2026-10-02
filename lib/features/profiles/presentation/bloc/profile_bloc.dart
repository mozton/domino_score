import 'package:dominos_score/features/profiles/domain/entities/achievement_entity.dart';
import 'package:dominos_score/features/profiles/domain/entities/match_summary_entity.dart';
import 'package:dominos_score/features/profiles/domain/entities/profile_entity.dart';
import 'package:dominos_score/features/profiles/domain/entities/player_stats_entity.dart';
import 'package:dominos_score/features/profiles/domain/usecases/compute_achievements_usecase.dart';
import 'package:dominos_score/features/profiles/domain/usecases/get_my_profile_usecase.dart';
import 'package:dominos_score/features/profiles/domain/usecases/get_my_recent_matches_usecase.dart';
import 'package:dominos_score/features/profiles/domain/usecases/get_my_stats_usecase.dart';
import 'package:dominos_score/features/profiles/domain/usecases/save_my_profile_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_event.dart';
part 'profile_state.dart';

/// BLoC del perfil del usuario (identidad editable, estadísticas, medallas).
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetMyProfileUseCase _getMyProfile;
  final SaveMyProfileUseCase _saveMyProfile;
  final GetMyStatsUseCase _getMyStats;
  final ComputeAchievementsUseCase _computeAchievements;
  final GetMyRecentMatchesUseCase _getMyRecentMatches;

  ProfileBloc({
    required GetMyProfileUseCase getMyProfile,
    required SaveMyProfileUseCase saveMyProfile,
    required GetMyStatsUseCase getMyStats,
    required ComputeAchievementsUseCase computeAchievements,
    required GetMyRecentMatchesUseCase getMyRecentMatches,
  }) : _getMyProfile = getMyProfile,
       _saveMyProfile = saveMyProfile,
       _getMyStats = getMyStats,
       _computeAchievements = computeAchievements,
       _getMyRecentMatches = getMyRecentMatches,
       super(const ProfileState()) {
    on<ProfileLoadRequested>(_onLoad);
    on<ProfileSaved>(_onSave);
    on<ProfileErrorCleared>(_onClearError);
  }

  Future<void> _onLoad(
    ProfileLoadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading, errorMessage: null));
    try {
      final profile = await _getMyProfile(
        email: event.email,
        displayName: event.displayName,
      );
      final stats = await _getMyStats();
      final achievements = _computeAchievements(stats);
      final recentMatches = await _getMyRecentMatches();

      emit(
        state.copyWith(
          status: ProfileStatus.ready,
          profile: profile,
          stats: stats,
          achievements: achievements,
          recentMatches: recentMatches,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ProfileStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onSave(
    ProfileSaved event,
    Emitter<ProfileState> emit,
  ) async {
    final current = state.profile;
    if (current == null) return;

    emit(
      state.copyWith(
        status: ProfileStatus.saving,
        errorMessage: null,
        successMessage: null,
      ),
    );

    try {
      final updated = Profile(
        id: current.id,
        email: current.email,
        displayName: event.displayName,
        nickname: event.nickname,
        avatarUrl: event.avatarUrl,
        createdAt: current.createdAt,
        updatedAt: DateTime.now(),
      );
      final saved = await _saveMyProfile(updated);
      emit(
        state.copyWith(
          status: ProfileStatus.ready,
          profile: saved,
          successMessage: 'Perfil actualizado correctamente.',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ProfileStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onClearError(ProfileErrorCleared event, Emitter<ProfileState> emit) {
    emit(state.copyWith(errorMessage: null, successMessage: null));
  }
}
