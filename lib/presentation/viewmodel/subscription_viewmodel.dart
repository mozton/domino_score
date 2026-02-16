import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';

const String _kBasicSubscriptionId = 'basic_suscription';
const Set<String> _kProductIds = <String>{_kBasicSubscriptionId};

class SubscriptionViewModel extends ChangeNotifier {
  final InAppPurchase _inAppPurchase;
  final FlutterSecureStorage _secureStorage;
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

  SubscriptionViewModel(this._secureStorage, {InAppPurchase? inAppPurchase})
      : _inAppPurchase = inAppPurchase ?? InAppPurchase.instance {
    initializationComplete = _initialize();
  }

  Future<void> _initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Check if premium is already stored locally
      await _checkPremiumStatus();

      _isAvailable = await _inAppPurchase.isAvailable();
      if (_isAvailable) {
        const Set<String> kIds = _kProductIds;
        final ProductDetailsResponse response =
            await _inAppPurchase.queryProductDetails(kIds);
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
          // handle error here.
          debugPrint('Purchase Stream Error: $error');
        },
      );
    } catch (e) {
      debugPrint('SubscriptionViewModel initialization error: $e');
      _errorMessage = 'Initialization failed: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _checkPremiumStatus() async {
    final String? value = await _secureStorage.read(key: 'is_premium');
    _isPremium = value == 'true';
    notifyListeners();
  }

  Future<void> _setPremiumStatus(bool status) async {
    _isPremium = status;
    await _secureStorage.write(key: 'is_premium', value: status.toString());
    notifyListeners();
  }

  Future<void> subscribe() async {
    if (_products.isEmpty) {
      _errorMessage = "No products available";
      notifyListeners();
      return;
    }

    final ProductDetails productDetails = _products.firstWhere(
      (product) => product.id == _kBasicSubscriptionId,
      orElse: () => _products.first,
    );

    final PurchaseParam purchaseParam =
        PurchaseParam(productDetails: productDetails);

    if (_isAvailable) {
      if (Platform.isIOS) {
        // Ensure the transaction is not finished before we process it
        // _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam); -> Use this for non-consumables
        // For auto-renewable subscriptions, buyNonConsumable is also often used,
        // but let's verify if buyConsumable is safer or if wrapper handles it.
        // Actually for subscriptions, use buyNonConsumable usually.
         await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
      } else {
        await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
      }
    } else {
       _errorMessage = "Store not available";
       notifyListeners();
    }
  }

  Future<void> restorePurchases() async {
    await _inAppPurchase.restorePurchases();
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
          
          await _setPremiumStatus(true);
          _isLoading = false;
          notifyListeners();
        }
        
        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    });
  }
  
  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    if(Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
        _inAppPurchase.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      iosPlatformAddition.setDelegate(null);
    }
    _subscription.cancel();
    super.dispose();
  }
}
