import 'package:dominos_score/services/auth_services.dart';
import 'package:dominos_score/services/notifications_service.dart';
import 'package:dominos_score/services/shared_preferences.dart';
import 'package:dominos_score/viewmodel/camera_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:dominos_score/router/router.dart';
import 'package:dominos_score/viewmodel/providers.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Prefs.init();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => GameProvider()),
        ChangeNotifierProvider(create: (_) => CameraViewModel()),
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
