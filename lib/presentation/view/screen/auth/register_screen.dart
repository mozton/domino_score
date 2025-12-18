import 'package:dominos_score/domain/repositories/auth_repository.dart';
import 'package:dominos_score/domain/utils/input_validator.dart';
import 'package:dominos_score/presentation/viewmodel/setting_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  bool loading = false;
  bool obscure1 = true;
  bool obscure2 = true;

  String? _emailError;
  String? _passError;

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<SettingViewModel>(context).themeMode;
    final isDarkMode =
        theme == ThemeMode.dark ||
        (theme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : const Color(0xFFEFF3F7),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                const SizedBox(height: 30),

                Text(
                  "Crear cuenta",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade800,
                  ),
                ),

                const SizedBox(height: 40),

                // Register card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: isDarkMode ? const Color(0xFF0F1822) : Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
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
                          onPressed: () => setState(() => obscure1 = !obscure1),
                        ),
                        errorText: _passError,
                        isDarkMode: isDarkMode,
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
                          onPressed: () => setState(() => obscure2 = !obscure2),
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
                            minimumSize: const Size(double.infinity, 56),
                          ),
                          onPressed: () async {
                            final auth = Provider.of<AuthRepository>(
                              context,
                              listen: false,
                            );

                            try {
                              if (passCtrl.text.trim() !=
                                  confirmCtrl.text.trim()) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Las contraseñas no coinciden',
                                    ),
                                  ),
                                );
                              }
                              await auth.signUp(
                                emailCtrl.text.trim(),
                                passCtrl.text.trim(),
                              );

                              if (context.mounted) {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Verificación de correo'),
                                    content: const Text(
                                      'Hemos enviado un correo de verificación para completar su registro.',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pushReplacementNamed(
                                              context,
                                              '/login',
                                            ),
                                        child: const Text('Aceptar'),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            } catch (e) {
                              final message = InputValidator.parseException(e);
                              setState(() {
                                if (message.toLowerCase().contains('correo') ||
                                    message.toLowerCase().contains('email')) {
                                  _emailError = message;
                                } else if (message.toLowerCase().contains(
                                      'contraseña',
                                    ) ||
                                    message.toLowerCase().contains(
                                      'password',
                                    )) {
                                  _passError = message;
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(message)),
                                  );
                                }
                              });
                            }
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

                const SizedBox(height: 25),

                // link back to login
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/login'),
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
    return TextField(
      controller: controller,
      obscureText: obscure,
      onChanged: (_) {
        if (errorText != null) {
          setState(() {
            // Clear error when user types
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
