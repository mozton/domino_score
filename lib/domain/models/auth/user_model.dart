import 'package:dominos_score/domain/models/models.dart';

class UserModel {
  final String id;
  final String email;
  final String name;
  final String username;
  final String? photoUrl;
  final SubscriptionModel? subscription;

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
    this.subscription,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      username: map['username'] ?? '',
      photoUrl: map['photoUrl'],
      groupIds: List<String>.from(map['groupIds'] ?? []),
      createdAt: DateTime.parse(map['createdAt']),
      subscription: map['subscription'] != null
          ? SubscriptionModel.fromMap(map['subscription'])
          : null,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'username': username,
      'photoUrl': photoUrl,
      'groupIds': groupIds,
      'createdAt': createdAt.toIso8601String(),
      'subscription': subscription?.toMap(),
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? username,
    String? photoUrl,
    List<String>? groupIds,
    SubscriptionModel? subscription,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      username: username ?? this.username,
      photoUrl: photoUrl ?? this.photoUrl,
      groupIds: groupIds ?? this.groupIds,
      createdAt: createdAt,
      subscription: subscription ?? this.subscription,
    );
  }
}
