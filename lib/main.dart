import 'package:dominos_score/provider/game_provider.dart';
import 'package:dominos_score/router/router.dart';
import 'package:flutter/material.dart';
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      routes: Routes.routes(),
      initialRoute: '/',
      theme: context.read<GameProvider>().isDarkMode
          ? ThemeData.dark()
          : ThemeData.light(),
    );
  }
}
