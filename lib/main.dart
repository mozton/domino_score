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

import 'package:flutter/material.dart';

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

        // --- 2. CAPA DE REPOSITORIOS ---
        Provider<GameRepositoryImpl>(
          create: (context) => GameRepositoryImpl(
            // INYECCIÓN: Le pasamos la dependencia LocalGameDataSource
            localDataSource: context.read<LocalGameDataSource>(),

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
            context.read<GameRepositoryImpl>(),
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
      routes: AppRouter.routes,
      initialRoute: RouteNames.home,
      themeMode: ThemeMode.system,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
    );
  }
}
