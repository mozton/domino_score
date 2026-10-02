import 'package:equatable/equatable.dart';

/// Perfil de un usuario de la app.
class Profile extends Equatable {
  final String id;
  final String email;
  final String displayName;
  final String nickname;
  final String? avatarUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Profile({
    required this.id,
    required this.email,
    required this.displayName,
    required this.nickname,
    this.avatarUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  Profile copyWith({
    String? id,
    String? email,
    String? displayName,
    String? nickname,
    String? avatarUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Profile(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      nickname: nickname ?? this.nickname,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    email,
    displayName,
    nickname,
    avatarUrl,
    createdAt,
    updatedAt,
  ];
}
