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

class CheckAuthScreen extends StatelessWidget {
  const CheckAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepository = context.read<AuthRepository>();
    final subscriptionViewModel = context.read<SubscriptionViewModel>();

    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: Future.wait([
            authRepository.checkAuthStatus(),
            subscriptionViewModel.initializationComplete,
          ]),
          builder:
              (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return Center(
                    child: LoadingAnimationWidget.progressiveDots(
                      color: Colors.black,
                      size: 40,
                    ),
                  );
                }

                final UserModel? user = snapshot.data?[0] as UserModel?;

                if (user == null) {
                  Future.microtask(() {
                    if (context.mounted) {
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) => LoginScreen(),
                          transitionDuration: Duration(seconds: 0),
                        ),
                      );
                    }
                  });
                } else {
                  Future.microtask(() async {
                    await DatabaseHelper().init(user.id);

                    if (context.mounted) {
                      // If not premium, always show subscription screen
                      if (!subscriptionViewModel.isPremium) {
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (_, __, ___) => SubscriptionScreen(),
                            transitionDuration: Duration(seconds: 0),
                          ),
                        );
                      } else {
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (_, __, ___) => HomeScreen(),
                            transitionDuration: Duration(seconds: 0),
                          ),
                        );
                      }
                    }
                  });
                }
                return Container();
              },
        ),
      ),
    );
  }
}
