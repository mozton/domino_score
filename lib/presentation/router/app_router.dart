import 'package:dominos_score/features/auth/presentation/pages/account_settings_page.dart';
import 'package:dominos_score/features/auth/presentation/pages/checking_page.dart';
import 'package:dominos_score/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:dominos_score/features/auth/presentation/pages/login_page.dart';
import 'package:dominos_score/features/auth/presentation/pages/privacy_policy_page.dart';
import 'package:dominos_score/features/auth/presentation/pages/register_page.dart';
import 'package:dominos_score/features/games/presentation/pages/detail_game_page.dart';
import 'package:dominos_score/features/games/presentation/pages/history_page.dart';
import 'package:dominos_score/features/games/presentation/pages/home_page.dart';
import 'package:dominos_score/features/games/presentation/pages/live_game_page.dart';
import 'package:dominos_score/features/groups/presentation/screens/group_screen.dart';
import 'package:dominos_score/features/profiles/presentation/pages/player_profile_page.dart';
import 'package:dominos_score/presentation/router/route_names.dart';
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
      RouteNames.accountSettings: (context) => AccountSettingsScreen(),
      RouteNames.privacyPolicy: (context) => PrivacyPolicyScreen(),
      RouteNames.detailGame: (context) => DetailGameScreen(index: 2),
      RouteNames.groups: (context) => GroupScreen(),
      RouteNames.profile: (context) => const PlayerProfileScreen(),
      RouteNames.liveGame: (context) => const LiveGameScreen(),
    };
  }
}
