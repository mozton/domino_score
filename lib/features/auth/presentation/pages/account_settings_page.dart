import 'package:dominos_score/core/di/injection.dart';
import 'package:dominos_score/core/services/biometric_service.dart';
import 'package:dominos_score/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:dominos_score/features/auth/presentation/widgets/button_delete_account.dart';
import 'package:dominos_score/features/auth/presentation/widgets/message_delete_account.dart';
import 'package:dominos_score/features/auth/presentation/widgets/profile_header.dart';
import 'package:dominos_score/features/games/data/database/database_manager.dart';
import 'package:dominos_score/presentation/router/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  String? _deletingUserId;

  bool _biometricAvailable = false;
  bool _biometricEnabled = false;
  String? _savedEmail;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthBloc>().add(const AuthStatusChecked());
    });
    _loadBiometricState();
  }

  Future<void> _loadBiometricState() async {
    final service = getIt<BiometricService>();
    final available = await service.isAvailable();
    final enabled = available && await service.isEnabled();
    final email = enabled ? await service.savedEmail() : null;
    if (!mounted) return;
    setState(() {
      _biometricAvailable = available;
      _biometricEnabled = enabled;
      _savedEmail = email;
    });
  }

  Future<void> _disableBiometrics() async {
    await getIt<BiometricService>().disable();
    if (!mounted) return;
    setState(() {
      _biometricEnabled = false;
      _savedEmail = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Acceso con Face ID desactivado.')),
    );
  }

  Future<void> _deleteAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => const MessageDeleteAccount(),
    );

    if (!mounted) return;
    if (confirmed == true) {
      _deletingUserId = context.read<AuthBloc>().state.user?.id;
      context.read<AuthBloc>().add(const DeleteAccountRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state.status == AuthStatus.deleted) {
          if (_deletingUserId != null) {
            await getIt<DatabaseManager>().deleteDatabase(_deletingUserId!);
          }
          // La cuenta ya no existe: se borran también las credenciales de Face ID.
          await getIt<BiometricService>().disable();
          if (!context.mounted) return;
          Navigator.pushNamedAndRemoveUntil(
            context,
            RouteNames.checking,
            (route) => false,
          );
        } else if (state.status == AuthStatus.error) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Error al eliminar cuenta: ${state.errorMessage}',
                ),
              ),
            );
          }
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final user = state.user;
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
              appBar: _appBar(isDark, context),
              body: state.status == AuthStatus.loading
                  ? Center(
                      child: LoadingAnimationWidget.progressiveDots(
                        color: isDark ? Colors.white : Colors.black,
                        size: 40,
                      ),
                    )
                  : state.status == AuthStatus.error
                  ? _buildError(isDark, context)
                  : user == null
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
                            ProfileHeader(user: user),
                            const SizedBox(height: 24),
                            if (_biometricAvailable) _biometricCard(isDark),
                            const SizedBox(height: 16),
                            ButtonDeleteAccount(
                              title: 'Eliminar Cuenta',
                              color: Colors.red,
                              onPressed: _deleteAccount,
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }

  Widget _biometricCard(bool isDark) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F1822) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Image(
            image: AssetImage('assets/icon/user-scan.png'),
            width: 30,
            height: 30,
            color: Color(0xFFD4A62F),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Acceso con Face ID',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: isDark ? Colors.white : const Color(0xFF1E2B43),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _biometricEnabled
                      ? 'Activado${_savedEmail != null ? ' · $_savedEmail' : ''}'
                      : 'Se activa al iniciar sesión: te preguntamos si quieres '
                            'guardar tus credenciales.',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: isDark ? Colors.white60 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          if (_biometricEnabled)
            TextButton(
              onPressed: _disableBiometrics,
              child: const Text(
                'Desactivar',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  color: Colors.redAccent,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildError(bool isDark, BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.wifi_off_rounded,
              size: 64,
              color: isDark ? Colors.white54 : Colors.black45,
            ),
            const SizedBox(height: 16),
            Text(
              'Sin conexión a internet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Por favor, verifica tu conexión e intenta de nuevo.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Poppins',
                color: isDark ? Colors.white60 : Colors.black54,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.read<AuthBloc>().add(const AuthStatusChecked());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? Colors.white : Colors.black,
                foregroundColor: isDark ? Colors.black : Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Reintentar',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _appBar(bool isDark, BuildContext context) {
    return AppBar(
      systemOverlayStyle: isDark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
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
    );
  }
}
