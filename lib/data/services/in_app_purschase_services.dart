import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:verify_local_purchase/verify_local_purchase.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';

class IAPService {
  final InAppPurchase _iap = InAppPurchase.instance;
  final List<String> productIds;
  List<ProductDetails> products = [];
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  final ValueNotifier<bool> isSubscribed = ValueNotifier<bool>(false);
  final ValueNotifier<DateTime?> expirationDate = ValueNotifier<DateTime?>(
    null,
  );

  Function(PurchaseDetails purchase)? onPurchaseSuccess;

  String? _currentOriginalTransactionId;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  IAPService(this.productIds);

  Future<void> initialize() async {
    await dotenv.load(fileName: "assets/api_keys.env");

    VerifyLocalPurchase.initialize(
      appleConfig: AppleConfig(
        bundleId: dotenv.env['APPLE_BUNDLE_ID']!,
        issuerId: dotenv.env['APPLE_ISSUER_ID']!,
        keyId: dotenv.env['APPLE_KEY_ID']!,
        privateKey: dotenv.env['APPLE_PRIVATE_KEY']!.replaceAll(r'\n', '\n'),
        useSandbox:
            !kReleaseMode, // true en Debug (TestFlight/Emulador), false en Producción (App Store)
      ),
    );

    final available = await _iap.isAvailable();
    if (!available) return;

    await _loadProducts();

    _subscription = _iap.purchaseStream.listen(
      _handlePurchases,
      onError: (error) {
        // print("Error en el stream de compras: $error");
      },
    );

    await _loadCachedSubscription();

    if (_currentOriginalTransactionId != null) {
      final isValid = await verifySubscriptionWithApple(
        _currentOriginalTransactionId!,
      );
      if (isValid) {
        isSubscribed.value = true;
      } else {
        await _clearSubscriptionCache();
      }
    } else {
      await restorePurchases();
    }
  }

  Future<void> _loadProducts() async {
    final response = await _iap.queryProductDetails(productIds.toSet());
    if (response.error == null) {
      products = response.productDetails;
    } else {
      // print("Error cargando productos: ${response.error}");
    }
  }

  ProductDetails? getProduct(String id) {
    try {
      return products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> buy(String productId) async {
    final product = getProduct(productId);
    if (product == null) {
      throw Exception("Producto no encontrado");
    }
    final param = PurchaseParam(productDetails: product);
    await _iap.buyNonConsumable(purchaseParam: param);
  }

  Future<void> restorePurchases() async {
    await _iap.restorePurchases();
  }

  String? _getOriginalTransactionId(PurchaseDetails purchase) {
    if (Platform.isIOS) {
      try {
        final localData = purchase.verificationData.localVerificationData;
        final Map<String, dynamic> data = jsonDecode(localData);
        return data['originalTransactionId'] as String?;
      } catch (e) {
        return purchase.purchaseID;
      }
    } else {
      return purchase.verificationData.serverVerificationData;
    }
  }

  Future<bool> verifySubscriptionWithApple(String originalTransactionId) async {
    try {
      final verifyPurchase = VerifyLocalPurchase();
      final isActive = await verifyPurchase.verifySubscriptionWithAppStore(
        originalTransactionId,
      );
      return isActive;
    } catch (e) {
      // print("Error verificando suscripción con Apple: $e");
      return false;
    }
  }

  Future<void> _cacheSubscription(
    String transactionId,
    DateTime? expiration,
  ) async {
    await _secureStorage.write(
      key: 'original_transaction_id',
      value: transactionId,
    );
    await _secureStorage.write(key: 'subscription_active', value: 'true');
    if (expiration != null) {
      await _secureStorage.write(
        key: 'subscription_expiration',
        value: expiration.toIso8601String(),
      );
    }
  }

  Future<void> _loadCachedSubscription() async {
    final transactionId = await _secureStorage.read(
      key: 'original_transaction_id',
    );
    final active = await _secureStorage.read(key: 'subscription_active');
    final expirationStr = await _secureStorage.read(
      key: 'subscription_expiration',
    );

    if (transactionId != null && active == 'true') {
      _currentOriginalTransactionId = transactionId;
      if (expirationStr != null) {
        final exp = DateTime.tryParse(expirationStr);
        if (exp != null) {
          expirationDate.value = exp;
        }
      }
    }
  }

  Future<void> _clearSubscriptionCache() async {
    await _secureStorage.delete(key: 'original_transaction_id');
    await _secureStorage.delete(key: 'subscription_active');
    await _secureStorage.delete(key: 'subscription_expiration');
    _currentOriginalTransactionId = null;
    isSubscribed.value = false;
    expirationDate.value = null;
  }

  void _handlePurchases(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      switch (purchase.status) {
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          final transactionId = _getOriginalTransactionId(purchase);
          if (transactionId == null) {
            // print("No se pudo obtener transactionId para validar");
            break;
          }

          final isValid = await verifySubscriptionWithApple(transactionId);
          if (isValid) {
            _currentOriginalTransactionId = transactionId;
            DateTime? expiration;
            await _cacheSubscription(transactionId, expiration);
            isSubscribed.value = true;
            // ignore: unnecessary_null_comparison
            if (expiration != null) expirationDate.value = expiration;
            onPurchaseSuccess?.call(purchase);
          } else {
            // print("La compra no es válida (reembolsada o expirada)");
          }
          break;

        case PurchaseStatus.error:
        case PurchaseStatus.canceled:
          // No hacemos nada
          break;

        default:
          break;
      }

      if (purchase.pendingCompletePurchase) {
        await _iap.completePurchase(purchase);
      }
    }
  }

  Future<bool> refreshSubscriptionStatus() async {
    if (_currentOriginalTransactionId == null) {
      isSubscribed.value = false;
      return false;
    }
    final isValid = await verifySubscriptionWithApple(
      _currentOriginalTransactionId!,
    );
    if (isValid) {
      isSubscribed.value = true;
      return true;
    } else {
      await _clearSubscriptionCache();
      return false;
    }
  }

  void dispose() {
    _subscription?.cancel();
    isSubscribed.dispose();
    expirationDate.dispose();
  }
}
