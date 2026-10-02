import 'package:equatable/equatable.dart';

/// Entidad de dominio del usuario autenticado.
class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String username;
  final String? photoUrl;
  final List<String> groupIds;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.username,
    this.photoUrl,
    this.groupIds = const [],
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, email, name, username, photoUrl, groupIds];
}
