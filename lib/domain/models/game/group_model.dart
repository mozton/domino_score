import 'package:dominos_score/domain/models/auth/user_role.dart';

class GroupModel {
  final String id;
  final String name;
  final String? description;
  final String? groupPhotoUrl;
  final String ownerId; // El creador del grupo (Super Admin)

  // RELACIÓN: Miembros y sus roles.
  // Map<UserId, Role> -> Ej: {'user123': UserRole.admin, 'user456': UserRole.viewer}
  final Map<String, UserRole> members; 
  
  // RELACIÓN: IDs de las partidas que pertenecen a este grupo
  final List<String> gameIds;

  GroupModel({
    required this.id,
    required this.name,
    this.description,
    this.groupPhotoUrl,
    required this.ownerId,
    this.members = const {},
    this.gameIds = const [],
  });

  // Helper para saber si un usuario es miembro
  bool isMember(String userId) => members.containsKey(userId);

  // Helper para obtener el rol de un usuario
  UserRole getRole(String userId) => members[userId] ?? UserRole.viewer;

  // Factory y toMap...
  factory GroupModel.fromMap(Map<String, dynamic> map) {
    // Lógica para convertir el mapa de miembros
    final membersMap = Map<String, dynamic>.from(map['members'] ?? {});
    final parsedMembers = membersMap.map(
      (key, value) => MapEntry(key, UserRole.fromString(value)),
    );

    return GroupModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'],
      groupPhotoUrl: map['groupPhotoUrl'],
      ownerId: map['ownerId'] ?? '',
      members: parsedMembers,
      gameIds: List<String>.from(map['gameIds'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    // Convertir el enum a String para guardar
    final membersMap = members.map(
      (key, value) => MapEntry(key, value.toShortString()),
    );

    return {
      'id': id,
      'name': name,
      'description': description,
      'groupPhotoUrl': groupPhotoUrl,
      'ownerId': ownerId,
      'members': membersMap,
      'gameIds': gameIds,
    };
  }
}