import 'package:dominos_score/data/local/shared_preferences.dart';
import 'package:dominos_score/data/repositories/game_repository_impl.dart';
import 'package:dominos_score/data/local/database_helper.dart';
import 'package:dominos_score/domain/datasourse/local_game_data_source.dart';
import 'package:dominos_score/presentation/router/app_router.dart';
import 'package:dominos_score/presentation/router/route_names.dart';
import 'package:dominos_score/presentation/viewmodel/camera_viewmodel.dart';
import 'package:dominos_score/presentation/viewmodel/game_viewmodel.dart';
import 'package:dominos_score/presentation/viewmodel/setting_viewmodel.dart';
import 'package:dominos_score/services/notifications_service.dart';
import 'package:dominos_score/data/remote/remote_auth_data_source_impl.dart';
import 'package:dominos_score/data/repositories/auth_repository_impl.dart';
import 'package:dominos_score/domain/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Prefs.init();
  await dotenv.load(fileName: "assets/api_keys.env");

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    MultiProvider(
      providers: [
        Provider<LocalGameDataSource>(create: (_) => DatabaseHelper()),

        Provider<FlutterSecureStorage>(
          create: (_) => const FlutterSecureStorage(),
        ),
        Provider<RemoteAuthDataSourceImpl>(
          create: (context) =>
              RemoteAuthDataSourceImpl(context.read<FlutterSecureStorage>()),
        ),

        Provider<AuthRepository>(
          create: (context) => AuthRepositoryImpl(
            context.read<RemoteAuthDataSourceImpl>(),
            context.read<FlutterSecureStorage>(),
          ),
        ),

        Provider<GameRepositoryImpl>(
          create: (context) => GameRepositoryImpl(
            localDataSource: context.read<LocalGameDataSource>(),
          ),
        ),

        ChangeNotifierProvider<SettingViewModel>(
          create: (_) => SettingViewModel(),
        ),

        ChangeNotifierProvider<CameraViewModel>(
          create: (_) => CameraViewModel(),
        ),

        ChangeNotifierProvider<GameViewmodel>(
          create: (context) =>
              GameViewmodel(context.read<GameRepositoryImpl>()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      scaffoldMessengerKey: NotificationsService.messangerKey,
      routes: AppRouter.routes,
      initialRoute: RouteNames.checking,
      themeMode: ThemeMode.system,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
    );
  }
}
