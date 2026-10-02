import 'package:dominos_score/core/di/injection.dart';
import 'package:dominos_score/core/services/biometric_service.dart';
import 'package:dominos_score/core/services/notifications_service.dart';
import 'package:dominos_score/core/utils/input_validator.dart';
import 'package:dominos_score/features/auth/domain/entities/user_entity.dart';
import 'package:dominos_score/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:dominos_score/features/auth/presentation/widgets/shake_widget.dart';
import 'package:dominos_score/features/games/data/database/database_manager.dart';
import 'package:dominos_score/presentation/router/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _shakeController = ShakeController();
  final _biometricService = getIt<BiometricService>();

  bool obscure = true;
  String? _emailErrorText;
  String? _passwordErrorText;

  /// Evita procesar el mismo inicio de sesión dos veces: cada llamada abre la
  /// base de datos y navega (antes se repetía y cerraba la base en caliente).
  bool _handlingSignIn = false;
  bool _biometricAvailable = false;
  bool _biometricEnabled = false;
  bool _biometricBusy = false;
  String? _savedEmail;

  /// Indica que el inicio de sesión en curso se lanzó con Face ID.
  bool _biometricAttempt = false;

  @override
  void initState() {
    super.initState();
    _loadBiometricState();
  }

  Future<void> _loadBiometricState() async {
    final available = await _biometricService.isAvailable();
    final enabled = available && await _biometricService.isEnabled();
    final email = enabled ? await _biometricService.savedEmail() : null;
    if (!mounted) return;
    setState(() {
      _biometricAvailable = available;
      _biometricEnabled = enabled;
      _savedEmail = email;
    });
  }

  Future<void> _onSignedIn(User user) async {
    if (_handlingSignIn) return;
    _handlingSignIn = true;

    try {
      await getIt<DatabaseManager>().open(user.id);
      await _offerToSaveCredentials();
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteNames.checking,
        (route) => false,
      );
    } catch (e) {
      _handlingSignIn = false;
      if (!mounted) return;
      NotificationsService.showSnackbar(
        'No se pudo preparar tu sesión. Inténtalo de nuevo.',
      );
    }
  }

  /// Ofrece guardar las credenciales para poder entrar luego con Face ID.
  Future<void> _offerToSaveCredentials() async {
    final email = emailCtrl.text.trim();
    final password = passCtrl.text;

    if (email.isEmpty || password.isEmpty) return;
    if (!await _biometricService.isAvailable()) return;
    // Ya está activado para este mismo correo: no se vuelve a preguntar.
    if (await _biometricService.isEnabledFor(email)) return;
    if (!mounted) return;

    final acepta = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(
          'Acceso con Face ID',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700),
        ),
        content: const Text(
          '¿Quieres guardar tus credenciales para entrar la próxima vez con '
          'Face ID o huella?',
          style: TextStyle(fontFamily: 'Poppins'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Ahora no'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Activar'),
          ),
        ],
      ),
    );

    if (acepta == true) {
      final saved = await _biometricService.enableFor(
        email: email,
        password: password,
      );
      if (mounted) {
        setState(() {
          _biometricEnabled = saved;
          _savedEmail = saved ? email : null;
        });
      }
      if (saved) {
        NotificationsService.showSnackbar(
          'Listo. La próxima vez puedes entrar con Face ID.',
        );
      }
    } else {
      // Si había credenciales de otra cuenta, se descartan para no confundir.
      await _biometricService.disable();
      if (mounted) {
        setState(() {
          _biometricEnabled = false;
          _savedEmail = null;
        });
      }
    }
  }

  Future<void> _signInWithBiometrics() async {
    if (_biometricBusy) return;
    if (context.read<AuthBloc>().state.status == AuthStatus.loading) return;

    setState(() => _biometricBusy = true);
    try {
      final result = await _biometricService.signIn();
      if (!mounted) return;

      switch (result.status) {
        case BiometricStatus.success:
          emailCtrl.text = result.email!;
          passCtrl.text = result.password!;
          _biometricAttempt = true;
          context.read<AuthBloc>().add(
            SignInRequested(email: result.email!, password: result.password!),
          );
        case BiometricStatus.noCredentials:
          NotificationsService.showSnackbar(
            'Todavía no hay credenciales guardadas. Inicia sesión una vez y '
            'activa el Face ID.',
          );
        case BiometricStatus.unavailable:
          NotificationsService.showSnackbar(
            'Este dispositivo no tiene Face ID ni huella configurados.',
          );
        case BiometricStatus.canceled:
          // El usuario canceló el diálogo del sistema: no se avisa.
          break;
        case BiometricStatus.failed:
          NotificationsService.showSnackbar(
            'No se pudo verificar tu identidad. Inténtalo de nuevo.',
          );
      }
    } finally {
      if (mounted) setState(() => _biometricBusy = false);
    }
  }

  void _onError(String? message) {
    if (message == null) return;
    final lower = message.toLowerCase();

    // Si el Face ID falla porque la contraseña guardada ya no sirve, se
    // descartan las credenciales para no quedarse en un fallo repetido.
    final credentialsRejected =
        lower.contains('credenciales') || lower.contains('contraseña');
    if (_biometricAttempt && credentialsRejected) {
      _biometricAttempt = false;
      _forgetSavedCredentials();
      NotificationsService.showSnackbar(
        'Tus credenciales guardadas ya no son válidas. Inicia sesión de nuevo '
        'y vuelve a activar el Face ID.',
      );
      return;
    }

    if (credentialsRejected) {
      _passwordErrorText = message;
    } else if (lower.contains('correo')) {
      _emailErrorText = message;
    } else {
      NotificationsService.showSnackbar(message);
    }
    _formKey.currentState?.validate();
  }

  Future<void> _forgetSavedCredentials() async {
    await _biometricService.disable();
    if (!mounted) return;
    setState(() {
      _biometricEnabled = false;
      _savedEmail = null;
      _biometricAttempt = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isLoading =
        context.watch<AuthBloc>().state.status == AuthStatus.loading;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated && state.user != null) {
          _onSignedIn(state.user!);
        } else if (state.status == AuthStatus.error) {
          _onError(state.errorMessage);
        }
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        child: Scaffold(
          backgroundColor: isDark ? Colors.black : const Color(0xFFEFF3F7),
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                    Stack(
                      children: [
                        Image(
                          image: const AssetImage('assets/logocorillosf.png'),
                          width: 180,
                          height: 180,
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF0F1822) : Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ShakeWidget(
                              controller: _shakeController,
                              child: _inputField(
                                controller: emailCtrl,
                                label: 'Correo electrónico',
                                icon: Icons.email_outlined,
                                isEmail: true,
                                isDarkMode: isDark,
                                backendError: _emailErrorText,
                                suffix: _biometricAvailable
                                    ? IconButton(
                                        tooltip: _biometricEnabled
                                            ? 'Entrar con Face ID'
                                                  '${_savedEmail != null ? ' ($_savedEmail)' : ''}'
                                            : 'Activar Face ID',
                                        icon: const Icon(
                                          TablerIcons.user_scan,
                                          size: 35,
                                          color: Color(0xFFD4A62F),
                                        ),
                                        onPressed: isLoading || _biometricBusy
                                            ? null
                                            : _signInWithBiometrics,
                                      )
                                    : null,
                              ),
                            ),
                            const SizedBox(height: 18),
                            const SizedBox(height: 18),
                            _inputField(
                              controller: passCtrl,
                              label: "Contraseña",
                              icon: Icons.lock_outline,
                              obscure: obscure,
                              isDarkMode: isDark,
                              backendError: _passwordErrorText,
                              suffix: IconButton(
                                icon: Icon(
                                  obscure
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: Colors.grey.shade600,
                                ),
                                onPressed: () => setState(() {
                                  obscure = !obscure;
                                }),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    RouteNames.forgotPassword,
                                  );
                                },
                                child: Text(
                                  "¿Olvidaste tu contraseña?",
                                  style: TextStyle(
                                    color: isDark
                                        ? Colors.white70
                                        : const Color(0xFF1E2B43),
                                    fontSize: 13,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 49,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        elevation: 3,
                                        backgroundColor: const Color(
                                          0xFFD4A62F,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                        ),
                                      ),
                                      onPressed: isLoading
                                          ? null
                                          : () {
                                              if (!_formKey.currentState!
                                                  .validate()) {
                                                _shakeController.shake();
                                                HapticFeedback.mediumImpact();
                                                return;
                                              }
                                              context.read<AuthBloc>().add(
                                                SignInRequested(
                                                  email: emailCtrl.text.trim(),
                                                  password: passCtrl.text
                                                      .trim(),
                                                ),
                                              );
                                            },
                                      child: Center(
                                        child: isLoading
                                            ? LoadingAnimationWidget.progressiveDots(
                                                color: isDark
                                                    ? Colors.white
                                                    : Colors.black,
                                                size: 40,
                                              )
                                            : const Text(
                                                "Iniciar sesión",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: 'Poppins',
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                              ],
                            ),
                            // if (_biometricEnabled) ...[
                            //   const SizedBox(height: 12),
                            //   TextButton.icon(
                            //     onPressed: isLoading || _biometricBusy
                            //         ? null
                            //         : _signInWithBiometrics,
                            //     icon: const Image(
                            //       image: AssetImage(
                            //         'assets/icon/user-scan.png',
                            //       ),
                            //       width: 24,
                            //       height: 24,
                            //       color: Color(0xFFD4A62F),
                            //     ),
                            //     label: Text(
                            //       _biometricBusy
                            //           ? 'Verificando...'
                            //           : 'Entrar con Face ID',
                            //       style: TextStyle(
                            //         fontFamily: 'Poppins',
                            //         fontWeight: FontWeight.w600,
                            //         fontSize: 14,
                            //         color: isDark
                            //             ? Colors.white70
                            //             : const Color(0xFF1E2B43),
                            //       ),
                            //     ),
                            //   ),
                            //   if (_savedEmail != null)
                            //     Text(
                            //       _savedEmail!,
                            //       style: TextStyle(
                            //         fontFamily: 'Poppins',
                            //         fontSize: 11,
                            //         color: isDark
                            //             ? Colors.white38
                            //             : Colors.black45,
                            //       ),
                            //     ),
                            // ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          RouteNames.register,
                          (route) => false,
                        );
                      },
                      child: Text(
                        "Crear una cuenta",
                        style: TextStyle(
                          color: Colors.grey.shade800,
                          fontSize: 15,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
    bool isEmail = false,
    Widget? suffix,
    required bool isDarkMode,
    String? backendError,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      onChanged: (val) {
        if (backendError != null) {
          setState(() {
            if (isEmail) {
              _emailErrorText = null;
            } else {
              _passwordErrorText = null;
            }
          });
          _formKey.currentState!.validate();
        }
      },
      validator: (value) {
        if (backendError != null) {
          return backendError;
        }
        if (isEmail) {
          return InputValidator.validateEmail(value);
        } else {
          return InputValidator.validateLoginPassword(value);
        }
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: isDarkMode
            ? const Color(0xFF1A222D)
            : const Color(0xFFF5F7FA),
        labelText: label,
        labelStyle: TextStyle(
          color: isDarkMode ? Colors.white70 : Colors.black87,
          fontFamily: 'Poppins',
        ),
        prefixIcon: Icon(icon, color: Colors.grey.shade700),
        suffixIcon: suffix,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
