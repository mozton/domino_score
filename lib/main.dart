import 'package:dominos_score/config/service_locator.dart';
import 'package:dominos_score/data/local/local_setting_data_source.dart';
import 'package:dominos_score/presentation/router/app_router.dart';
import 'package:dominos_score/presentation/router/route_names.dart';
import 'package:dominos_score/presentation/viewmodel/setting_viewmodel.dart';
import 'package:dominos_score/services/notifications_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalSettingDataSource.init();
  await dotenv.load(fileName: "assets/api_keys.env");

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
