// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';

// class IAPService {
//   final InAppPurchase _iap = InAppPurchase.instance;
//   final List<String> productIds;
//   List<ProductDetails> products = [];
//   StreamSubscription<List<PurchaseDetails>>? _subscription;

//   // 1. Variable reactiva para el estado de suscripción
//   final ValueNotifier<bool> isSubscribed = ValueNotifier<bool>(false);

//   Function(PurchaseDetails purchase)? onPurchaseSuccess;

//   IAPService(this.productIds);

//   Future<void> initialize() async {
//     final available = await _iap.isAvailable();
//     if (!available) return;

//     await _loadProducts();

//     _subscription = _iap.purchaseStream.listen(
//       _handlePurchases,
//       onError: (error) {
//         print("Error en el stream: $error");
//       },
//     );

//     // 2. Al iniciar, verificamos si ya tiene suscripciones activas
//     await restorePurchases();
//   }

//   Future<void> _loadProducts() async {
//     final response = await _iap.queryProductDetails(productIds.toSet());
//     if (response.error == null) {
//       products = response.productDetails;
//     }
//   }

//   ProductDetails? getProduct(String id) {
//     try {
//       return products.firstWhere((p) => p.id == id);
//     } catch (_) {
//       return null;
//     }
//   }

//   Future<void> buy(String productId) async {
//     final product = getProduct(productId);

//     if (product == null) {
//       throw Exception("Product not found");
//     }

//     final param = PurchaseParam(productDetails: product);

//     await _iap.buyNonConsumable(purchaseParam: param);
//   }

//   Future<void> restorePurchases() async {
//     // Esto disparará el evento en _handlePurchases si hay compras previas
//     await _iap.restorePurchases();
//   }

//   void _handlePurchases(List<PurchaseDetails> purchases) async {
//     if (purchases.isEmpty) {
//       isSubscribed.value = false; // Opcional: manejar si no hay nada
//     }

//     for (final purchase in purchases) {
//       switch (purchase.status) {
//         case PurchaseStatus.purchased:
//         case PurchaseStatus.restored:
//           // 3. Si el ID coincide y el status es correcto, marcamos como suscrito
//           if (productIds.contains(purchase.productID)) {
//             isSubscribed.value = true;
//           }
//           onPurchaseSuccess?.call(purchase);
//           break;

//         case PurchaseStatus.error:
//         case PurchaseStatus.canceled:
//           // Podrías resetear el estado si es una compra fallida nueva
//           // isSubscribed.value = false;
//           break;

//         default:
//           break;
//       }

//       if (purchase.pendingCompletePurchase) {
//         await _iap.completePurchase(purchase);
//       }
//     }
//   }

//   void dispose() {
//     _subscription?.cancel();
//     isSubscribed.dispose(); // Limpiar el notifier
//   }
// }

import 'dart:async';
<<<<<<< HEAD
import 'dart:io';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
=======
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:verify_local_purchase/verify_local_purchase.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
>>>>>>> suscription_implement

class IAPService {
  final InAppPurchase _iap = InAppPurchase.instance;
  final List<String> productIds;
  List<ProductDetails> products = [];
  StreamSubscription<List<PurchaseDetails>>? _subscription;

<<<<<<< HEAD
  // Callbacks
=======
  final ValueNotifier<bool> isSubscribed = ValueNotifier<bool>(false);
  final ValueNotifier<DateTime?> expirationDate = ValueNotifier<DateTime?>(
    null,
  );

>>>>>>> suscription_implement
  Function(PurchaseDetails purchase)? onPurchaseSuccess;
  Function(String error)? onPurchaseError;

