import 'package:dominos_score/view/screen/auth/checking_screen.dart';
import 'package:dominos_score/view/screen/auth/login_screen.dart';
import 'package:dominos_score/view/screen/auth/register_screen.dart';
import 'package:dominos_score/view/screen/setting/setting_screen.dart';

import 'package:dominos_score/view/screens.dart';

import 'package:flutter/material.dart';

class Routes {
  static Map<String, WidgetBuilder> routes() {
    return {
      '/': (context) => HomeScreen(),
      '/setting': (context) => SettingScreen(),
      '/login': (context) => LoginScreen(),
      '/register': (context) => RegisterScreen(),
      '/checking': (_) => CheckAuthScreen(),
    };
  }
}
