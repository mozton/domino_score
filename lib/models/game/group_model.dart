class GroupModel {
  final String id;
  final String name;
  final String ownerId;
  final List<String> members; // user IDs
  final String? activeGameId; // game actual (puede ser null)

  final DateTime createdAt;

  GroupModel({
    required this.id,
    required this.name,
    required this.ownerId,
    required this.members,
    this.activeGameId,
    required this.createdAt,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) => GroupModel(
    id: json['id'],
    name: json['name'],
    ownerId: json['ownerId'],
    members: List<String>.from(json['members'] ?? []),
    activeGameId: json['activeGameId'],
    createdAt: DateTime.parse(json['createdAt']),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "ownerId": ownerId,
    "members": members,
    "activeGameId": activeGameId,
    "createdAt": createdAt.toIso8601String(),
  };
}
