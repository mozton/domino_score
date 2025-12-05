import 'package:dominos_score/data/remote/remote_auth_data_source_impl.dart';
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
                      // _inputField(
                      //   controller: nameCtrl,
                      //   label: "Nombre",
                      //   icon: Icons.person_outline,
                      // ),
                      // const SizedBox(height: 18),
                      _inputField(
                        controller: emailCtrl,
                        label: "Correo electrónico",
                        icon: Icons.email_outlined,
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
                      ),

                      const SizedBox(height: 30),
                      InkWell(
                        onTap: () async {
                          final auth = Provider.of<AuthService>(
                            context,
                            listen: false,
                          );

                          final String? errorMessage = await auth.createUser(
                            emailCtrl.text.trim(),
                            passCtrl.text.trim(),
                          );

                          if (errorMessage == null) {
                            Navigator.pushReplacementNamed(context, '/login');
                          }
                        },
                        child: Container(
                          height: 52,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD4A62F),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(child: Text('Registrarme')),
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
