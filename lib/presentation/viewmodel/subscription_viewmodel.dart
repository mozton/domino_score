// import 'package:flutter/material.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:dominos_score/data/services/in_app_purschase_services.dart';

// enum AppAccessState { loading, paywall, premium }

// class SubscriptionViewModel extends ChangeNotifier {
//   final IAPService service;

//   AppAccessState state = AppAccessState.loading;

//   final String subscriptionId = "basic_suscription";

//   bool _initialized = false;

//   SubscriptionViewModel(this.service);

//   Future<void> initialize() async {
//     if (_initialized && state != AppAccessState.loading) return;
//     _initialized = true;

//     try {
//       state = AppAccessState.loading;
//       notifyListeners();

//       service.onPurchaseSuccess = _handlePurchaseSuccess;
//       await service.initialize();

//       // Trigger restore purchases
//       await service.restorePurchases();

//       // Wait up to 3 seconds for restored purchases to arrive via the stream
//       int checks = 0;
//       while (state == AppAccessState.loading && checks < 30) {
//         await Future.delayed(const Duration(milliseconds: 100));
//         checks++;
//       }

//       if (state == AppAccessState.loading) {
//         state = AppAccessState.paywall;
//         notifyListeners();
//       }
//     } catch (e) {
//       state = AppAccessState.paywall;
//       notifyListeners();
//     }
//   }

//   void _handlePurchaseSuccess(PurchaseDetails purchase) {
//     if (purchase.productID == subscriptionId) {
//       state = AppAccessState.premium;
//       notifyListeners();
//     }
//   }

//   Future<void> buySubscription() async {
//     await service.buy(subscriptionId);
//   }

//   Future<void> restorePurchases() async {
//     await service.restorePurchases();
//   }
// }

import 'package:flutter/material.dart';
import 'package:dominos_score/data/services/in_app_purschase_services.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class SubscriptionViewModel extends ChangeNotifier {
  final IAPService service;

  final String subscriptionId = "basic_suscription";

<<<<<<< HEAD
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
=======
  bool _initialized = false;
  bool _initialCheckCompleted = false;

  SubscriptionViewModel(this.service) {
    // Escucha cambios en el estado de suscripción del servicio
    service.isSubscribed.addListener(_onSubscriptionStatusChanged);
  }

  void _onSubscriptionStatusChanged() {
    if (!_initialized) return;

    // Si ya pasó la verificación inicial o si la suscripción se activó después
    if (service.isSubscribed.value) {
      state = AppAccessState.premium;
      notifyListeners();
    } else {
      // Solo cambiamos a paywall si ya pasó el chequeo inicial y no estamos en loading
      if (_initialCheckCompleted && state != AppAccessState.loading) {
        state = AppAccessState.paywall;
        notifyListeners();
      }
    }
  }

  Future<void> initialize() async {
    if (_initialized && state != AppAccessState.loading) return;
    _initialized = true;

    try {
      state = AppAccessState.loading;
      notifyListeners();

      // Configurar callback (opcional, se puede usar para logging)
      service.onPurchaseSuccess = _handlePurchaseSuccess;

      // Inicializar servicio (carga productos, caché, etc.)
      // Nota: El servicio ya se encarga de restaurar compras si es necesario.
      await service.initialize();

      // Esperar hasta 3 segundos para que la primera verificación se complete
      // (caché + validación con Apple si había token)
      int checks = 0;
      const maxChecks = 30; // 30 * 100ms = 3 segundos
      while (checks < maxChecks && !_initialCheckCompleted) {
        await Future.delayed(const Duration(milliseconds: 100));
        checks++;

        // Si ya tenemos un estado definido (premium o paywall) por el valor actual,
        // damos por terminado el chequeo.
        if (service.isSubscribed.value) {
          _initialCheckCompleted = true;
          break;
        }
      }

      // Marcar que el chequeo inicial ha terminado
      if (!_initialCheckCompleted) {
        _initialCheckCompleted = true;
      }

      // Si después del chequeo inicial no estamos en premium, pasamos a paywall
      if (!service.isSubscribed.value) {
        state = AppAccessState.paywall;
        notifyListeners();
      } else {
        state = AppAccessState.premium;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error inicializando SubscriptionViewModel: $e');
      state = AppAccessState.paywall;
      notifyListeners();
    }
>>>>>>> suscription_implement
  }

  void _handlePurchaseSuccess(PurchaseDetails purchase) {
    // Este callback es opcional, el estado ya se maneja mediante isSubscribed
    // Lo dejamos por si necesitas hacer algo extra (ej. analíticas)
    if (purchase.productID == subscriptionId) {
<<<<<<< HEAD
      isPremium = true;
      isLoading = false;
      errorMessage = null;
      notifyListeners();
=======
      // El ValueNotifier ya actualizará el estado, así que no es necesario
      // llamar a notifyListeners() aquí.
>>>>>>> suscription_implement
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

  @override
  void dispose() {
    service.isSubscribed.removeListener(_onSubscriptionStatusChanged);
    super.dispose();
  }
}
