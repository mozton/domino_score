import 'package:dominos_score/core/di/injection.dart';
import 'package:dominos_score/core/services/notifications_service.dart';
import 'package:dominos_score/features/auth/domain/usecase/check_auth_status_usecase.dart';
import 'package:dominos_score/features/auth/domain/usecase/delete_account_usecase.dart';
import 'package:dominos_score/features/auth/domain/usecase/privacy_policy_usecases.dart';
import 'package:dominos_score/features/auth/domain/usecase/send_password_reset_usecase.dart';
import 'package:dominos_score/features/auth/domain/usecase/sign_in_usecase.dart';
import 'package:dominos_score/features/auth/domain/usecase/sign_out_usecase.dart';
import 'package:dominos_score/features/auth/domain/usecase/sign_up_usecase.dart';
import 'package:dominos_score/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:dominos_score/core/network/current_user_provider.dart';
import 'package:dominos_score/features/games/domain/game_scope.dart';
import 'package:dominos_score/features/games/domain/usecases/add_round_usecase.dart';
import 'package:dominos_score/features/games/domain/usecases/delete_round_usecase.dart';
import 'package:dominos_score/features/games/domain/usecases/generate_live_code_usecase.dart';
import 'package:dominos_score/features/games/domain/usecases/get_group_games_usecase.dart';
import 'package:dominos_score/features/games/domain/usecases/init_game_usecase.dart';
import 'package:dominos_score/features/games/domain/usecases/load_games_usecase.dart';
import 'package:dominos_score/features/games/domain/usecases/publish_live_game_usecase.dart';
import 'package:dominos_score/features/games/domain/usecases/rename_team_usecase.dart';
import 'package:dominos_score/features/games/domain/usecases/save_live_code_usecase.dart';
import 'package:dominos_score/features/games/domain/usecases/set_my_team_usecase.dart';
import 'package:dominos_score/features/games/domain/usecases/start_new_game_usecase.dart';
import 'package:dominos_score/features/games/domain/usecases/start_new_game_with_teams_usecase.dart';
import 'package:dominos_score/features/games/domain/usecases/update_points_to_win_usecase.dart';
import 'package:dominos_score/features/games/domain/usecases/update_team_players_usecase.dart';
import 'package:dominos_score/features/games/presentation/bloc/game_bloc.dart';
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
import 'package:dominos_score/features/groups/presentation/bloc/group_bloc.dart';
import 'package:dominos_score/features/profiles/domain/usecases/compute_achievements_usecase.dart';
import 'package:dominos_score/features/profiles/domain/usecases/get_my_profile_usecase.dart';
import 'package:dominos_score/features/profiles/domain/usecases/get_my_recent_matches_usecase.dart';
import 'package:dominos_score/features/profiles/domain/usecases/get_my_stats_usecase.dart';
import 'package:dominos_score/features/profiles/domain/usecases/save_my_profile_usecase.dart';
import 'package:dominos_score/features/profiles/presentation/bloc/profile_bloc.dart';
import 'package:dominos_score/features/settings/domain/entities/theme_mode_option.dart';
import 'package:dominos_score/features/settings/domain/repositories/settings_repository.dart';
import 'package:dominos_score/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:dominos_score/presentation/router/app_router.dart';
import 'package:dominos_score/presentation/router/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  await dotenv.load(fileName: 'assets/api_keys.env');
  await initDependencies(prefs);

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SettingsBloc>(
          create: (_) =>
              SettingsBloc(getIt<SettingsRepository>())
                ..add(const SettingsLoadRequested()),
        ),
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(
            checkAuthStatus: getIt<CheckAuthStatusUseCase>(),
            signIn: getIt<SignInUseCase>(),
            signUp: getIt<SignUpUseCase>(),
            signOut: getIt<SignOutUseCase>(),
            sendPasswordReset: getIt<SendPasswordResetUseCase>(),
            deleteAccount: getIt<DeleteAccountUseCase>(),
            rejectPrivacyPolicy: getIt<RejectPrivacyPolicyUseCase>(),
          ),
        ),
        BlocProvider<GameBloc>(
          create: (_) => GameBloc(
            initGame: getIt<InitGameUseCase>(),
            loadGames: getIt<LoadGamesUseCase>(),
            startNewGame: getIt<StartNewGameUseCase>(),
            startNewGameWithTeams: getIt<StartNewGameWithTeamsUseCase>(),
            addRound: getIt<AddRoundUseCase>(),
            deleteRound: getIt<DeleteRoundUseCase>(),
            renameTeam: getIt<RenameTeamUseCase>(),
            updateTeamPlayers: getIt<UpdateTeamPlayersUseCase>(),
            setMyTeam: getIt<SetMyTeamUseCase>(),
            updatePointsToWin: getIt<UpdatePointsToWinUseCase>(),
            publishLiveGame: getIt<PublishLiveGameUseCase>(),
            saveLiveCode: getIt<SaveLiveCodeUseCase>(),
            generateLiveCode: getIt<GenerateLiveCodeUseCase>(),
            settingsRepository: getIt<SettingsRepository>(),
            scope: getIt<GameScope>(),
          ),
        ),
        BlocProvider<ProfileBloc>(
          create: (_) => ProfileBloc(
            getMyProfile: getIt<GetMyProfileUseCase>(),
            saveMyProfile: getIt<SaveMyProfileUseCase>(),
            getMyStats: getIt<GetMyStatsUseCase>(),
            computeAchievements: getIt<ComputeAchievementsUseCase>(),
            getMyRecentMatches: getIt<GetMyRecentMatchesUseCase>(),
          ),
        ),
        BlocProvider<GroupBloc>(
          create: (_) => GroupBloc(
            createGroup: getIt<CreateGroupUseCase>(),
            joinGroupByCode: getIt<JoinGroupByCodeUseCase>(),
            getMyGroups: getIt<GetMyGroupsUseCase>(),
            getGroupDetail: getIt<GetGroupDetailUseCase>(),
            updateGroup: getIt<UpdateGroupUseCase>(),
            deleteGroup: getIt<DeleteGroupUseCase>(),
            leaveGroup: getIt<LeaveGroupUseCase>(),
            setGroupLeader: getIt<SetGroupLeaderUseCase>(),
            syncMyMember: getIt<SyncMyMemberUseCase>(),
            removeMember: getIt<RemoveGroupMemberUseCase>(),
            addGuest: getIt<AddGroupGuestUseCase>(),
            updateMember: getIt<UpdateGroupMemberUseCase>(),
            getGroupGames: getIt<GetGroupGamesUseCase>(),
            currentUser: getIt<CurrentUserProvider>(),
          ),
        ),
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          final themeMode = switch (state.themeMode) {
            ThemeModeOption.system => ThemeMode.system,
            ThemeModeOption.light => ThemeMode.light,
            ThemeModeOption.dark => ThemeMode.dark,
          };

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            scaffoldMessengerKey: NotificationsService.messangerKey,
            routes: AppRouter.routes,
            initialRoute: RouteNames.checking,
            themeMode: themeMode,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
          );
        },
      ),
    );
  }
}
