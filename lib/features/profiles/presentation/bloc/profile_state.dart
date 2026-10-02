part of 'profile_bloc.dart';

enum ProfileStatus { initial, loading, ready, saving, error }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final Profile? profile;
  final PlayerStats stats;
  final List<Achievement> achievements;
  final List<MatchSummary> recentMatches;
  final String? errorMessage;
  final String? successMessage;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.profile,
    this.stats = PlayerStats.empty,
    this.achievements = const [],
    this.recentMatches = const [],
    this.errorMessage,
    this.successMessage,
  });

  static const Object _unset = Object();

  ProfileState copyWith({
    ProfileStatus? status,
    Object? profile = _unset,
    PlayerStats? stats,
    List<Achievement>? achievements,
    List<MatchSummary>? recentMatches,
    Object? errorMessage = _unset,
    Object? successMessage = _unset,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: identical(profile, _unset) ? this.profile : profile as Profile?,
      stats: stats ?? this.stats,
      achievements: achievements ?? this.achievements,
      recentMatches: recentMatches ?? this.recentMatches,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
      successMessage: identical(successMessage, _unset)
          ? this.successMessage
          : successMessage as String?,
    );
  }

  @override
  List<Object?> get props => [
    status,
    profile,
    stats,
    achievements,
    recentMatches,
    errorMessage,
    successMessage,
  ];
}
