import 'package:dominos_score/core/utils/input_validator.dart';
import 'package:dominos_score/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:dominos_score/features/auth/presentation/widgets/singup_message.dart';
import 'package:dominos_score/features/settings/domain/entities/theme_mode_option.dart';
import 'package:dominos_score/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:dominos_score/presentation/router/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool obscure1 = true;
  bool obscure2 = true;

  String? _emailError;
  String? _passError;

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<SettingsBloc>().state.themeMode;
    final isDarkMode =
        themeMode == ThemeModeOption.dark ||
        (themeMode == ThemeModeOption.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.signedUp) {
          showDialog(
            context: context,
            builder: (context) => SingupMessage(
              title: 'Verificación de correo',
              content:
                  'Te hemos enviado un correo de verificación. Revisa tu bandeja de entrada y, si no lo encuentras, verifica también la carpeta de spam o correo no deseado.',
              actionText: 'Aceptar',
              actionRoute: RouteNames.login,
              colorText: Colors.black,
            ),
          );
        } else if (state.status == AuthStatus.error) {
          final message = state.errorMessage ?? '';
          setState(() {
            if (message.toLowerCase().contains('correo') ||
                message.toLowerCase().contains('email')) {
              _emailError = message;
            } else if (message.toLowerCase().contains('contraseña') ||
                message.toLowerCase().contains('password')) {
              _passError = message;
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message)),
              );
            }
          });
        }
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: isDarkMode
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
        child: Scaffold(
          backgroundColor: isDarkMode ? Colors.black : const Color(0xFFEFF3F7),
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  children: [
                    Image(
                      image: const AssetImage('assets/logocorillosf.png'),
                      width: 180,
                      height: 180,
                    ),
                    Text(
                      "Crear cuenta",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? const Color(0xFF0F1822)
                            : Colors.white,
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
                          children: [
                            const SizedBox(height: 18),
                            _inputField(
                              controller: emailCtrl,
                              label: "Correo electrónico",
                              icon: Icons.email_outlined,
                              errorText: _emailError,
                              isDarkMode: isDarkMode,
                            ),
                            const SizedBox(height: 18),
                            _inputField(
                              controller: passCtrl,
                              label: "Contraseña",
                              icon: Icons.lock_outline,
                              obscure: obscure1,
                              suffix: IconButton(
                                icon: Icon(
                                  obscure1
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: Colors.grey.shade600,
                                ),
                                onPressed: () =>
                                    setState(() => obscure1 = !obscure1),
                              ),
                              errorText: _passError,
                              isDarkMode: isDarkMode,
                            ),
                            const SizedBox(height: 8),
                            ValueListenableBuilder<TextEditingValue>(
                              valueListenable: passCtrl,
                              builder: (context, value, child) {
                                final text = value.text;
                                final hasLength = text.length >= 8;
                                final hasUpper = RegExp(
                                  r'[A-Z]',
                                ).hasMatch(text);
                                final hasLower = RegExp(
                                  r'[a-z]',
                                ).hasMatch(text);
                                final hasDigit = RegExp(
                                  r'[0-9]',
                                ).hasMatch(text);
                                final hasSpecial = RegExp(
                                  r'[!@#\$%^&*(),.?":{}|<>]',
                                ).hasMatch(text);

                                Widget buildCheckItem(
                                  String label,
                                  bool isValid,
                                ) {
                                  return Row(
                                    children: [
                                      Icon(
                                        isValid
                                            ? Icons.check_circle
                                            : Icons.radio_button_unchecked,
                                        color: isValid
                                            ? Colors.green
                                            : Colors.grey,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        label,
                                        style: TextStyle(
                                          color: isValid
                                              ? Colors.green
                                              : Colors.grey,
                                          fontSize: 12,
                                          fontFamily: 'Poppins',
                                          decoration: isValid
                                              ? TextDecoration.lineThrough
                                              : null,
                                        ),
                                      ),
                                    ],
                                  );
                                }

                                return Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    buildCheckItem(
                                      'Mínimo 8 caracteres',
                                      hasLength,
                                    ),
                                    const SizedBox(height: 4),
                                    buildCheckItem(
                                      'Una letra mayúscula',
                                      hasUpper,
                                    ),
                                    const SizedBox(height: 4),
                                    buildCheckItem(
                                      'Una letra minúscula',
                                      hasLower,
                                    ),
                                    const SizedBox(height: 4),
                                    buildCheckItem('Un número', hasDigit),
                                    const SizedBox(height: 4),
                                    buildCheckItem(
                                      'Un carácter especial',
                                      hasSpecial,
                                    ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 18),
                            _inputField(
                              controller: confirmCtrl,
                              label: "Confirmar contraseña",
                              icon: Icons.lock_outline,
                              obscure: obscure2,
                              suffix: IconButton(
                                icon: Icon(
                                  obscure2
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: Colors.grey.shade600,
                                ),
                                onPressed: () =>
                                    setState(() => obscure2 = !obscure2),
                              ),
                              isDarkMode: isDarkMode,
                            ),
                            const SizedBox(height: 30),
                            SizedBox(
                              height: 49,
                              width: 180,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 3,
                                  backgroundColor: const Color(0xFFD4A62F),
                                  minimumSize: const Size(
                                    double.infinity,
                                    56,
                                  ),
                                ),
                                onPressed: () {
                                  if (!_formKey.currentState!.validate()) {
                                    return;
                                  }

                                  if (passCtrl.text.trim() !=
                                      confirmCtrl.text.trim()) {
                                    ScaffoldMessenger.of(
                                      context,
                                    ).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Las contraseñas no coinciden',
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  if (emailCtrl.text.trim().isEmpty ||
                                      passCtrl.text.trim().isEmpty ||
                                      confirmCtrl.text.trim().isEmpty) {
                                    ScaffoldMessenger.of(
                                      context,
                                    ).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Todos los campos son obligatorios',
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  context.read<AuthBloc>().add(
                                    SignUpRequested(
                                      email: emailCtrl.text.trim(),
                                      password: confirmCtrl.text.trim(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Registrarme',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    TextButton(
                      onPressed: () => Navigator.pushNamedAndRemoveUntil(
                        context,
                        RouteNames.login,
                        (route) => false,
                      ),
                      child: Text(
                        "Ya tengo una cuenta",
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
    Widget? suffix,
    String? errorText,
    required bool isDarkMode,
  }) {
    return TextFormField(
      validator: (value) {
        if (label == 'Correo electrónico') {
          return InputValidator.validateEmail(value);
        }
        if (label == 'Contraseña') {
          return InputValidator.validatePassword(value);
        }
        if (label == 'Confirmar contraseña') {
          if (value == null || value.trim().isEmpty) {
            return 'La confirmación de la contraseña es obligatoria';
          }
          if (value != passCtrl.text) {
            return 'Las contraseñas no coinciden';
          }
        }
        return null;
      },
      controller: controller,
      obscureText: obscure,
      onChanged: (_) {
        if (errorText != null) {
          setState(() {
            if (controller == emailCtrl) _emailError = null;
            if (controller == passCtrl) _passError = null;
          });
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
        errorText: errorText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
