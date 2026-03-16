import 'package:dominos_score/domain/repositories/auth_repository.dart';
import 'package:dominos_score/presentation/router/route_names.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  bool _isAccepted = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    final authRepo = context.read<AuthRepository>();
    final accepted = await authRepo.isPrivacyPolicyAccepted();

    if (!mounted) return;

    if (accepted) {
      Navigator.pushReplacementNamed(context, RouteNames.home);
      return;
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFFD4AF37)),
        ),
      );
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

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
          automaticallyImplyLeading: false,
          automaticallyImplyActions: false,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Información Legal',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                children: [
                  _buildLegalItem(
                    context: context,
                    title: 'Política de Privacidad',
                    subtitle: 'Cómo protegemos tus datos',
                    iconAsset: 'assets/icon/lock-check.png',
                    onTap: () {
                      final url =
                          'https://github.com/mozton/privacy-policy/blob/a794023ef93547f8e9e127b2c87488f763199ded/index.md';
                      launchUrl(Uri.parse(url));
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildLegalItem(
                    context: context,
                    title: 'Términos de Uso (EULA)',
                    subtitle: 'Condiciones de uso de la aplicación',
                    iconAsset: 'assets/icon/info-circle.png',
                    onTap: () {
                      final url =
                          'https://www.apple.com/legal/macapps/stdeula/';
                      launchUrl(Uri.parse(url));
                    },
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      'Al utilizar Corillo, confirmas que has leído y aceptado estos documentos.',
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: 'Poppins',
                        color: isDark ? Colors.white54 : Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            // Footer con Checkbox y Botón
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _isAccepted = !_isAccepted;
                        });
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Checkbox(
                              value: _isAccepted,
                              onChanged: (value) {
                                setState(() {
                                  _isAccepted = value ?? false;
                                });
                              },
                              activeColor: const Color(0xFFD4AF37),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const Flexible(
                              child: Text(
                                'Acepto los términos y condiciones',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isAccepted
                            ? () async {
                                final authRepo = context.read<AuthRepository>();
                                await authRepo.acceptPrivacyPolicy();

                                if (context.mounted) {
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    RouteNames.home,
                                    (route) => false,
                                  );
                                }
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD4AF37),
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: isDark
                              ? Colors.white10
                              : Colors.black12,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: _isAccepted ? 4 : 0,
                        ),
                        child: const Text(
                          'Continuar',
                          style: TextStyle(
                            fontSize: 18,
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
    );
  }

  Widget _buildLegalItem({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String iconAsset,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2B3C) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: (isDark
                ? Colors.white10
                : Colors.blueGrey.withValues(alpha: 0.05)),
            shape: BoxShape.circle,
          ),
          child: Image.asset(
            iconAsset,
            width: 24,
            height: 24,
            color: const Color(
              0xFFD4AF37,
            ), // Color dorado característico de la app
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 13,
            fontFamily: 'Poppins',
            color: isDark ? Colors.white60 : Colors.black54,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: isDark ? Colors.white30 : Colors.black26,
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
