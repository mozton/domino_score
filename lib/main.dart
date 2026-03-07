import 'package:dominos_score/config/service_locator.dart';
import 'package:dominos_score/data/local/database_helper.dart';
import 'package:dominos_score/data/local/local_setting_data_source.dart';
import 'package:dominos_score/data/services/in_app_purschase_services.dart';
import 'package:dominos_score/presentation/router/app_router.dart';
import 'package:dominos_score/presentation/router/route_names.dart';
import 'package:dominos_score/presentation/viewmodel/setting_viewmodel.dart';
import 'package:dominos_score/services/notifications_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalSettingDataSource.init();
  await dotenv.load(fileName: "assets/api_keys.env");

  // Obtener o crear un userId
  final prefs = await SharedPreferences.getInstance();
  String? userId = prefs.getString('userId');
  if (userId == null) {
    userId = 'default'; // o podrías generar un UUID
    await prefs.setString('userId', userId);
  }

  // Inicializar DatabaseHelper con el userId
  await DatabaseHelper().init(userId);
  await SubscriptionService.instance.initialize();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    MultiProvider(providers: ServiceLocator().providers, child: const MyApp()),
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
      themeMode: context.watch<SettingViewModel>().themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
    );
  }
}
