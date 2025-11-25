import 'package:dominos_score/auth/screens/login_screen.dart';
import 'package:dominos_score/screen/screens.dart';
import 'package:dominos_score/screen/views/setting_screen.dart';

import 'package:flutter/material.dart';

class Routes {
  static Map<String, WidgetBuilder> routes() {
    return {
      '/': (context) => HomeScreen(),
      '/setting': (context) => SettingScreen(),
      '/login': (context) => LoginScreen(),
    };
  }
}
