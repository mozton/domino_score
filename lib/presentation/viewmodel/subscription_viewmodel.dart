import 'package:flutter/material.dart';
import 'package:dominos_score/data/services/in_app_purschase_services.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum AppAccessState { loading, paywall, premium }

class SubscriptionViewModel extends ChangeNotifier {
  final IAPService service;

  AppAccessState state = AppAccessState.loading;

  final String subscriptionId = "basic_suscription";

  bool _initialized = false;
  bool _initialCheckCompleted = false;

  bool _hasConsumedFreeGame = false;
  bool get hasConsumedFreeGame => _hasConsumedFreeGame;
  
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

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

      // Revisar estado de juego gratis
      final consumedStr = await _secureStorage.read(key: 'free_game_consumed');
      _hasConsumedFreeGame = (consumedStr == 'true');

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
  }

  void _handlePurchaseSuccess(PurchaseDetails purchase) {
    // Este callback es opcional, el estado ya se maneja mediante isSubscribed
    // Lo dejamos por si necesitas hacer algo extra (ej. analíticas)
    if (purchase.productID == subscriptionId) {
      // El ValueNotifier ya actualizará el estado, así que no es necesario
      // llamar a notifyListeners() aquí.
    }
  }

  Future<void> buySubscription() async {
    await service.buy(subscriptionId);
  }

  Future<bool> restorePurchases() async {
    final oldSubscribed = service.isSubscribed.value;
    await service.restorePurchases();

    // Esperamos un tiempo razonable para que Apple responda a través del stream
    // y el IAPService actualice isSubscribed.value
    await Future.delayed(const Duration(seconds: 3));

    // Devolvemos si ahora está suscrito (especialmente si antes no lo estaba)
    return service.isSubscribed.value;
  }

  Future<void> consumeFreeGame() async {
    await _secureStorage.write(key: 'free_game_consumed', value: 'true');
    _hasConsumedFreeGame = true;
    notifyListeners();
  }

  @override
  void dispose() {
    service.isSubscribed.removeListener(_onSubscriptionStatusChanged);
    super.dispose();
  }
}
