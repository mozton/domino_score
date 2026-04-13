import 'package:dominos_score/presentation/router/route_names.dart';
import 'package:dominos_score/presentation/viewmodel/subscription_viewmodel.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SubscriptionViewModel>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          automaticallyImplyActions: false,
          actions: [
            InkWell(
              onTap: () {
                final subVM = context.read<SubscriptionViewModel>();

                if (subVM.state != AppAccessState.premium &&
                    subVM.hasConsumedFreeGame) {
                } else {
                  Navigator.pop(context);
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Image(
                  height: 25,
                  width: 25,
                  color: isDarkMode ? Colors.white : Color(0xFF555555),
                  image: AssetImage('assets/icon/square-rounded-x.png'),
                ),
              ),
            ),
          ],
          backgroundColor: isDarkMode ? Colors.black : const Color(0xFFEFF3F7),
        ),
        backgroundColor: isDarkMode ? Colors.black : const Color(0xFFEFF3F7),
        body: Consumer<SubscriptionViewModel>(
          builder: (context, viewModel, child) {
            // Redirección si ya es Premium
            if (viewModel.state == AppAccessState.premium) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  Navigator.pushReplacementNamed(context, RouteNames.home);
                }
              });
            }

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    const Icon(
                      Icons.star_rate_rounded,
                      size: 80,
                      color: Color(0xFFD4A62F),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Desbloquea Corillo Premium",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Obtén acceso ilimitado a todas las funciones premium y disfruta de una experiencia libre de anuncios.",
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Poppins',
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    _buildFeatureItem(context, "Sin anuncios"),
                    _buildFeatureItem(context, "Historial ilimitado"),
                    _buildFeatureItem(context, "Olvídate de contar las fichas"),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () async {
                          context
                              .read<SubscriptionViewModel>()
                              .buySubscription();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD4A62F),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                        ),
                        child: const Text(
                          "Suscribirse Ahora",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        context
                            .read<SubscriptionViewModel>()
                            .restorePurchases();
                      },
                      child: Text(
                        "Restaurar Compras",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: isDarkMode ? Colors.white70 : Colors.grey[800],
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 8.0,
                      ),
                      child: Text(
                        "El pago se cargará a tu cuenta de Apple al confirmar la compra. La suscripción se renueva automáticamente a menos que se cancele al menos 24 horas antes del final del período actual. Puedes gestionar o cancelar tu suscripción desde los ajustes de tu cuenta en el App Store.",
                        style: TextStyle(
                          fontSize: 10,
                          color: isDarkMode
                              ? Colors.grey[500]
                              : Colors.grey[600],
                          fontFamily: 'Poppins',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildLegalLink(
                            "Privacidad",
                            "https://github.com/mozton/privacy-policy/blob/a794023ef93547f8e9e127b2c87488f763199ded/index.md",
                          ),
                          const Text("  •  "),
                          _buildLegalLink(
                            "EULA",
                            "https://www.apple.com/legal/macapps/stdeula/",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLegalLink(String text, String url) {
    return InkWell(
      onTap: () => launchUrl(Uri.parse(url)),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          decoration: TextDecoration.underline,
          fontFamily: 'Poppins',
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildFeatureItem(BuildContext context, String text) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_rounded,
            color: Color(0xFFD4A62F),
            size: 24,
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Poppins',
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
