import 'dart:async';
import 'package:dominos_score/domain/models/subscription/subscription_product.dart';
import 'package:dominos_score/presentation/viewmodel/subscription_viewmodel.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../../domain/repositories/subscription_repository.dart';

class SubscriptionRepositoryImpl implements ISubscriptionRepository {
  final InAppPurchase _iap = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _iapSubscription;
  final StreamController<PurchaseResult> _purchaseController =
      StreamController<PurchaseResult>.broadcast();
  final String _targetId;

  SubscriptionRepositoryImpl(this._targetId) {
    _iapSubscription = _iap.purchaseStream.listen(_handleUpdates);
  }

  @override
  Stream<PurchaseResult> get purchaseStream => _purchaseController.stream;

  @override
  Future<bool> checkAvailability() => _iap.isAvailable();

  @override
  Future<List<SubscriptionProduct>> getProducts(Set<String> productIds) async {
    final response = await _iap.queryProductDetails(productIds);
    return response.productDetails
        .map(
          (e) => SubscriptionProduct(
            id: e.id,
            title: e.title,
            description: e.description,
            price: e.price,
            rawProduct: e,
          ),
        )
        .toList();
  }

  @override
  Future<void> buyProduct(SubscriptionProduct product) async {
    final param = PurchaseParam(productDetails: product.rawProduct);
    await _iap.buyNonConsumable(purchaseParam: param);
  }

  @override
  Future<void> restorePurchases() => _iap.restorePurchases();

  void _handleUpdates(List<PurchaseDetails> updates) async {
    for (var update in updates) {
      if (update.status == PurchaseStatus.pending) {
        _purchaseController.add(PurchaseResult(PurchaseStatus.pending));
      } else if (update.status == PurchaseStatus.error) {
        _purchaseController.add(
          PurchaseResult(PurchaseStatus.error, error: update.error?.message),
        );
      } else if (update.productID == _targetId &&
          (update.status == PurchaseStatus.purchased ||
              update.status == PurchaseStatus.restored)) {
        _purchaseController.add(PurchaseResult(PurchaseStatus.purchased));
      }
      if (update.pendingCompletePurchase) await _iap.completePurchase(update);
    }
  }

  @override
  void dispose() {
    _iapSubscription.cancel();
    _purchaseController.close();
  }
}
