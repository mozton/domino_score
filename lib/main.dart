import 'package:flutter/material.dart';
import 'package:dominos_score/router/router.dart';
import 'package:dominos_score/provider/providers.dart';
import 'package:provider/provider.dart';

void main() => runApp(
  MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => GameProvider())],
    child: const MyApp(),
  ),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<GameProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: Routes.routes(),
      initialRoute: '/homescreenv1',
      themeMode: prov.isSystemTheme
          ? ThemeMode.system
          : prov.isDarkMode
          ? ThemeMode.dark
          : ThemeMode.light,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
    );
  }
}
