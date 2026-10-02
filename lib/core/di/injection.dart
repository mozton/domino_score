import 'package:dominos_score/core/network/auth_token_provider.dart';
import 'package:dominos_score/core/network/current_user_provider.dart';
import 'package:dominos_score/core/network/firestore_rest_client.dart';
import 'package:dominos_score/core/services/biometric_service.dart';
import 'package:dominos_score/core/services/camera_service.dart';
import 'package:dominos_score/core/services/dominos_counter_service.dart';
import 'package:dominos_score/core/services/url_launcher_service.dart';
import 'package:dominos_score/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:dominos_score/features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'package:dominos_score/features/auth/data/datasources/firebase_auth_token_provider.dart';
import 'package:dominos_score/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:dominos_score/features/auth/domain/repositories/auth_repository.dart';
import 'package:dominos_score/features/auth/domain/usecase/check_auth_status_usecase.dart';
import 'package:dominos_score/features/auth/domain/usecase/delete_account_usecase.dart';
import 'package:dominos_score/features/auth/domain/usecase/privacy_policy_usecases.dart';
import 'package:dominos_score/features/auth/domain/usecase/send_password_reset_usecase.dart';
import 'package:dominos_score/features/auth/domain/usecase/sign_in_usecase.dart';
import 'package:dominos_score/features/auth/domain/usecase/sign_out_usecase.dart';
import 'package:dominos_score/features/auth/domain/usecase/sign_up_usecase.dart';
import 'package:dominos_score/features/camera/presentation/bloc/camera_bloc.dart';
import 'package:dominos_score/features/games/data/database/database_manager.dart';
import 'package:dominos_score/features/games/data/datasources/drift_game_data_source.dart';
import 'package:dominos_score/features/games/data/datasources/firestore_group_game_data_source.dart';
import 'package:dominos_score/features/games/data/datasources/game_data_source.dart';
import 'package:dominos_score/features/games/data/datasources/last_live_code_store.dart';
import 'package:dominos_score/features/games/data/datasources/routed_game_data_source.dart';
import 'package:dominos_score/features/games/data/repositories/game_repository_impl.dart';
import 'package:dominos_score/features/games/data/repositories/live_game_repository_impl.dart';
import 'package:dominos_score/features/games/domain/game_scope.dart';
import 'package:dominos_score/features/games/domain/repositories/game_repository.dart';
import 'package:dominos_score/features/games/domain/repositories/live_game_repository.dart';
import 'package:dominos_score/features/games/domain/usecases/add_round_usecase.dart';
import 'package:dominos_score/features/games/domain/usecases/delete_round_usecase.dart';
import 'package:dominos_score/features/games/domain/usecases/generate_live_code_usecase.dart';
import 'package:dominos_score/features/games/domain/usecases/get_group_games_usecase.dart';
import 'package:dominos_score/features/games/domain/usecases/get_live_game_usecase.dart';
import 'package:dominos_score/features/games/domain/usecases/init_game_usecase.dart';
import 'package:dominos_score/features/games/domain/usecases/load_games_usecase.dart';
import 'package:dominos_score/features/games/domain/usecases/publish_live_game_usecase.dart';
import 'package:dominos_score/features/games/domain/usecases/rename_team_usecase.dart';
import 'package:dominos_score/features/games/domain/usecases/save_live_code_usecase.dart';
import 'package:dominos_score/features/games/domain/usecases/set_my_team_usecase.dart';
import 'package:dominos_score/features/games/domain/usecases/start_new_game_usecase.dart';
import 'package:dominos_score/features/games/domain/usecases/start_new_game_with_teams_usecase.dart';
import 'package:dominos_score/features/games/domain/usecases/update_points_to_win_usecase.dart';
import 'package:dominos_score/features/games/presentation/bloc/live_game_bloc.dart';
import 'package:dominos_score/features/groups/data/datasources/group_remote_data_source.dart';
import 'package:dominos_score/features/groups/data/datasources/group_remote_data_source_impl.dart';
import 'package:dominos_score/features/groups/data/repositories/group_repository_impl.dart';
import 'package:dominos_score/features/groups/domain/repositories/group_repository.dart';
import 'package:dominos_score/features/groups/domain/usecases/add_group_guest_usecase.dart';
import 'package:dominos_score/features/groups/domain/usecases/build_my_member_usecase.dart';
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
import 'package:dominos_score/features/profiles/data/datasources/profile_remote_data_source.dart';
import 'package:dominos_score/features/profiles/data/datasources/profile_remote_data_source_impl.dart';
import 'package:dominos_score/features/profiles/data/repositories/profile_repository_impl.dart';
import 'package:dominos_score/features/profiles/domain/repositories/profile_repository.dart';
import 'package:dominos_score/features/profiles/domain/usecases/compute_achievements_usecase.dart';
import 'package:dominos_score/features/profiles/domain/usecases/get_my_profile_usecase.dart';
import 'package:dominos_score/features/profiles/domain/usecases/get_my_recent_matches_usecase.dart';
import 'package:dominos_score/features/profiles/domain/usecases/get_my_stats_usecase.dart';
import 'package:dominos_score/features/profiles/domain/usecases/save_my_profile_usecase.dart';
import 'package:dominos_score/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:dominos_score/features/settings/data/datasources/settings_local_data_source_impl.dart';
import 'package:dominos_score/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:dominos_score/features/settings/domain/repositories/settings_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt getIt = GetIt.instance;

