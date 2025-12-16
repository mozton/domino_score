import 'package:dominos_score/data/local/database_helper.dart';
import 'package:dominos_score/domain/models/auth/user_model.dart';
import 'package:dominos_score/domain/repositories/auth_repository.dart';
import 'package:dominos_score/presentation/view/screen/auth/login_screen.dart';
import 'package:dominos_score/presentation/view/screen/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckAuthScreen extends StatelessWidget {
  const CheckAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: context.read<AuthRepository>().checkAuthStatus(),

          builder: (BuildContext context, AsyncSnapshot<UserModel?> snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: Text('Cargando...'));
            }

            if (snapshot.data == null) {
              Future.microtask(() {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => LoginScreen(),
                    transitionDuration: Duration(seconds: 0),
                  ),
                );
              });
            } else {
              Future.microtask(() async {
                await DatabaseHelper().init(snapshot.data!.id);
                if (context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => HomeScreen(),
                      transitionDuration: Duration(seconds: 0),
                    ),
                  );
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
