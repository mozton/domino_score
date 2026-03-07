import 'dart:async';
import 'package:in_app_purchase/in_app_purchase.dart';

class SubscriptionService {
  static final SubscriptionService instance = SubscriptionService._();

  SubscriptionService._();

  final InAppPurchase _iap = InAppPurchase.instance;

  late StreamSubscription<List<PurchaseDetails>> _subscription;

  final StreamController<PurchaseDetails> _purchaseController =
      StreamController.broadcast();

  Stream<PurchaseDetails> get purchaseStream => _purchaseController.stream;

  Future<void> initialize() async {
    final available = await _iap.isAvailable();

    if (!available) {
      throw Exception("In-App Purchases no disponible");
    }

    _subscription = _iap.purchaseStream.listen(_listenToPurchase);
  }

  void _listenToPurchase(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      _purchaseController.add(purchase);

      if (purchase.pendingCompletePurchase) {
        await _iap.completePurchase(purchase);
      }
    }
  }

  Future<List<ProductDetails>> loadProducts(Set<String> ids) async {
    final response = await _iap.queryProductDetails(ids);

    if (response.notFoundIDs.isNotEmpty) {
      throw Exception("Productos no encontrados: ${response.notFoundIDs}");
    }

    return response.productDetails;
  }

  Future<void> buy(ProductDetails product) async {
    final param = PurchaseParam(productDetails: product);

    await _iap.buyNonConsumable(purchaseParam: param);
  }

  Future<void> restore() async {
    await _iap.restorePurchases();
  }

  void dispose() {
    _subscription.cancel();
    _purchaseController.close();
  }
}