/// Registra todas las dependencias de la app (capa de datos + servicios).
Future<void> initDependencies(SharedPreferences prefs) async {
  // Infraestructura / servicios
  getIt.registerLazySingleton<SharedPreferences>(() => prefs);
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );
  getIt.registerLazySingleton<DatabaseManager>(() => DatabaseManager());
  getIt.registerLazySingleton<CameraService>(() => CameraService());
  getIt.registerLazySingleton<DominosCounter>(() => DominosCounter());
  getIt.registerLazySingleton<BiometricService>(() => BiometricService());
  getIt.registerLazySingleton<UrlLauncherService>(() => UrlLauncherService());

  // Games
  getIt.registerLazySingleton<GameScope>(() => GameScope());
  getIt.registerLazySingleton<DriftGameDataSource>(
    () => DriftGameDataSource(getIt<DatabaseManager>()),
  );
  getIt.registerLazySingleton<RoutedGameDataSource>(
    () => RoutedGameDataSource(
      local: getIt<DriftGameDataSource>(),
      scope: getIt<GameScope>(),
      groupFactory: (groupId) => FirestoreGroupGameDataSource(
        getIt<FirestoreRestClient>(),
        groupId,
      ),
    ),
  );
  getIt.registerLazySingleton<GameDataSource>(
    () => getIt<RoutedGameDataSource>(),
  );
  getIt.registerLazySingleton<GameRepository>(
    () => GameRepositoryImpl(
      activeDataSource: getIt<GameDataSource>(),
      localDataSource: getIt<DriftGameDataSource>(),
      groupDataSourceFactory: getIt<RoutedGameDataSource>().groupDataSource,
    ),
  );
  getIt.registerLazySingleton<GetGroupGamesUseCase>(
    () => GetGroupGamesUseCase(getIt<GameRepository>()),
  );
  getIt.registerLazySingleton<LoadGamesUseCase>(
    () => LoadGamesUseCase(getIt<GameRepository>()),
  );
  getIt.registerLazySingleton<InitGameUseCase>(
    () => InitGameUseCase(getIt<GameRepository>()),
  );
  getIt.registerLazySingleton<StartNewGameUseCase>(
    () => StartNewGameUseCase(getIt<GameRepository>()),
  );
  getIt.registerLazySingleton<StartNewGameWithTeamsUseCase>(
    () => StartNewGameWithTeamsUseCase(getIt<GameRepository>()),
  );
  getIt.registerLazySingleton<AddRoundUseCase>(
    () => AddRoundUseCase(getIt<GameRepository>()),
  );
  getIt.registerLazySingleton<DeleteRoundUseCase>(
    () => DeleteRoundUseCase(getIt<GameRepository>()),
  );
  getIt.registerLazySingleton<RenameTeamUseCase>(
    () => RenameTeamUseCase(getIt<GameRepository>()),
  );
  getIt.registerLazySingleton<SetMyTeamUseCase>(
    () => SetMyTeamUseCase(getIt<GameRepository>()),
  );
  getIt.registerLazySingleton<UpdatePointsToWinUseCase>(
    () => UpdatePointsToWinUseCase(getIt<GameRepository>()),
  );
  getIt.registerLazySingleton<SaveLiveCodeUseCase>(
    () => SaveLiveCodeUseCase(getIt<GameRepository>()),
  );

  // Partida en vivo (código para que los invitados la vean)
  getIt.registerLazySingleton<LiveGameRepository>(
    () => LiveGameRepositoryImpl(
      getIt<FirestoreRestClient>(),
      getIt<CurrentUserProvider>(),
    ),
  );
  getIt.registerLazySingleton<PublishLiveGameUseCase>(
    () => PublishLiveGameUseCase(getIt<LiveGameRepository>()),
  );
  getIt.registerLazySingleton<GetLiveGameUseCase>(
    () => GetLiveGameUseCase(getIt<LiveGameRepository>()),
  );
  getIt.registerLazySingleton<GenerateLiveCodeUseCase>(
    () => GenerateLiveCodeUseCase(getIt<LiveGameRepository>()),
  );
  getIt.registerLazySingleton<LastLiveCodeStore>(
    () => PreferencesLastLiveCodeStore(getIt<SharedPreferences>()),
  );

  // Settings
  getIt.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSourceImpl(getIt<SharedPreferences>()),
  );
  getIt.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(getIt<SettingsLocalDataSource>()),
  );

  // Auth
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt<FlutterSecureStorage>()),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      getIt<AuthRemoteDataSource>(),
      getIt<FlutterSecureStorage>(),
      getIt<SharedPreferences>(),
    ),
  );
  getIt.registerLazySingleton<CheckAuthStatusUseCase>(
    () => CheckAuthStatusUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<SignInUseCase>(
    () => SignInUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<SignUpUseCase>(
    () => SignUpUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<SignOutUseCase>(
    () => SignOutUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<SendPasswordResetUseCase>(
    () => SendPasswordResetUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<DeleteAccountUseCase>(
    () => DeleteAccountUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<AcceptPrivacyPolicyUseCase>(
    () => AcceptPrivacyPolicyUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<RejectPrivacyPolicyUseCase>(
    () => RejectPrivacyPolicyUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<IsPrivacyPolicyAcceptedUseCase>(
    () => IsPrivacyPolicyAcceptedUseCase(getIt<AuthRepository>()),
  );

  // Sesión + Firestore REST
  getIt.registerLazySingleton<AuthTokenProvider>(
    () => FirebaseAuthTokenProvider(
      getIt<FlutterSecureStorage>(),
      getIt<AuthRemoteDataSource>(),
    ),
  );
  getIt.registerLazySingleton<CurrentUserProvider>(
    () => TokenCurrentUserProvider(getIt<AuthTokenProvider>()),
  );
  getIt.registerLazySingleton<FirestoreRestClient>(
    () => FirestoreRestClient(tokenProvider: getIt<AuthTokenProvider>()),
  );

  // Profiles
  getIt.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(getIt<FirestoreRestClient>()),
  );
  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      getIt<ProfileRemoteDataSource>(),
      getIt<CurrentUserProvider>(),
    ),
  );
  getIt.registerLazySingleton<GetMyProfileUseCase>(
    () => GetMyProfileUseCase(
      getIt<ProfileRepository>(),
      getIt<CurrentUserProvider>(),
    ),
  );
  getIt.registerLazySingleton<SaveMyProfileUseCase>(
    () => SaveMyProfileUseCase(getIt<ProfileRepository>()),
  );
  getIt.registerLazySingleton<GetMyStatsUseCase>(
    () => GetMyStatsUseCase(getIt<GameRepository>()),
  );
  getIt.registerLazySingleton<ComputeAchievementsUseCase>(
    () => const ComputeAchievementsUseCase(),
  );
  getIt.registerLazySingleton<GetMyRecentMatchesUseCase>(
    () => GetMyRecentMatchesUseCase(getIt<GameRepository>()),
  );

  // Groups
  getIt.registerLazySingleton<GroupRemoteDataSource>(
    () => GroupRemoteDataSourceImpl(getIt<FirestoreRestClient>()),
  );
  getIt.registerLazySingleton<GroupRepository>(
    () => GroupRepositoryImpl(
      getIt<GroupRemoteDataSource>(),
      getIt<CurrentUserProvider>(),
    ),
  );
  getIt.registerLazySingleton<BuildMyMemberUseCase>(
    () => BuildMyMemberUseCase(
      getIt<ProfileRepository>(),
      getIt<GetMyStatsUseCase>(),
      getIt<CurrentUserProvider>(),
    ),
  );
  getIt.registerLazySingleton<CreateGroupUseCase>(
    () => CreateGroupUseCase(
      getIt<GroupRepository>(),
      getIt<BuildMyMemberUseCase>(),
    ),
  );
  getIt.registerLazySingleton<JoinGroupByCodeUseCase>(
    () => JoinGroupByCodeUseCase(
      getIt<GroupRepository>(),
      getIt<BuildMyMemberUseCase>(),
    ),
  );
  getIt.registerLazySingleton<GetMyGroupsUseCase>(
    () => GetMyGroupsUseCase(getIt<GroupRepository>()),
  );
  getIt.registerLazySingleton<GetGroupDetailUseCase>(
    () => GetGroupDetailUseCase(getIt<GroupRepository>()),
  );
  getIt.registerLazySingleton<UpdateGroupUseCase>(
    () => UpdateGroupUseCase(getIt<GroupRepository>()),
  );
  getIt.registerLazySingleton<DeleteGroupUseCase>(
    () => DeleteGroupUseCase(getIt<GroupRepository>()),
  );
  getIt.registerLazySingleton<LeaveGroupUseCase>(
    () => LeaveGroupUseCase(
      getIt<GroupRepository>(),
      getIt<CurrentUserProvider>(),
    ),
  );
  getIt.registerLazySingleton<SetGroupLeaderUseCase>(
    () => SetGroupLeaderUseCase(getIt<GroupRepository>()),
  );
  getIt.registerLazySingleton<RemoveGroupMemberUseCase>(
    () => RemoveGroupMemberUseCase(getIt<GroupRepository>()),
  );
  getIt.registerLazySingleton<AddGroupGuestUseCase>(
    () => AddGroupGuestUseCase(getIt<GroupRepository>()),
  );
  getIt.registerLazySingleton<UpdateGroupMemberUseCase>(
    () => UpdateGroupMemberUseCase(getIt<GroupRepository>()),
  );
  getIt.registerLazySingleton<SyncMyMemberUseCase>(
    () => SyncMyMemberUseCase(
      getIt<GroupRepository>(),
      getIt<BuildMyMemberUseCase>(),
      getIt<CurrentUserProvider>(),
    ),
  );

  // Camera (nueva instancia por cada hoja de cámara)
  getIt.registerFactory<CameraBloc>(
    () => CameraBloc(
      cameraService: getIt<CameraService>(),
      counter: getIt<DominosCounter>(),
    ),
  );

  // Partida en vivo (nueva instancia por cada pantalla)
  getIt.registerFactory<LiveGameBloc>(
    () => LiveGameBloc(
      getLiveGame: getIt<GetLiveGameUseCase>(),
      lastLiveCodeStore: getIt<LastLiveCodeStore>(),
    ),
  );
}
