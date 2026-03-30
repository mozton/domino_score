import 'package:flutter/material.dart';
import 'package:dominos_score/data/services/in_app_purschase_services.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class SubscriptionViewModel extends ChangeNotifier {
  final IAPService service;

  final String subscriptionId = "basic_suscription";

  // Estados clave (from HEAD)
  bool isLoading = true;         // Cargando productos / verificando
  bool isPremium = false;        // Si el usuario ya pagó
  bool isAvailable = false;      // ¿La tienda está disponible?
  String? errorMessage;          // Mostrar errores al usuario

  // Productos obtenidos de la tienda
  List<ProductDetails> products = [];

  bool _initialized = false;
  bool _initialCheckCompleted = false;

  SubscriptionViewModel(this.service) {
    service.isSubscribed.addListener(_onSubscriptionStatusChanged);
  }

  void _onSubscriptionStatusChanged() {
    if (!_initialized) return;

    if (service.isSubscribed.value) {
      isPremium = true;
      isLoading = false;
      notifyListeners();
    } else {
      if (_initialCheckCompleted && isLoading) {
        isPremium = false;
        isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> initialize() async {
    if (_initialized && !isLoading) return;
    _initialized = true;

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    service.onPurchaseSuccess = _handlePurchaseSuccess;
    service.onPurchaseError = _handleError;

    try {
      isAvailable = await service.initialize();
      if (isAvailable) {
        products = service.products;
      }

      // Esperar hasta 3 segundos para que la verificación se complete (Apple Sandbox)
      int checks = 0;
      const maxChecks = 30; // 3 segundos
      while (checks < maxChecks && !_initialCheckCompleted) {
        await Future.delayed(const Duration(milliseconds: 100));
        checks++;
        if (service.isSubscribed.value) {
          _initialCheckCompleted = true;
          break;
        }
      }

      _initialCheckCompleted = true;

      if (!service.isSubscribed.value) {
        isPremium = false;
        isLoading = false;
        notifyListeners();
      } else {
        isPremium = true;
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      errorMessage = "Error de inicialización: $e";
      isAvailable = false;
      isLoading = false;
      notifyListeners();
    }
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
  }

  Future<void> restorePurchases() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    await service.restorePurchases();

    Future.delayed(const Duration(seconds: 3), () {
      if (isLoading) {
        isLoading = false;
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    service.isSubscribed.removeListener(_onSubscriptionStatusChanged);
    super.dispose();
  }
}
