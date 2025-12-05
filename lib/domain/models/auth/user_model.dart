class UserModel {
  final String id;
  final String name;
  final String email;
  final List<String> groupIds; // grupos donde pertenece
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.groupIds,
    required this.createdAt,
  });

  // ==== JSON ====
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    groupIds: List<String>.from(json['groupIds'] ?? []),
    createdAt: DateTime.parse(json['createdAt']),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "groupIds": groupIds,
    "createdAt": createdAt.toIso8601String(),
  };
}
