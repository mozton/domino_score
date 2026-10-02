import 'package:dominos_score/core/network/current_user_provider.dart';
import 'package:dominos_score/features/games/domain/entities/game_entity.dart';
import 'package:dominos_score/features/games/domain/usecases/get_group_games_usecase.dart';
import 'package:dominos_score/features/groups/domain/entities/group_detail_entity.dart';
import 'package:dominos_score/features/groups/domain/entities/group_entity.dart';
import 'package:dominos_score/features/groups/domain/entities/group_member_entity.dart';
import 'package:dominos_score/features/groups/domain/usecases/add_group_guest_usecase.dart';
import 'package:dominos_score/features/groups/domain/usecases/create_group_usecase.dart';
import 'package:dominos_score/features/groups/domain/usecases/delete_group_usecase.dart';
import 'package:dominos_score/features/groups/domain/usecases/get_group_detail_usecase.dart';
import 'package:dominos_score/features/groups/domain/usecases/get_my_groups_usecase.dart';
import 'package:dominos_score/features/groups/domain/usecases/join_group_by_code_usecase.dart';
import 'package:dominos_score/features/groups/domain/usecases/leave_group_usecase.dart';
import 'package:dominos_score/features/groups/domain/usecases/remove_group_member_usecase.dart';
import 'package:dominos_score/features/groups/domain/usecases/set_group_leader_usecase.dart';
import 'package:dominos_score/features/groups/domain/usecases/sync_my_member_usecase.dart';
import 'package:dominos_score/features/groups/domain/usecases/update_group_member_usecase.dart';
import 'package:dominos_score/features/groups/domain/usecases/update_group_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'group_event.dart';
part 'group_state.dart';

/// BLoC de grupos ("Coros").
class GroupBloc extends Bloc<GroupEvent, GroupState> {
  final CreateGroupUseCase _createGroup;
  final JoinGroupByCodeUseCase _joinGroupByCode;
  final GetMyGroupsUseCase _getMyGroups;
  final GetGroupDetailUseCase _getGroupDetail;
  final UpdateGroupUseCase _updateGroup;
  final DeleteGroupUseCase _deleteGroup;
  final LeaveGroupUseCase _leaveGroup;
  final SetGroupLeaderUseCase _setGroupLeader;
  final SyncMyMemberUseCase _syncMyMember;
  final RemoveGroupMemberUseCase _removeMember;
  final AddGroupGuestUseCase _addGuest;
  final UpdateGroupMemberUseCase _updateMember;
  final GetGroupGamesUseCase _getGroupGames;
  final CurrentUserProvider _currentUser;

  GroupBloc({
    required CreateGroupUseCase createGroup,
    required JoinGroupByCodeUseCase joinGroupByCode,
    required GetMyGroupsUseCase getMyGroups,
    required GetGroupDetailUseCase getGroupDetail,
    required UpdateGroupUseCase updateGroup,
    required DeleteGroupUseCase deleteGroup,
    required LeaveGroupUseCase leaveGroup,
    required SetGroupLeaderUseCase setGroupLeader,
    required SyncMyMemberUseCase syncMyMember,
    required RemoveGroupMemberUseCase removeMember,
    required AddGroupGuestUseCase addGuest,
    required UpdateGroupMemberUseCase updateMember,
    required GetGroupGamesUseCase getGroupGames,
    required CurrentUserProvider currentUser,
  }) : _createGroup = createGroup,
       _joinGroupByCode = joinGroupByCode,
       _getMyGroups = getMyGroups,
       _getGroupDetail = getGroupDetail,
       _updateGroup = updateGroup,
       _deleteGroup = deleteGroup,
       _leaveGroup = leaveGroup,
       _setGroupLeader = setGroupLeader,
       _syncMyMember = syncMyMember,
       _removeMember = removeMember,
       _addGuest = addGuest,
       _updateMember = updateMember,
       _getGroupGames = getGroupGames,
       _currentUser = currentUser,
       super(const GroupState()) {
    on<GroupsLoadRequested>(_onLoadGroups);
    on<GroupDetailRequested>(_onLoadDetail);
    on<GroupCreateRequested>(_onCreate);
    on<GroupJoinRequested>(_onJoin);
    on<GroupUpdateRequested>(_onUpdate);
    on<GroupDeleteRequested>(_onDelete);
    on<GroupLeaveRequested>(_onLeave);
    on<GroupLeaderSetRequested>(_onSetLeader);
    on<GroupMemberRemoved>(_onMemberRemoved);
    on<GroupGuestAdded>(_onGuestAdded);
    on<GroupMemberUpdated>(_onMemberUpdated);
    on<GroupGamesLoadRequested>(_onLoadGroupGames);
    on<GroupMessagesCleared>(_onClearMessages);
  }

