import 'package:equatable/equatable.dart';

class UserProfileEntity extends Equatable {
  final String id; // El UID de Firebase Auth
  final String email;
  final String displayName;
  final String? globalAvatarUrl;
  final DateTime createdAt;

  const UserProfileEntity({
    required this.id,
    required this.email,
    required this.displayName,
    this.globalAvatarUrl,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    email,
    displayName,
    globalAvatarUrl,
    createdAt,
  ];
}
