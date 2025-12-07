import 'package:dominos_score/domain/models/auth/user_role.dart';

class UserModel {
  final String id;          // UID de Firebase o ID de base de datos
  final String email;
  final String name;        // Nombre real (Ej: "Juan Pérez")
  final String username;    // Alias único (Ej: "@juanp")
  final String? photoUrl;   // URL de la imagen o path local
  
  // RELACIÓN: Un usuario puede pertenecer a varios grupos.
  // Guardamos los IDs de los grupos.
  final List<String> groupIds; 
  
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.username,
    this.photoUrl,
    this.groupIds = const [],
    required this.createdAt,
  });

  // Factory para crear desde JSON (Base de datos remota/local)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      username: map['username'] ?? '',
      photoUrl: map['photoUrl'],
      // Convertir la lista dinámica a lista de Strings
      groupIds: List<String>.from(map['groupIds'] ?? []),
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  // Convertir a Map para guardar
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'username': username,
      'photoUrl': photoUrl,
      'groupIds': groupIds,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // CopyWith para inmutabilidad
  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? username,
    String? photoUrl,
    List<String>? groupIds,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      username: username ?? this.username,
      photoUrl: photoUrl ?? this.photoUrl,
      groupIds: groupIds ?? this.groupIds,
      createdAt: this.createdAt, // La fecha de creación no suele cambiar
    );
  }
}