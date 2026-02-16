import 'package:dominos_score/data/local/database_helper.dart';

import 'package:dominos_score/domain/repositories/auth_repository.dart';
import 'package:dominos_score/domain/utils/input_validator.dart';
import 'package:dominos_score/presentation/view/widgets/features/auth/shake_widget.dart';
// import 'package:dominos_score/presentation/viewmodel/setting_viewmodel.dart';
import 'package:flutter/services.dart';
// import 'package:dominos_score/data/services/subscription_service.dart';
import 'package:dominos_score/data/services/biometric_service.dart';
import 'package:dominos_score/services/notifications_service.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

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
  final _biometricService = BiometricService();

  bool loading = false;
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
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

                // Card container
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
                        // Email con ShakeWidget
                        ShakeWidget(
                          controller: _shakeController,
                          child: _inputField(
                            controller: emailCtrl,
                            label: 'Correo electrónico',
                            icon: Icons.email_outlined,
                            isEmail: true, // Flag para validar email
                            isDarkMode: isDark, // Pass theme state
                            suffix: IconButton(
                              icon: const Image(
                                image: AssetImage('assets/icon/user-scan.png'),
                                width: 35,
                                height: 35,
                                color: Color(0xFFD4A62F),
                              ),

                              onPressed: loading
                                  ? null
                                  : () async {
                                      setState(() => loading = true);
                                      final authenticated =
                                          await _biometricService
                                              .authenticateWithFace();
                                      if (authenticated) {
                                        final creds = await _biometricService
                                            .getCredentials();
                                        if (creds != null && context.mounted) {
                                          emailCtrl.text = creds['email']!;
                                          passCtrl.text = creds['password']!;
                                          // Trigger login programmatically
                                          setState(() => loading = true);
                                          try {
                                            final prov =
                                                Provider.of<AuthRepository>(
                                                  context,
                                                  listen: false,
                                                );
                                            final user = await prov.signIn(
                                              emailCtrl.text,
                                              passCtrl.text,
                                            );
                                            if (user != null) {
                                              await DatabaseHelper().init(
                                                user.id,
                                              );
                                            }
                                            if (context.mounted) {
                                              // final isSubscribed = await context
                                              //     .read<SubscriptionService>()
                                              //     .isSubscribed;
                                              // if (isSubscribed) {
                                              Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                '/',
                                                (route) => false,
                                              );
                                              // } else {
                                              //   Navigator.pushNamedAndRemoveUntil(
                                              //     context,
                                              //     '/subscription',
                                              //     (route) => false,
                                              //   );
                                              // }
                                            }
                                            setState(() => loading = false);
                                          } catch (e) {
                                            setState(() => loading = false);
                                            final message =
                                                InputValidator.parseException(
                                                  e,
                                                );
                                            NotificationsService.showSnackbar(
                                              message,
                                            );
                                          }
                                        } else {
                                          NotificationsService.showSnackbar(
                                            'No hay credenciales guardadas. Inicie sesión manualmente primero.',
                                          );
                                        }
                                        setState(() => loading = false);
                                      }
                                    },
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        const SizedBox(height: 18),

                        // Password
                        _inputField(
                          controller: passCtrl,
                          label: "Contraseña",
                          icon: Icons.lock_outline,
                          obscure: obscure,
                          isDarkMode: isDark, // Pass theme state
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
                              Navigator.pushNamed(context, '/forgotPassword');
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

                        // Login button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 49,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 3,
                                    backgroundColor: const Color(0xFFD4A62F),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  onPressed: loading
                                      ? null
                                      : () async {
                                          if (!_formKey.currentState!
                                              .validate()) {
                                            _shakeController.shake();
                                            HapticFeedback.mediumImpact();
                                            return;
                                          }

                                          final prov =
                                              Provider.of<AuthRepository>(
                                                context,
                                                listen: false,
                                              );
                                          try {
                                            final user = await prov.signIn(
                                              emailCtrl.text.trim(),
                                              passCtrl.text.trim(),
                                            );
                                            if (user != null) {
                                              await DatabaseHelper().init(
                                                user.id,
                                              );
                                              // Save credentials for next biometric login
                                              await _biometricService
                                                  .saveCredentials(
                                                    emailCtrl.text.trim(),
                                                    passCtrl.text.trim(),
                                                  );
                                            }

                                            if (context.mounted &&
                                                user != null) {
                                              // Simple check or navigation
                                              Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                '/',
                                                (route) => false,
                                              );
                                            }
                                          } catch (e) {
                                            final message =
                                                InputValidator.parseException(
                                                  e,
                                                );
                                            NotificationsService.showSnackbar(
                                              message,
                                            );
                                          }
                                        },

                                  child: Center(
                                    child: loading
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
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // Register link
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/register');
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
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: (value) {
        if (isEmail) {
          return InputValidator.validateEmail(value);
        } else {
          return InputValidator.validatePassword(value);
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
