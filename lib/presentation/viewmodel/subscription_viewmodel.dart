// import 'dart:async';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';

// const String _kBasicSubscriptionId = 'basic_suscription';
// const Set<String> _kProductIds = <String>{_kBasicSubscriptionId};

// class SubscriptionViewModel extends ChangeNotifier {
//   final InAppPurchase _inAppPurchase;
//   late StreamSubscription<List<PurchaseDetails>> _subscription;

//   List<ProductDetails> _products = [];
//   List<ProductDetails> get products => _products;

//   bool _isAvailable = false;
//   bool get isAvailable => _isAvailable;

//   bool _isLoading = false;
//   bool get isLoading => _isLoading;

//   bool _isPremium = false;
//   bool get isPremium => _isPremium;

//   String? _errorMessage;
//   String? get errorMessage => _errorMessage;

//   bool _isInitialized = false;
//   bool get isInitialized => _isInitialized;

//   SubscriptionViewModel({InAppPurchase? inAppPurchase})
//     : _inAppPurchase = inAppPurchase ?? InAppPurchase.instance;

//   Future<void> initialize() async {
//     if (_isInitialized) return;

//     _isLoading = true;
//     Future.microtask(() => notifyListeners());

//     try {
//       _isAvailable = await _inAppPurchase.isAvailable();
//       if (_isAvailable) {
//         const Set<String> kIds = _kProductIds;
//         final ProductDetailsResponse response = await _inAppPurchase
//             .queryProductDetails(kIds);
//         if (response.error == null) {
//           _products = response.productDetails;
//           debugPrint('🍎 INITIALIZING: Found ${_products.length} products');
//           for (var p in _products) {
//             debugPrint('🍎 FOUND PRODUCT: id=${p.id}, status=${p.title}');
//           }
//         } else {
//           debugPrint('🍎 INITIALIZING ERROR: ${response.error!.message}');
//         }
//       }

//       final Stream<List<PurchaseDetails>> purchaseUpdated =
//           _inAppPurchase.purchaseStream;
//       _subscription = purchaseUpdated.listen(
//         (List<PurchaseDetails> purchaseDetailsList) {
//           debugPrint('🍎 STREAM_LISTEN: Received update from Apple');
//           _listenToPurchaseUpdated(purchaseDetailsList);
//         },
//         onDone: () {
//           debugPrint('🍎 STREAM_LISTEN: Done');
//           _subscription.cancel();
//         },
//         onError: (Object error) {
//           debugPrint('🍎 STREAM_LISTEN ERROR: $error');
//         },
//       );