  String? _currentOriginalTransactionId;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  IAPService(this.productIds);

<<<<<<< HEAD
  Future<bool> initialize() async {
    final available = await _iap.isAvailable();

    if (!available) {
      onPurchaseError?.call("La tienda no está disponible en este momento.");
      return false;
    }
=======
  Future<void> initialize() async {
    await dotenv.load(fileName: "assets/api_keys.env");

    VerifyLocalPurchase.initialize(
      appleConfig: AppleConfig(
        bundleId: dotenv.env['APPLE_BUNDLE_ID']!,
        issuerId: dotenv.env['APPLE_ISSUER_ID']!,
        keyId: dotenv.env['APPLE_KEY_ID']!,
        privateKey: dotenv.env['APPLE_PRIVATE_KEY']!.replaceAll(r'\n', '\n'),
        useSandbox: true,
      ),
    );

    final available = await _iap.isAvailable();
    if (!available) return;
>>>>>>> suscription_implement

    // if (Platform.isIOS) {
    //   final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
    //       _iap.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
    //   await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    // }

<<<<<<< HEAD
    if (_subscription == null) {
      _subscription = _iap.purchaseStream.listen(
        _handlePurchases,
        onDone: () {
          _subscription?.cancel();
        },
        onError: (error) {
          onPurchaseError?.call("Hubo un error al conectar con la tienda: ${error.toString()}");
        },
      );
    }

    return await _loadProducts();
  }

  Future<bool> _loadProducts() async {
    final ProductDetailsResponse response =
        await _iap.queryProductDetails(productIds.toSet());

    if (response.error != null) {
      onPurchaseError?.call("Error al cargar productos: ${response.error!.message}");
      return false;
    }

    if (response.notFoundIDs.isNotEmpty) {
      // Opcional: registrar los IDs que no se encontraron
      print("No se encontraron los productos con IDs: ${response.notFoundIDs}");
    }

    products = response.productDetails;
    return products.isNotEmpty;
=======
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
>>>>>>> suscription_implement
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
<<<<<<< HEAD
      onPurchaseError?.call("Producto no encontrado o aún no ha cargado.");
      return;
=======
      throw Exception("Producto no encontrado");
>>>>>>> suscription_implement
    }
    final param = PurchaseParam(productDetails: product);
<<<<<<< HEAD
    try {
      await _iap.buyNonConsumable(purchaseParam: param);
    } catch (e) {
      onPurchaseError?.call("Error al iniciar compra: ${e.toString()}");
    }
=======
    await _iap.buyNonConsumable(purchaseParam: param);
>>>>>>> suscription_implement
  }

  Future<void> restorePurchases() async {
    try {
      await _iap.restorePurchases();
    } catch (e) {
      onPurchaseError?.call("Error al restaurar compras: ${e.toString()}");
    }
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
<<<<<<< HEAD
      if (purchase.status == PurchaseStatus.pending) {
        // La transacción está pendiente. No hacer nada aquí, solo esperar.
      } else if (purchase.status == PurchaseStatus.error) {
        onPurchaseError?.call("La compra falló o fue cancelada: ${purchase.error?.message}");
      } else if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        
        // Aquí deberías validar el recibo con tu servidor
        bool valid = await _verifyPurchase(purchase);

        if (valid) {
          onPurchaseSuccess?.call(purchase);
        } else {
          onPurchaseError?.call("No se pudo verificar la validez de la compra.");
        }
=======
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
>>>>>>> suscription_implement
      }

      if (purchase.pendingCompletePurchase) {
        try {
          // IMPORTANTE: siempre hay que llamar a completePurchase cuando termine.
          await _iap.completePurchase(purchase);
        } catch (e) {
          print("Error al completar compra: $e");
        }
      }
    }
  }

<<<<<<< HEAD
  Future<bool> _verifyPurchase(PurchaseDetails purchase) async {
    // Si tuvieras servidor, enviarías purchase.verificationData
    return true; // Por ahora damos por válido todo
=======
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
>>>>>>> suscription_implement
  }

  void dispose() {
    // if (Platform.isIOS) {
    //   final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
    //       _iap.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
    //   iosPlatformAddition.setDelegate(null);
    // }
    _subscription?.cancel();
    isSubscribed.dispose();
    expirationDate.dispose();
  }
}

