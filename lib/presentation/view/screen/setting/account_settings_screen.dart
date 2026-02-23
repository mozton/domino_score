import 'package:dominos_score/data/local/database_helper.dart';
import 'package:dominos_score/domain/repositories/auth_repository.dart';
import 'package:dominos_score/presentation/router/route_names.dart';
import 'package:dominos_score/presentation/view/widgets/features/auth/message_delete_account.dart';
import 'package:dominos_score/presentation/view/widgets/features/setting/button_delete_account.dart';
import 'package:dominos_score/presentation/view/widgets/features/setting/profile_header.dart';
import 'package:dominos_score/presentation/viewmodel/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authRepo = context.read<AuthRepository>();
      context.read<AuthViewmodel>().loadUser(authRepo);
    });
  }

  Future<void> _deleteAccount(BuildContext context) async {
    final authRepo = context.read<AuthRepository>();
    final authVM = context.read<AuthViewmodel>();
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final database = DatabaseHelper();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => const MessageDeleteAccount(),
    );

    if (confirmed == true && mounted) {
      try {
        await authVM.deleteAccount(authRepo);
        await database.deleteDB();

        navigator.pop();

        if (mounted) {
          navigator.pushNamedAndRemoveUntil(
            RouteNames.checking,
            (route) => false,
          );
        }
      } catch (e) {
        if (mounted) {
          messenger.showSnackBar(
            SnackBar(content: Text('Error al eliminar cuenta: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer<AuthViewmodel>(
      builder: (context, authVM, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDark
                  ? [const Color(0x00000000), const Color(0x00000000)]
                  : [const Color(0xFFE4E9F2), const Color(0xFFFAFAFA)],
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: isDark ? Colors.white : Colors.black,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                'Mi Cuenta',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ),
            body: authVM.isLoading
                ? Center(
                    child: LoadingAnimationWidget.progressiveDots(
                      color: isDark ? Colors.white : Colors.black,
                      size: 40,
                    ),
                  )
                : authVM.user == null
                ? Center(
                    child: LoadingAnimationWidget.progressiveDots(
                      color: isDark ? Colors.white : Colors.black,
                      size: 40,
                    ),
                  )
                : SingleChildScrollView(
                    child: SizedBox(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ProfileHeader(user: authVM.user!),
                          const SizedBox(height: 40),
                          ButtonDeleteAccount(
                            onPressed: () => _deleteAccount(context),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}
