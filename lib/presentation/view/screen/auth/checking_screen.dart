import 'package:dominos_score/data/local/database_helper.dart';
import 'package:dominos_score/domain/models/auth/user_model.dart';
import 'package:dominos_score/domain/repositories/auth_repository.dart';
import 'package:dominos_score/presentation/view/screen/auth/login_screen.dart';
import 'package:dominos_score/presentation/view/screen/home/home_screen.dart';
import 'package:dominos_score/presentation/view/screen/subscription/subscription_screen.dart';
import 'package:dominos_score/presentation/viewmodel/subscription_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CheckAuthScreen extends StatefulWidget {
  const CheckAuthScreen({super.key});

  @override
  State<CheckAuthScreen> createState() => _CheckAuthScreenState();
}

class _CheckAuthScreenState extends State<CheckAuthScreen> {
  Future<UserModel?>? _authFuture;
  Future<void>? _subInitializationFuture;
  UserModel? _lastAuthenticatedUser;

  @override
  void initState() {
    super.initState();
    _authFuture = context.read<AuthRepository>().checkAuthStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<UserModel?>(
          future: _authFuture,
          builder: (context, authSnapshot) {
            if (authSnapshot.connectionState != ConnectionState.done) {
              return _loadingIndicator();
            }

            final user = authSnapshot.data;

            if (user == null) {
              _navigateTo(Navigator.of(context), const LoginScreen());
              return Container();
            }

            // User is authenticated, now check subscription
            // Ensure we only initialize once for this user
            if (_lastAuthenticatedUser?.id != user.id) {
              _lastAuthenticatedUser = user;
              _subInitializationFuture = context
                  .read<SubscriptionViewModel>()
                  .initialize();
            }

            return FutureBuilder(
              future: _subInitializationFuture,
              builder: (context, subSnapshot) {
                if (subSnapshot.connectionState != ConnectionState.done) {
                  return _loadingIndicator();
                }

                return Consumer<SubscriptionViewModel>(
                  builder: (context, subscriptionViewModel, child) {
                    final navigator = Navigator.of(context);
                    Future.microtask(() async {
                      await DatabaseHelper().init(user.id);
                      if (!mounted) return;
                      if (subscriptionViewModel.isPremium) {
                        _navigateTo(navigator, HomeScreen());
                      } else {
                        _navigateTo(navigator, const SubscriptionScreen());
                      }
                    });
                    return _loadingIndicator();
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _loadingIndicator() {
    return Center(
      child: LoadingAnimationWidget.progressiveDots(
        color: Colors.black,
        size: 40,
      ),
    );
  }

  void _navigateTo(NavigatorState navigator, Widget screen) {
    Future.microtask(() {
      navigator.pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => screen,
          transitionDuration: Duration.zero,
        ),
      );
    });
  }
}
