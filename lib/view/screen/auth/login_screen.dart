import 'package:dominos_score/services/remote/auth_service.dart';
import 'package:dominos_score/services/local/notifications_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool loading = false;
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F7),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                const SizedBox(height: 30),

                // Title
                Text(
                  "Domino’s App",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                ),

                const SizedBox(height: 40),

                // Card container
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                      // Email
                      _inputField(
                        controller: emailCtrl,
                        label: "Correo electrónico",
                        icon: Icons.email_outlined,
                      ),
                      const SizedBox(height: 18),

                      // Password
                      _inputField(
                        controller: passCtrl,
                        label: "Contraseña",
                        icon: Icons.lock_outline,
                        obscure: obscure,
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

                      const SizedBox(height: 30),

                      // Login button
                      GestureDetector(
                        onTap: loading
                            ? null
                            : () async {
                                final prov = Provider.of<AuthService>(
                                  context,
                                  listen: false,
                                );
                                final String? errorMessage = await prov.login(
                                  emailCtrl.text.trim(),
                                  passCtrl.text.trim(),
                                );
                                // FocusScope.of(context).unfocus();

                                if (errorMessage == null) {
                                  Navigator.pushReplacementNamed(context, '/');
                                } else {
                                  NotificationsService.showSnackbar(
                                    errorMessage,
                                  );
                                }
                              },
                        child: Container(
                          height: 52,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD4A62F),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: loading
                                ? const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  )
                                : const Text(
                                    "Iniciar sesión",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
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
                    style: TextStyle(color: Colors.grey.shade800, fontSize: 15),
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
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF5F7FA),
        labelText: label,
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
