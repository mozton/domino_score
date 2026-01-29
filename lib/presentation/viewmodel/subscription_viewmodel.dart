import 'package:dominos_score/data/services/subscription_service.dart';
import 'package:flutter/material.dart';

class SubscriptionViewModel extends ChangeNotifier {
  final SubscriptionService _subscriptionService;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSubscribed = false;
  bool get isSubscribed => _isSubscribed;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  SubscriptionViewModel(this._subscriptionService) {
    _init();
  }

  void _init() async {
    _isLoading = true;
    notifyListeners();

    await _subscriptionService.init();
    _isSubscribed = await _subscriptionService.isSubscribed;

    // Listen to stream for real-time updates
    _subscriptionService.subscriptionStatus.listen((status) {
      _isSubscribed = status;
      notifyListeners();
    });

    _isLoading = false;
    notifyListeners();
  }

  Future<void> buySubscription() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _subscriptionService.buySubscription();
      // Status update will be handled by the stream listener
    } catch (e) {
      _errorMessage = "Error iniciando compra: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> restorePurchases() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _subscriptionService.restorePurchases();
    } catch (e) {
      _errorMessage = "Error restaurando compras: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
