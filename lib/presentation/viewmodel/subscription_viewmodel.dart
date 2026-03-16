import 'package:dominos_score/data/services/in_app_purschase_services.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

enum AppAccessState { loading, paywall, premium }

class SubscriptionViewModel extends ChangeNotifier {
  final IAPService service;

  AppAccessState state = AppAccessState.loading;

  final String subscriptionId = "basic_suscription";

  SubscriptionViewModel(this.service);

  Future<void> initialize() async {
    try {
      await service.initialize();

      service.onPurchaseSuccess = _handlePurchaseSuccess;

      await service.restorePurchases();

      state = AppAccessState.paywall;
    } catch (e) {
      state = AppAccessState.paywall;
    }

    notifyListeners();
  }

  void _handlePurchaseSuccess(PurchaseDetails purchase) {
    if (purchase.productID == subscriptionId) {
      state = AppAccessState.premium;

      notifyListeners();
    }
  }

  Future<void> buySubscription() async {
    await service.buy(subscriptionId);
  }

  Future<void> restorePurchases() async {
    await service.restorePurchases();
  }
}
