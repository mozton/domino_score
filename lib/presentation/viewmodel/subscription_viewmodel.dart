import 'package:dominos_score/data/services/in_app_purschase_services.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class SubscriptionViewModel extends ChangeNotifier {
  final IAPService service;

  final String subscriptionId = "basic_suscription";

  // Estados clave
  bool isLoading = true;         // Cargando productos / verificando
  bool isPremium = false;        // Si el usuario ya pagó
  bool isAvailable = false;      // ¿La tienda está disponible?
  String? errorMessage;          // Mostrar errores al usuario

  // Productos obtenidos de la tienda
  List<ProductDetails> products = [];

  SubscriptionViewModel(this.service);

  Future<void> initialize() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    // Configurar callbacks del servicio
    service.onPurchaseSuccess = _handlePurchaseSuccess;
    service.onPurchaseError = _handleError;

    try {
      isAvailable = await service.initialize();
      if (isAvailable) {
        products = service.products;
        // Opcional: si quisieras revisar si tienen compras anteriores (restaurar automático en iOS)
        // await service.restorePurchases();
      }
    } catch (e) {
      errorMessage = "Error de inicialización: $e";
      isAvailable = false;
    }

    isLoading = false;
    notifyListeners();
  }

  void _handlePurchaseSuccess(PurchaseDetails purchase) {
    if (purchase.productID == subscriptionId) {
      isPremium = true;
      isLoading = false;
      errorMessage = null;
      notifyListeners();
    }
  }

  void _handleError(String errorMsg) {
    errorMessage = errorMsg;
    isLoading = false;
    notifyListeners();
  }

  Future<void> buySubscription() async {
    if (products.isEmpty) {
      errorMessage = "No hay productos disponibles por el momento.";
      notifyListeners();
      return;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    await service.buy(subscriptionId);
    
    // Si la llamada no lanzó error, la compra queda pendiente.
    // El loader podría quedar activo hasta que salte el callback o un error.
  }

  Future<void> restorePurchases() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    await service.restorePurchases();
    // Cuando restauran una compra que ya tenían, debería caer en _handlePurchaseSuccess

    // Un pequeño delay para apagar el loader en caso de que no tuvieran nada
    Future.delayed(const Duration(seconds: 3), () {
      if (isLoading) {
        isLoading = false;
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    service.dispose();
    super.dispose();
  }
}