  Future<void> _onLoadGroups(
    GroupsLoadRequested event,
    Emitter<GroupState> emit,
  ) async {
    emit(state.copyWith(status: GroupStatus.loading, errorMessage: null));
    try {
      final groups = await _getMyGroups();
      emit(
        state.copyWith(
          status: GroupStatus.ready,
          groups: groups,
          myUserId: await _resolveUserId(),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: GroupStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onLoadDetail(
    GroupDetailRequested event,
    Emitter<GroupState> emit,
  ) async {
    emit(
      state.copyWith(
        status: GroupStatus.loading,
        errorMessage: null,
        successMessage: null,
      ),
    );
    try {
      final detail = await _getGroupDetail(event.groupId);
      emit(
        state.copyWith(
          status: GroupStatus.ready,
          detail: detail,
          myUserId: await _resolveUserId(),
        ),
      );

      try {
        final synced = await _syncMyMember(detail);
        if (synced != null) {
          final members = detail.members
              .map((m) => m.userId == synced.userId ? synced : m)
              .toList();
          emit(
            state.copyWith(
              detail: GroupDetail(group: detail.group, members: members),
            ),
          );
        }
      } catch (_) {
        // La sincronización de stats es best-effort.
      }
    } catch (e) {
      emit(
        state.copyWith(status: GroupStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onCreate(
    GroupCreateRequested event,
    Emitter<GroupState> emit,
  ) async {
    emit(
      state.copyWith(
        isSubmitting: true,
        errorMessage: null,
        successMessage: null,
      ),
    );
    try {
      final group = await _createGroup(
        name: event.name,
        description: event.description,
      );
      final groups = await _getMyGroups();
      emit(
        state.copyWith(
          isSubmitting: false,
          status: GroupStatus.ready,
          groups: groups,
          successMessage: 'Grupo "${group.name}" creado.',
        ),
      );
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onJoin(
    GroupJoinRequested event,
    Emitter<GroupState> emit,
  ) async {
    emit(
      state.copyWith(
        isSubmitting: true,
        errorMessage: null,
        successMessage: null,
      ),
    );
    try {
      final group = await _joinGroupByCode(event.joinCode);
      final groups = await _getMyGroups();
      emit(
        state.copyWith(
          isSubmitting: false,
          status: GroupStatus.ready,
          groups: groups,
          successMessage: 'Te uniste a "${group.name}".',
        ),
      );
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onUpdate(
    GroupUpdateRequested event,
    Emitter<GroupState> emit,
  ) async {
    emit(
      state.copyWith(
        isSubmitting: true,
        errorMessage: null,
        successMessage: null,
      ),
    );
    try {
      final group = await _updateGroup(
        groupId: event.groupId,
        name: event.name,
        description: event.description,
      );
      final detail = state.detail;
      final groups = await _getMyGroups();
      emit(
        state.copyWith(
          isSubmitting: false,
          groups: groups,
          detail: detail == null
              ? null
              : GroupDetail(group: group, members: detail.members),
          successMessage: 'Grupo actualizado.',
        ),
      );
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onDelete(
    GroupDeleteRequested event,
    Emitter<GroupState> emit,
  ) async {
    emit(
      state.copyWith(
        isSubmitting: true,
        errorMessage: null,
        successMessage: null,
      ),
    );
    try {
      await _deleteGroup(event.groupId);
      final groups = await _getMyGroups();
      emit(
        state.copyWith(
          isSubmitting: false,
          status: GroupStatus.ready,
          groups: groups,
          detail: null,
          successMessage: 'Grupo eliminado.',
        ),
      );
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onLeave(
    GroupLeaveRequested event,
    Emitter<GroupState> emit,
  ) async {
    final detail = state.detail;
    if (detail == null) return;

    emit(
      state.copyWith(
        isSubmitting: true,
        errorMessage: null,
        successMessage: null,
      ),
    );
    try {
      await _leaveGroup(detail.group);
      final groups = await _getMyGroups();
      emit(
        state.copyWith(
          isSubmitting: false,
          status: GroupStatus.ready,
          groups: groups,
          detail: null,
          successMessage: 'Saliste del grupo.',
        ),
      );
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onSetLeader(
    GroupLeaderSetRequested event,
    Emitter<GroupState> emit,
  ) async {
    final detail = state.detail;
    if (detail == null) return;

    emit(
      state.copyWith(
        isSubmitting: true,
        errorMessage: null,
        successMessage: null,
      ),
    );
    try {
      final group = await _setGroupLeader(detail.group, event.leader);
      emit(
        state.copyWith(
          isSubmitting: false,
          detail: GroupDetail(group: group, members: detail.members),
          successMessage: '${event.leader.displayName} es el nuevo líder.',
        ),
      );
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, errorMessage: e.toString()));
    }
  }

  void _onClearMessages(GroupMessagesCleared event, Emitter<GroupState> emit) {
    emit(state.copyWith(errorMessage: null, successMessage: null));
  }

  Future<void> _onMemberRemoved(
    GroupMemberRemoved event,
    Emitter<GroupState> emit,
  ) async {
    final detail = state.detail;
    if (detail == null) return;

    emit(
      state.copyWith(
        isSubmitting: true,
        errorMessage: null,
        successMessage: null,
      ),
    );
    try {
      await _removeMember(detail.group, event.userId);
      final updated = await _getGroupDetail(detail.group.id);
      emit(
        state.copyWith(
          isSubmitting: false,
          detail: updated,
          successMessage: 'Miembro eliminado.',
        ),
      );
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onGuestAdded(
    GroupGuestAdded event,
    Emitter<GroupState> emit,
  ) async {
    final detail = state.detail;
    if (detail == null) return;

    emit(
      state.copyWith(
        isSubmitting: true,
        errorMessage: null,
        successMessage: null,
      ),
    );
    try {
      await _addGuest(
        detail.group,
        displayName: event.displayName,
        nickname: event.nickname,
      );
      final updated = await _getGroupDetail(detail.group.id);
      emit(
        state.copyWith(
          isSubmitting: false,
          detail: updated,
          successMessage: 'Jugador añadido.',
        ),
      );
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onMemberUpdated(
    GroupMemberUpdated event,
    Emitter<GroupState> emit,
  ) async {
    final detail = state.detail;
    if (detail == null) return;

    emit(
      state.copyWith(
        isSubmitting: true,
        errorMessage: null,
        successMessage: null,
      ),
    );
    try {
      await _updateMember(detail.group.id, event.member);
      final updated = await _getGroupDetail(detail.group.id);
      emit(
        state.copyWith(
          isSubmitting: false,
          detail: updated,
          successMessage: 'Jugador actualizado.',
        ),
      );
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onLoadGroupGames(
    GroupGamesLoadRequested event,
    Emitter<GroupState> emit,
  ) async {
    emit(state.copyWith(isLoadingGames: true, errorMessage: null));
    try {
      final games = await _getGroupGames(event.groupId);
      emit(state.copyWith(isLoadingGames: false, groupGames: games));
    } catch (e) {
      emit(
        state.copyWith(isLoadingGames: false, errorMessage: e.toString()),
      );
    }
  }

  Future<String?> _resolveUserId() async {
    try {
      return await _currentUser.currentUserId();
    } catch (_) {
      return null;
    }
  }
}
