import 'package:dominos_score/presentation/router/route_names.dart';
import 'package:dominos_score/presentation/viewmodel/subscription_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
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
      canPop: false, // Bloquear volver atrás con gesto/botón de sistema
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyActions: false, // Oculta el botón default
          backgroundColor: isDarkMode ? Colors.black : const Color(0xFFEFF3F7),
        ),
        backgroundColor: isDarkMode ? Colors.black : const Color(0xFFEFF3F7),
        body: Consumer<SubscriptionViewModel>(
          builder: (context, viewModel, child) {
            
            // 1. Manejo de estado: Pantalla de carga
            if (viewModel.isLoading) {
              return Center(
                child: LoadingAnimationWidget.progressiveDots(
                  color: isDarkMode ? Colors.white : Colors.black,
                  size: 40,
                ),
              );
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

                    // Precio dinámico desde el repositorio
                    if (viewModel.products.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                          "${viewModel.products.first.price} / mes",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFD4A62F),
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),

                    if (viewModel.errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                          viewModel.errorMessage!,
                          style: const TextStyle(color: Colors.red, fontSize: 13, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),

                    const SizedBox(height: 32),
                    _buildFeatureItem(context, "Sin anuncios"),
                    _buildFeatureItem(context, "Historial ilimitado"),
                    _buildFeatureItem(context, "Olvídate de contar las fichas"),
                    const Spacer(),

                    // Botones de acción
                    if (!viewModel.isPremium) ...[
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: viewModel.isAvailable && viewModel.products.isNotEmpty 
                              ? () {
                                  context.read<SubscriptionViewModel>().buySubscription();
                                }
                              : null, // Deshabilitar si no hay conexión a la tienda o no cargó el producto
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD4A62F),
                            disabledBackgroundColor: Colors.grey[700],
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
                          context.read<SubscriptionViewModel>().restorePurchases();
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
                    ] else ...[
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.green, width: 2),
                        ),
                        child: const Column(
                          children: [
                            Icon(Icons.check_circle, color: Colors.green, size: 32),
                            SizedBox(height: 8),
                            Text(
                              "¡Ya eres Premium!",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, RouteNames.home);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 4,
                          ),
                          child: const Text(
                            "Ir al Inicio",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ),
                    ],

                    // Disclaimer legal requerido por Apple
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 8.0,
                      ),
                      child: Text(
                        "El pago se cargará a tu cuenta de Apple al confirmar la compra. La suscripción se renueva automáticamente a menos que se cancele al menos 24 horas antes del final del período actual. Puedes gestionar o cancelar tu suscripción desde los ajustes de tu cuenta en el App Store.",
                        style: TextStyle(
                          fontSize: 10,
                          color: isDarkMode ? Colors.grey[500] : Colors.grey[600],
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
