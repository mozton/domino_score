import 'package:dominos_score/presentation/router/route_names.dart';
import 'package:dominos_score/presentation/viewmodel/subscription_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDarkMode
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      child: PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor: isDarkMode ? Colors.black : const Color(0xFFEFF3F7),
          body: Stack(
            children: [
              Consumer<SubscriptionViewModel>(
                builder: (context, viewModel, child) {
                  // Redirección si ya es Premium
                  if (viewModel.state == AppAccessState.premium) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        Navigator.pushReplacementNamed(
                          context,
                          RouteNames.home,
                        );
                      }
                    });
                  }

                  return SingleChildScrollView(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 852 / 800,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.star_rate_rounded,
                              size: 80,
                              color: Color(0xFFD4A62F),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                            Text(
                              "Desbloquea Corillo Premium",
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                                color: isDarkMode
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                            Text(
                              "Obtén acceso ilimitado a todas las funciones premium y disfruta de una experiencia libre de anuncios.",
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Poppins',
                                color: isDarkMode
                                    ? Colors.grey[400]
                                    : Colors.grey[700],
                              ),
                              textAlign: TextAlign.center,
                            ),

                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                            _buildFeatureItem(context, "Sin anuncios"),
                            _buildFeatureItem(context, "Historial ilimitado"),
                            _buildFeatureItem(
                              context,
                              "Olvídate de contar las fichas",
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.03,
                            ),

                            // Información explícita requerida por Apple
                            Builder(
                              builder: (context) {
                                final products = viewModel.service.products;
                                String priceText =
                                    "\$0.99 / mes"; // Valor por defecto en caso de que StoreKit no cargue a tiempo
                                String titleText =
                                    "Suscripción Premium Mensual";

                                if (products.isNotEmpty) {
                                  final product = products.first;
                                  priceText = "${product.price} / mes";
                                  // Limpiar el título por si viene como "Premium (Corillo)"
                                  titleText = product.title
                                      .replaceAll(RegExp(r'\(.*\)'), '')
                                      .trim();
                                  if (titleText.isEmpty)
                                    titleText = "Suscripción Premium Mensual";
                                }

                                return Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: const Color(
                                        0xFFD4A62F,
                                      ).withValues(alpha: 0.5),
                                      width: 1.5,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    color: isDarkMode
                                        ? Colors.white.withValues(alpha: 0.05)
                                        : Colors.black.withValues(alpha: 0.02),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        titleText,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: isDarkMode
                                              ? Colors.white
                                              : Colors.black87,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        priceText,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFD4A62F),
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        "Auto-renovable mensualmente. Cancela en cualquier momento.",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: isDarkMode
                                              ? Colors.white54
                                              : Colors.black54,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),

                            const SizedBox(height: 16),

                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: () async {
                                  try {
                                    await context
                                        .read<SubscriptionViewModel>()
                                        .buySubscription();
                                  } catch (e) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text("Error: Producto no disponible temporalmente. Verifica App Store Connect."),
                                        ),
                                      );
                                    }
                                  }
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
                                  color: isDarkMode
                                      ? Colors.white70
                                      : Colors.grey[800],
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
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
                              padding: const EdgeInsets.only(bottom: 0.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildLegalLink(
                                    context,
                                    "Políticas de Privacidad",
                                    "https://github.com/mozton/privacy-policy/blob/a794023ef93547f8e9e127b2c87488f763199ded/index.md",
                                  ),
                                  Text(
                                    "  •  ",
                                    style: TextStyle(
                                      color: isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  _buildLegalLink(
                                    context,
                                    "Términos de Uso (EULA)",
                                    "https://www.apple.com/legal/macapps/stdeula/",
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              Positioned(
                // Aumentamos un poco el margen para que no roce los iconos de batería/señal
                top: MediaQuery.of(context).padding.top + 12,
                right: 20, // Un poco más de margen lateral
                child: Consumer<SubscriptionViewModel>(
                  builder: (context, subVM, child) {
                    return IconButton(
                      // Usar IconButton es mejor para accesibilidad
                      padding: const EdgeInsets.all(8.0),
                      constraints:
                          const BoxConstraints(), // Quita el padding interno extra de Flutter
                      icon: Image.asset(
                        'assets/icon/square-rounded-x.png',
                        height: 28, // Un tamaño de 28-30 es perfecto
                        width: 28,
                        color: isDarkMode
                            ? Colors.white
                            : const Color(0xFF555555),
                      ),
                      onPressed: () {
                        // Tu lógica de negocio
                        if (!(subVM.state != AppAccessState.premium &&
                            subVM.hasConsumedFreeGame)) {
                          Navigator.pop(context);
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegalLink(BuildContext context, String text, String url) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: () => launchUrl(Uri.parse(url), mode: LaunchMode.inAppBrowserView),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
            decoration: TextDecoration.underline,
            fontFamily: 'Poppins',
            color: isDarkMode ? Colors.lightBlueAccent : Colors.blue,
            fontWeight: FontWeight.w500,
          ),
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
