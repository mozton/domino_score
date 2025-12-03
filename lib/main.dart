import 'package:dominos_score/repository/game_repository.dart';
import 'package:dominos_score/services/local/database_helper.dart';
import 'package:dominos_score/services/local/local_game_data_source.dart';
import 'package:dominos_score/services/remote/auth_service.dart';
import 'package:dominos_score/services/local/notifications_service.dart';
import 'package:dominos_score/services/local/shared_preferences.dart';
import 'package:dominos_score/viewmodel/camera_viewmodel.dart';
import 'package:dominos_score/viewmodel/game_viewmodel.dart';
import 'package:dominos_score/viewmodel/setting_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:dominos_score/router/router.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Prefs.init();
  await dotenv.load(fileName: "assets/api_keys.env");

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    MultiProvider(
      providers: [
        // --- 1. CAPA DE DATOS (Servicios/Data Sources) ---
        // Instancia única (Singleton) de tu DatabaseHelper.
        Provider<LocalGameDataSource>(create: (_) => DatabaseHelper()),

        // Placeholder para el Cloud/Auth Service si es Provider/Singleton
        ChangeNotifierProvider<AuthService>(create: (_) => AuthService()),

        // --- 2. CAPA DE REPOSITORIOS ---
        Provider<GameRepository>(
          create: (context) => GameRepository(
            // INYECCIÓN: Le pasamos la dependencia LocalGameDataSource
            localDataSource: context.read<LocalGameDataSource>(),
            cloudDataSource: null,
            // cloudDataSource: context.read<GameCloudDataSource>(), // Asumiendo que también existe
          ),
        ),

        // --- 3. CAPA DE VIEWMODELS ---
        ChangeNotifierProvider<SettingViewModel>(
          create: (_) => SettingViewModel(),
        ),

        ChangeNotifierProvider<CameraViewModel>(
          create: (_) => CameraViewModel(),
        ),

        // ViewModel de Juego (Debe ir después del Repositorio)
        ChangeNotifierProvider<GameViewmodel>(
          create: (context) => GameViewmodel(
            // INYECCIÓN: Le pasamos la dependencia GameRepository
            context.read<GameRepository>(),
          ),
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
      routes: Routes.routes(),
      initialRoute: '/checking',
      themeMode: ThemeMode.system,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
    );
  }
}
