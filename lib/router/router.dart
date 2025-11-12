import 'package:dominos_score/screen/screens.dart';

import 'package:flutter/material.dart';

class Routes {
  static Map<String, WidgetBuilder> routes() {
    return {
      '/': (context) => HomeScreen(),
      '/setting': (context) => SettingScreen(),
      '/homescreenv1': (context) => HomeScreenV1(),
    };
  }
}
