import 'package:dominos_score/screen/home_screen.dart';
import 'package:dominos_score/screen/setting_screen.dart';

import 'package:flutter/material.dart';

class Routes {
  static Map<String, WidgetBuilder> routes() {
    return {
      '/': (context) => HomeScreen(),

      '/setting': (context) => SettingScreen(),
    };
  }
}
