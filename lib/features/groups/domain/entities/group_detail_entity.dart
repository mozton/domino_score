import 'package:dominos_score/features/groups/domain/entities/group_entity.dart';
import 'package:dominos_score/features/groups/domain/entities/group_member_entity.dart';
import 'package:equatable/equatable.dart';

/// Grupo junto con su lista de miembros.
class GroupDetail extends Equatable {
  final Group group;
  final List<GroupMember> members;

  const GroupDetail({required this.group, required this.members});

  @override
  List<Object?> get props => [group, members];
}
