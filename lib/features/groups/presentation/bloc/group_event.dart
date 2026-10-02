part of 'group_bloc.dart';

sealed class GroupEvent extends Equatable {
  const GroupEvent();

  @override
  List<Object?> get props => [];
}

class GroupsLoadRequested extends GroupEvent {
  const GroupsLoadRequested();
}

class GroupDetailRequested extends GroupEvent {
  final String groupId;

  const GroupDetailRequested(this.groupId);

  @override
  List<Object?> get props => [groupId];
}

class GroupCreateRequested extends GroupEvent {
  final String name;
  final String? description;

  const GroupCreateRequested({required this.name, this.description});

  @override
  List<Object?> get props => [name, description];
}

class GroupJoinRequested extends GroupEvent {
  final String joinCode;

  const GroupJoinRequested(this.joinCode);

  @override
  List<Object?> get props => [joinCode];
}

/// Carga el historial de partidas del grupo (Firestore).
class GroupGamesLoadRequested extends GroupEvent {
  final String groupId;

  const GroupGamesLoadRequested(this.groupId);

  @override
  List<Object?> get props => [groupId];
}

class GroupUpdateRequested extends GroupEvent {
  final String groupId;
  final String name;
  final String? description;

  const GroupUpdateRequested({
    required this.groupId,
    required this.name,
    this.description,
  });

  @override
  List<Object?> get props => [groupId, name, description];
}

class GroupDeleteRequested extends GroupEvent {
  final String groupId;

  const GroupDeleteRequested(this.groupId);

  @override
  List<Object?> get props => [groupId];
}

class GroupLeaveRequested extends GroupEvent {
  const GroupLeaveRequested();
}

class GroupLeaderSetRequested extends GroupEvent {
  final GroupMember leader;

  const GroupLeaderSetRequested(this.leader);

  @override
  List<Object?> get props => [leader];
}

class GroupMessagesCleared extends GroupEvent {
  const GroupMessagesCleared();
}

class GroupMemberRemoved extends GroupEvent {
  final String userId;

  const GroupMemberRemoved(this.userId);

  @override
  List<Object?> get props => [userId];
}

class GroupGuestAdded extends GroupEvent {
  final String displayName;
  final String? nickname;

  const GroupGuestAdded({required this.displayName, this.nickname});

  @override
  List<Object?> get props => [displayName, nickname];
}

class GroupMemberUpdated extends GroupEvent {
  final GroupMember member;

  const GroupMemberUpdated(this.member);

  @override
  List<Object?> get props => [member];
}
