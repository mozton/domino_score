part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

/// Carga el perfil. Se pasan datos de la sesión por si el perfil aún no existe.
class ProfileLoadRequested extends ProfileEvent {
  final String email;
  final String displayName;

  const ProfileLoadRequested({
    required this.email,
    required this.displayName,
  });

  @override
  List<Object?> get props => [email, displayName];
}

class ProfileSaved extends ProfileEvent {
  final String displayName;
  final String nickname;
  final String? avatarUrl;

  const ProfileSaved({
    required this.displayName,
    required this.nickname,
    this.avatarUrl,
  });

  @override
  List<Object?> get props => [displayName, nickname, avatarUrl];
}

class ProfileErrorCleared extends ProfileEvent {
  const ProfileErrorCleared();
}
