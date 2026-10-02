import 'package:equatable/equatable.dart';

/// Grupo ("Coro") de jugadores.
class Group extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String joinCode;
  final String ownerId;
  final List<String> memberIds;
  final int membersCount;
  final int gamesCount;
  final String? currentLeaderId;
  final String? currentLeaderName;
  final DateTime createdAt;

  const Group({
    required this.id,
    required this.name,
    this.description,
    required this.joinCode,
    required this.ownerId,
    this.memberIds = const [],
    this.membersCount = 0,
    this.gamesCount = 0,
    this.currentLeaderId,
    this.currentLeaderName,
    required this.createdAt,
  });

  bool isMember(String userId) => memberIds.contains(userId);
  bool isOwner(String userId) => ownerId == userId;

  Group copyWith({
    String? id,
    String? name,
    String? description,
    String? joinCode,
    String? ownerId,
    List<String>? memberIds,
    int? membersCount,
    int? gamesCount,
    String? currentLeaderId,
    String? currentLeaderName,
    DateTime? createdAt,
  }) {
    return Group(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      joinCode: joinCode ?? this.joinCode,
      ownerId: ownerId ?? this.ownerId,
      memberIds: memberIds ?? this.memberIds,
      membersCount: membersCount ?? this.membersCount,
      gamesCount: gamesCount ?? this.gamesCount,
      currentLeaderId: currentLeaderId ?? this.currentLeaderId,
      currentLeaderName: currentLeaderName ?? this.currentLeaderName,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    joinCode,
    ownerId,
    memberIds,
    membersCount,
    gamesCount,
    currentLeaderId,
    currentLeaderName,
    createdAt,
  ];
}
