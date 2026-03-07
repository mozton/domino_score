import 'package:dominos_score/domain/models/subscription/subscription_product.dart';
import 'package:dominos_score/presentation/viewmodel/subscription_viewmodel.dart';

abstract class ISubscriptionRepository {
  Future<bool> checkAvailability();
  Future<List<SubscriptionProduct>> getProducts(Set<String> productIds);
  Future<void> buyProduct(SubscriptionProduct product);
  Future<void> restorePurchases();
  Stream<PurchaseResult> get purchaseStream;
  void dispose();
}
