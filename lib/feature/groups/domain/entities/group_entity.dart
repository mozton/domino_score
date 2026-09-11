import 'package:equatable/equatable.dart';

class GroupEntity extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String joinCode;
  final String ownerId;
  final int membersCount;
  final int gamesCount;
  final String? currentLeaderId;
  final String? currentLeaderName;
  final DateTime createdAt;

  const GroupEntity({
    required this.id,
    required this.name,
    this.description,
    required this.joinCode,
    required this.ownerId,
    this.membersCount = 0,
    this.gamesCount = 0,
    this.currentLeaderId,
    this.currentLeaderName,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    joinCode,
    ownerId,
    membersCount,
    gamesCount,
    currentLeaderId,
    currentLeaderName,
    createdAt,
  ];
}
