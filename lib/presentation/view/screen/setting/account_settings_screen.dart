import 'package:dominos_score/domain/models/auth/user_model.dart';
import 'package:dominos_score/domain/repositories/auth_repository.dart';
import 'package:dominos_score/presentation/router/route_names.dart';
import 'package:dominos_score/presentation/view/widgets/features/auth/message_delete_account.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  UserModel? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final authRepo = context.read<AuthRepository>();
      final user = await authRepo.checkAuthStatus();
      if (mounted) {
        setState(() {
          _user = user;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _deleteAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => MessageDeleteAccount(),
    );

    if (confirmed == true && mounted) {
      setState(() => _isLoading = true);
      try {
        final authRepo = context.read<AuthRepository>();
        await authRepo.deleteUser();

        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            RouteNames.checking,
            (route) => false,
          );
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al eliminar cuenta: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    String ocultarCorreo(String email) {
      final parts = _user!.email.split('@');
      final email = parts[0];
      final domain = parts[1];
      final maskedEmail = email.length > 3
          ? '${email.substring(0, 3)}****'
          : email;
      return '$maskedEmail@$domain';
    }

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
        body: _isLoading
            ? Center(
                child: LoadingAnimationWidget.progressiveDots(
                  color: isDark ? Colors.white : Colors.black,
                  size: 40,
                ),
              )
            : _user == null
            ? Center(
                child: Text(
                  'No se pudo cargar la información del usuario.',
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                ),
              )
            : SingleChildScrollView(
                child: SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.8,

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),
                      // Avatar
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: isDark
                            ? Colors.grey[800]
                            : Colors.grey[300],
                        backgroundImage: _user!.photoUrl != null
                            ? NetworkImage(_user!.photoUrl!)
                            : null,
                        child: _user!.photoUrl == null
                            ? Icon(
                                Icons.person,
                                size: 50,
                                color: isDark ? Colors.white : Colors.grey[600],
                              )
                            : null,
                      ),
                      const SizedBox(height: 20),
                      // Name
                      Text(
                        _user!.name,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 5),
                      // Email
                      Text(
                        ocultarCorreo(_user!.email),
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Delete Account Button (styled like a destructive action)
                      _buttonDeleteAccount(),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  _buttonDeleteAccount() {
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = Colors.red;

    return Container(
      height: size.height * (44 / 852),
      width: size.width * (200 / 393),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [const Color(0x00000000), const Color(0x00000000)]
              : [const Color(0xFFE4E9F2), const Color(0xFFFAFAFA)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(width: 1.0, color: color),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: _deleteAccount,
        child: Center(
          child: Text(
            'Eliminar Cuenta',
            style: TextStyle(
              fontSize: size.height * (14 / 852),
              fontWeight: FontWeight.w700,
              fontFamily: 'Poppins',
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}
