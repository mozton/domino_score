import 'dart:async';
import 'package:in_app_purchase/in_app_purchase.dart';

class IAPService {
  final InAppPurchase _iap = InAppPurchase.instance;

  final List<String> productIds;

  List<ProductDetails> products = [];

  StreamSubscription<List<PurchaseDetails>>? _subscription;

  Function(PurchaseDetails purchase)? onPurchaseSuccess;

  IAPService(this.productIds);

  Future<void> initialize() async {
    final available = await _iap.isAvailable();

    if (!available) {
      throw Exception("Store not available");
    }

    await _loadProducts();

    _subscription = _iap.purchaseStream.listen(
      _handlePurchases,
      onError: (error) {},
    );
  }

  Future<void> _loadProducts() async {
    final response = await _iap.queryProductDetails(productIds.toSet());

    if (response.error != null) {
      throw Exception(response.error!.message);
    }

    products = response.productDetails;
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
      throw Exception("Product not found");
    }

    final param = PurchaseParam(productDetails: product);

    await _iap.buyNonConsumable(purchaseParam: param);
  }

  Future<void> restorePurchases() async {
    await _iap.restorePurchases();
  }

  void _handlePurchases(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      switch (purchase.status) {
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          bool valid = await _verifyPurchase(purchase);

          if (valid) {
            onPurchaseSuccess?.call(purchase);
          }

          break;

        case PurchaseStatus.pending:
        case PurchaseStatus.error:
        case PurchaseStatus.canceled:
          break;
      }

      if (purchase.pendingCompletePurchase) {
        await _iap.completePurchase(purchase);
      }
    }
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchase) async {
    // Aquí debería ir la validación con servidor
    return true;
  }

  void dispose() {
    _subscription?.cancel();
  }
}
