import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';

const String _kBasicSubscriptionId = 'basic_suscription';
const Set<String> _kProductIds = <String>{_kBasicSubscriptionId};

class SubscriptionViewModel extends ChangeNotifier {
  final InAppPurchase _inAppPurchase;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  List<ProductDetails> _products = [];
  List<ProductDetails> get products => _products;

  bool _isAvailable = false;
  bool get isAvailable => _isAvailable;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isPremium = false;
  bool get isPremium => _isPremium;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  late final Future<void> initializationComplete;

  SubscriptionViewModel({InAppPurchase? inAppPurchase})
    : _inAppPurchase = inAppPurchase ?? InAppPurchase.instance {
    initializationComplete = _initialize();
  }

  Future<void> _initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      _isAvailable = await _inAppPurchase.isAvailable();
      if (_isAvailable) {
        const Set<String> kIds = _kProductIds;
        final ProductDetailsResponse response = await _inAppPurchase
            .queryProductDetails(kIds);
        if (response.error == null) {
          _products = response.productDetails;
        }
      }

      final Stream<List<PurchaseDetails>> purchaseUpdated =
          _inAppPurchase.purchaseStream;
      _subscription = purchaseUpdated.listen(
        (List<PurchaseDetails> purchaseDetailsList) {
          _listenToPurchaseUpdated(purchaseDetailsList);
        },
        onDone: () {
          _subscription.cancel();
        },
        onError: (Object error) {
          debugPrint('Purchase Stream Error: $error');
        },
      );

      // Automatically restore purchases to check premium status from Apple
      if (_isAvailable) {
        await _inAppPurchase.restorePurchases();
      }
    } catch (e) {
      debugPrint('SubscriptionViewModel initialization error: $e');
      _errorMessage = 'Initialization failed: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> subscribe() async {
    if (_products.isEmpty) {
      _errorMessage = "No products available";
      notifyListeners();
      return;
    }

    ProductDetails productDetails;
    try {
      productDetails = _products.firstWhere(
        (product) => product.id == _kBasicSubscriptionId,
      );
    } catch (_) {
      productDetails = _products.first;
    }

    final PurchaseParam purchaseParam = PurchaseParam(
      productDetails: productDetails,
    );

    if (_isAvailable) {
      await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
    } else {
      _errorMessage = "Store not available";
      notifyListeners();
    }
  }

  Future<void> restorePurchases() async {
    _isLoading = true;
    notifyListeners();
    try {
      await _inAppPurchase.restorePurchases();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        _isLoading = true;
        notifyListeners();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          _isLoading = false;
          _errorMessage = purchaseDetails.error?.message ?? "Purchase failed";
          notifyListeners();
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          debugPrint(
            '🍎 APPLE PREMIUM RESPONSE: status=${purchaseDetails.status}, ID=${purchaseDetails.productID}, transactionDate=${purchaseDetails.transactionDate}',
          );
          _isPremium = true;
          _isLoading = false;
          notifyListeners();
        }

        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    });

    // If the list is empty and we are not pending, we might want to ensure loading is off
    if (purchaseDetailsList.isEmpty) {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      iosPlatformAddition.setDelegate(null);
    }
    _subscription.cancel();
    super.dispose();
  }
}
