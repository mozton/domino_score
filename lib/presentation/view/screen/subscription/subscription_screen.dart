import 'package:dominos_score/presentation/router/route_names.dart';
import 'package:dominos_score/presentation/viewmodel/subscription_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyActions: false,
        automaticallyImplyLeading: false,
        backgroundColor: isDarkMode ? Colors.black : const Color(0xFFEFF3F7),
      ),
      backgroundColor: isDarkMode ? Colors.black : const Color(0xFFEFF3F7),
      body: Consumer<SubscriptionViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  // Icon or Image
                  Icon(
                    Icons.star_rate_rounded,
                    size: 100,
                    color: const Color(0xFFD4A62F),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    "Desbloquea Premium",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  Text(
                    "Obtén acceso ilimitado a todas las funciones premium y ten acceso a una app sin anuncios. Con tan solo 0.99 \$USD/mes.",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),

                  if (viewModel.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        viewModel.errorMessage!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  const SizedBox(height: 48),

                  // Feature List (Example)
                  _buildFeatureItem(context, "Sin anuncios"),
                  _buildFeatureItem(context, "Historial ilimitado"),
                  _buildFeatureItem(context, "Olvidate de contar las fichas"),

                  const Spacer(),

                  if (!viewModel.isPremium) ...[
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          viewModel.subscribe();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD4A62F),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                        ),
                        child: Text(
                          viewModel.products.isNotEmpty
                              ? "Suscribirse ${viewModel.products.first.price}"
                              : "Suscribirse Ahora",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        viewModel.restorePurchases();
                      },
                      child: Text(
                        "Restaurar Compras",
                        style: TextStyle(
                          color: isDarkMode ? Colors.white70 : Colors.grey[700],
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ] else ...[
                    // Redirigir al home automáticamente si ya es premium
                    Builder(
                      builder: (context) {
                        Future.microtask(() {
                          if (context.mounted) {
                            Navigator.pushReplacementNamed(
                              context,
                              RouteNames.home,
                            );
                          }
                        });
                        return const Center(child: CircularProgressIndicator());
                      },
                    ),
                  ],
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeatureItem(BuildContext context, String text) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFFD4A62F), size: 20),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Poppins',
              color: isDarkMode ? Colors.white70 : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
