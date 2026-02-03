import 'package:dominos_score/domain/repositories/auth_repository.dart';
import 'package:dominos_score/domain/utils/input_validator.dart';
import 'package:dominos_score/presentation/view/widgets/features/auth/shake_widget.dart';
import 'package:dominos_score/services/notifications_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _shakeController = ShakeController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFEFF3F7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? Colors.white : Colors.black,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Recuperar Contraseña',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    color: isDark ? Colors.white : const Color(0xFF1E2B43),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Ingresa tu correo electrónico para recibir\ninstrucciones de recuperación.\nNota: Revisa spam si no recibes el correo.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    color: isDark ? Colors.white70 : Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 35),

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
                      children: [
                        ShakeWidget(
                          controller: _shakeController,
                          child: TextFormField(
                            controller: emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) =>
                                InputValidator.validateEmail(value),
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: isDark
                                  ? const Color(0xFF1A222D)
                                  : const Color(0xFFF5F7FA),
                              labelText: 'Correo electrónico',
                              labelStyle: TextStyle(
                                color: isDark ? Colors.white70 : Colors.black87,
                                fontFamily: 'Poppins',
                              ),
                              prefixIcon: Icon(
                                Icons.email_outlined,
                                color: Colors.grey.shade700,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
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
                                    if (!_formKey.currentState!.validate()) {
                                      _shakeController.shake();
                                      HapticFeedback.mediumImpact();
                                      return;
                                    }

                                    setState(() => loading = true);

                                    try {
                                      final authRepo =
                                          Provider.of<AuthRepository>(
                                            context,
                                            listen: false,
                                          );
                                      await authRepo.sendPasswordResetEmail(
                                        emailCtrl.text.trim(),
                                      );

                                      if (context.mounted) {
                                        NotificationsService.showSnackbar(
                                          'Correo de recuperación enviado exitosamente.',
                                        );
                                        Navigator.pop(context);
                                      }
                                    } catch (e) {
                                      final message =
                                          InputValidator.parseException(e);
                                      NotificationsService.showSnackbar(
                                        message,
                                      );
                                    } finally {
                                      if (mounted) {
                                        setState(() => loading = false);
                                      }
                                    }
                                  },
                            child: loading
                                ? LoadingAnimationWidget.progressiveDots(
                                    color: Colors.white,
                                    size: 40,
                                  )
                                : const Text(
                                    "Enviar correo",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                          ),
                        ),
                      ],
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
}
