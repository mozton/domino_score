import 'package:dominos_score/presentation/router/route_names.dart';
import 'package:dominos_score/presentation/view/screen/auth/checking_screen.dart';
import 'package:dominos_score/presentation/view/screen/auth/login_screen.dart';
import 'package:dominos_score/presentation/view/screen/auth/register_screen.dart';
import 'package:dominos_score/presentation/view/screen/home/home_screen.dart';
import 'package:dominos_score/presentation/view/screen/setting/setting_screen.dart';

import 'package:flutter/material.dart';

class AppRouter {
  static Map<String, WidgetBuilder> get routes {
    return {
      RouteNames.home: (context) => HomeScreen(),
      RouteNames.setting: (context) => SettingScreen(),
      RouteNames.checking: (context) => CheckAuthScreen(),
      RouteNames.login: (context) => LoginScreen(),
      RouteNames.register: (context) => RegisterScreen(),
    };
  }
}
