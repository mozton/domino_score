import 'package:dominos_score/presentation/router/route_names.dart';
import 'package:dominos_score/presentation/view/screen/auth/checking_screen.dart';
import 'package:dominos_score/presentation/view/screen/auth/login_screen.dart';
import 'package:dominos_score/presentation/view/screen/auth/register_screen.dart';
import 'package:dominos_score/presentation/view/screen/home/detail_game.dart';
import 'package:dominos_score/presentation/view/screen/home/history_screen.dart';
import 'package:dominos_score/presentation/view/screen/home/home_screen.dart';

import 'package:dominos_score/presentation/view/screen/auth/forgot_password_screen.dart';
import 'package:dominos_score/presentation/view/screen/info/privacy_polity_screen.dart';
import 'package:dominos_score/presentation/view/screen/setting/account_settings_screen.dart';
import 'package:dominos_score/presentation/view/screen/subscription/subscription_screen.dart';

import 'package:flutter/material.dart';

class AppRouter {
  static Map<String, WidgetBuilder> get routes {
    return {
      RouteNames.home: (context) => HomeScreen(),

      RouteNames.checking: (context) => CheckAuthScreen(),
      RouteNames.login: (context) => LoginScreen(),
      RouteNames.register: (context) => RegisterScreen(),
      RouteNames.historyDemo: (context) => HistoryDemoScreen(),
      RouteNames.forgotPassword: (context) => ForgotPasswordScreen(),
      RouteNames.subscription: (context) => SubscriptionScreen(),
      RouteNames.accountSettings: (context) => AccountSettingsScreen(),
      RouteNames.privacyPolicy: (context) => PrivacyPolicyScreen(),
      RouteNames.detailGame: (context) => DetailGameScreen(index: 2),
    };
  }
}