//       // Automatically restore purchases to check premium status from Apple
//       if (_isAvailable) {
//         debugPrint('🍎 INITIALIZING: Calling restorePurchases...');
//         await _inAppPurchase.restorePurchases();
//         // Wait a bit for the stream to emit the results from restorePurchases
//         debugPrint('🍎 INITIALIZING: Waiting 3s for Apple sync...');
//         await Future.delayed(Duration(seconds: 3));
//         debugPrint(
//           '🍎 INITIALIZING: Done waiting. Premium status: $_isPremium',
//         );
//       }
//     } catch (e) {
//       debugPrint('SubscriptionViewModel initialization error: $e');
//       _errorMessage = 'Initialization failed: $e';
//     } finally {
//       _isInitialized = true;
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   Future<void> subscribe() async {
//     if (_products.isEmpty) {
//       _errorMessage = "No hay productos disponibles";
//       notifyListeners();
//       return;
//     }

//     ProductDetails productDetails;
//     try {
//       productDetails = _products.firstWhere(
//         (product) => product.id == _kBasicSubscriptionId,
//       );
//     } catch (_) {
//       productDetails = _products.first;
//     }

//     final PurchaseParam purchaseParam = PurchaseParam(
//       productDetails: productDetails,
//     );

//     if (_isAvailable) {
//       await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
//     } else {
//       _errorMessage = "La tienda no está disponible";
//       notifyListeners();
//     }
//   }

//   Future<void> restorePurchases() async {
//     _isLoading = true;
//     notifyListeners();
//     try {
//       debugPrint('🍎 MANUAL: Calling restorePurchases...');
//       await _inAppPurchase.restorePurchases();
//       await Future.delayed(const Duration(seconds: 1));
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   Future<void> _listenToPurchaseUpdated(
//     List<PurchaseDetails> purchaseDetailsList,
//   ) async {
//     debugPrint(
//       '🍎 STREAM: Received ${purchaseDetailsList.length} purchase updates',
//     );
//     for (var purchaseDetails in purchaseDetailsList) {
//       debugPrint(
//         '🍎 STREAM DETAIL: status=${purchaseDetails.status}, ID=${purchaseDetails.productID}',
//       );

//       if (purchaseDetails.status == PurchaseStatus.pending) {
//         _isLoading = true;
//         notifyListeners();
//       } else {
//         if (purchaseDetails.status == PurchaseStatus.error) {
//           _isLoading = false;
//           _errorMessage = purchaseDetails.error?.message ?? "Purchase failed";
//           notifyListeners();
//         } else if (purchaseDetails.status == PurchaseStatus.purchased ||
//             purchaseDetails.status == PurchaseStatus.restored) {
//           // STRICT CHECK: Ensure the product ID is the one we expect
//           if (purchaseDetails.productID == _kBasicSubscriptionId) {
//             debugPrint(
//               '🍎 APPLE PREMIUM SUCCESS: Validated ID matching $_kBasicSubscriptionId',
//             );
//             debugPrint(
//               '🍎 APPLE PREMIUM SUCCESS: Validated ID matching $_kBasicSubscriptionId',
//             );
//             _isPremium = true;
//             _isLoading = false;
//             notifyListeners();
//           } else {
//             debugPrint(
//               '🍎 APPLE PREMIUM IGNORED: ID ${purchaseDetails.productID} does not match $_kBasicSubscriptionId',
//             );
//           }
//         }

//         if (purchaseDetails.pendingCompletePurchase) {
//           await _inAppPurchase.completePurchase(purchaseDetails);
//         }
//       }
//     }

//     // If the list is empty and we are not pending, we might want to ensure loading is off
//     if (purchaseDetailsList.isEmpty) {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   // Clear error
//   void clearError() {
//     _errorMessage = null;
//     notifyListeners();
//   }

//   @override
//   void dispose() {
//     if (Platform.isIOS) {
//       final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
//           _inAppPurchase
//               .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
//       iosPlatformAddition.setDelegate(null);
//     }
//     _subscription.cancel();
//     super.dispose();
//   }
// }

import 'dart:async';
import 'package:dominos_score/domain/models/subscription/subscription_product.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart'; // Solo para el enum de status
import 'package:dominos_score/domain/repositories/subscription_repository.dart';

class PurchaseResult {
  final PurchaseStatus status;
  final String? error;
  PurchaseResult(this.status, {this.error});
}

class SubscriptionViewModel extends ChangeNotifier {
  final ISubscriptionRepository _repository;
  List<SubscriptionProduct> _products = [];
  bool _isLoading = false;
  bool _isPremium = false;
  String? _errorMessage;
  bool _isInitialized = false;

  SubscriptionViewModel(this._repository);

  // Getters
  List<SubscriptionProduct> get products => _products;
  bool get isLoading => _isLoading;
  bool get isPremium => _isPremium;
  String? get errorMessage => _errorMessage;

  void init() {
    if (_isInitialized) return;
    _repository.purchaseStream.listen(_handleResult);
    _loadProducts();
    _isInitialized = true;
  }

  Future<void> _loadProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      if (await _repository.checkAvailability()) {
        _products = await _repository.getProducts({'basic_suscription'});
        if (_products.isEmpty) {
          _errorMessage = 'No se encontraron productos asociadas en la tienda.';
        }
      } else {
        _errorMessage = 'La tienda no está disponible';
      }
    } catch (e) {
      _errorMessage = 'Error al cargar: $e';
    }
    _isLoading = false;
    notifyListeners();
  }

  void _handleResult(PurchaseResult result) {
    if (result.status == PurchaseStatus.pending) {
      _isLoading = true;
      _errorMessage = null;
    } else {
      _isLoading = false;
    }

    if (result.status == PurchaseStatus.error) {
      _errorMessage = result.error ?? 'Error en la compra';
    } else if (result.status == PurchaseStatus.purchased ||
        result.status == PurchaseStatus.restored) {
      _isPremium = true;
    }
    notifyListeners();
  }

  Future<void> subscribe() async {
    if (_products.isEmpty) {
      _errorMessage = 'No hay productos listos para comprar.';
      notifyListeners();
      return;
    }
    _errorMessage = null;
    _isLoading = true;
    notifyListeners();
    try {
      await _repository.buyProduct(_products.first);
      // Se detendrá la carga cuando llegue la respuesta del stream
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> restore() async {
    _errorMessage = null;
    _isLoading = true;
    notifyListeners();
    try {
      await _repository.restorePurchases();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}
