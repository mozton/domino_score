part of 'group_bloc.dart';

enum GroupStatus { initial, loading, ready, error }

class GroupState extends Equatable {
  final GroupStatus status;
  final List<Group> groups;
  final GroupDetail? detail;
  final List<Game> groupGames;
  final bool isLoadingGames;
  final bool isSubmitting;
  final String? myUserId;
  final String? errorMessage;
  final String? successMessage;

  const GroupState({
    this.status = GroupStatus.initial,
    this.groups = const [],
    this.detail,
    this.groupGames = const [],
    this.isLoadingGames = false,
    this.isSubmitting = false,
    this.myUserId,
    this.errorMessage,
    this.successMessage,
  });

  static const Object _unset = Object();

  GroupState copyWith({
    GroupStatus? status,
    List<Group>? groups,
    Object? detail = _unset,
    List<Game>? groupGames,
    bool? isLoadingGames,
    bool? isSubmitting,
    Object? myUserId = _unset,
    Object? errorMessage = _unset,
    Object? successMessage = _unset,
  }) {
    return GroupState(
      status: status ?? this.status,
      groups: groups ?? this.groups,
      detail: identical(detail, _unset)
          ? this.detail
          : detail as GroupDetail?,
      groupGames: groupGames ?? this.groupGames,
      isLoadingGames: isLoadingGames ?? this.isLoadingGames,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      myUserId: identical(myUserId, _unset)
          ? this.myUserId
          : myUserId as String?,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
      successMessage: identical(successMessage, _unset)
          ? this.successMessage
          : successMessage as String?,
    );
  }

  @override
  List<Object?> get props => [
    status,
    groups,
    detail,
    groupGames,
    isLoadingGames,
    isSubmitting,
    myUserId,
    errorMessage,
    successMessage,
  ];
}
