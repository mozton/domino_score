// import 'dart:async';
// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class SubscriptionService {
//   final InAppPurchase _iap = InAppPurchase.instance;
//   final String _kPremiumProductId = 'basic_suscription';
//   final String _kIsSubscribedKey = 'is_subscribed';

//   bool _isAvailable = false;
//   List<ProductDetails> _products = [];
//   final StreamController<bool> _subscriptionStatusController =
//       StreamController<bool>.broadcast();

//   Stream<bool> get subscriptionStatus => _subscriptionStatusController.stream;

//   Future<void> init() async {
//     _isAvailable = await _iap.isAvailable();
//     print('SubscriptionService: isAvailable = $_isAvailable');
//     if (_isAvailable) {
//       const Set<String> _kIds = <String>{'basic_suscription'};
//       final ProductDetailsResponse response = await _iap.queryProductDetails(
//         _kIds,
//       );

//       print(
//         'SubscriptionService: Found ${response.productDetails.length} products',
//       );
//       if (response.notFoundIDs.isNotEmpty) {
//         print('SubscriptionService: Not found IDs: ${response.notFoundIDs}');
//       }

//       if (response.notFoundIDs.isEmpty) {
//         _products = response.productDetails;
//         print('SubscriptionService: Products loaded: $_products');
//       }

//       // Listen to purchase updates
//       _iap.purchaseStream.listen(
//         (List<PurchaseDetails> purchaseDetailsList) {
//           print("TEST");
//           _listenToPurchaseUpdated(purchaseDetailsList);
//         },
//         onDone: () {
//           // subscriptionStream.cancel();
//         },
//         onError: (error) {
//           print('SubscriptionService: Purchase Stream Error: $error');
//         },
//       );
//     } else {
//       print('SubscriptionService: Store not available');
//     }
//   }

//   Future<bool> get isSubscribed async {
//     // Check local storage first for offline access
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getBool(_kIsSubscribedKey) ?? false;
//   }

//   ProductDetails? get premiumProduct {
//     if (_products.isNotEmpty) {
//       // Assuming we only have one product for now
//       try {
//         return _products.firstWhere((p) => p.id == _kPremiumProductId);
//       } catch (e) {
//         print(
//           'SubscriptionService: Product $_kPremiumProductId not found in list',
//         );
//         return null; // Or return first available
//       }
//     }
//     return null;
//   }

//   Future<void> buySubscription() async {
//     print(
//       'SubscriptionService: Attempts to buy. Available: $_isAvailable, Products: ${_products.length}',
//     );
//     if (!_isAvailable || _products.isEmpty) return;

//     final ProductDetails? productDetails = premiumProduct;
//     if (productDetails != null) {
//       final PurchaseParam purchaseParam = PurchaseParam(
//         productDetails: productDetails,
//       );
//       print(
//         'SubscriptionService: Initiating purchase for ${productDetails.id}',
//       );
//       await _iap.buyNonConsumable(purchaseParam: purchaseParam);
//     } else {
//       print('SubscriptionService: premiumProduct is null');
//     }
//   }

//   Future<void> restorePurchases() async {
//     if (!_isAvailable) return;
//     await _iap.restorePurchases();
//   }

//   void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
//     purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
//       if (purchaseDetails.status == PurchaseStatus.pending) {
//         // UI should show pending
//       } else {
//         if (purchaseDetails.status == PurchaseStatus.error) {
//           // handleError(purchaseDetails.error!);
//         } else if (purchaseDetails.status == PurchaseStatus.purchased ||
//             purchaseDetails.status == PurchaseStatus.restored) {
//           await _verifyPurchase(purchaseDetails);
//         }

//         if (purchaseDetails.pendingCompletePurchase) {
//           await _iap.completePurchase(purchaseDetails);
//         }
//       }
//     });
//   }

//   Future<void> _verifyPurchase(PurchaseDetails purchaseDetails) async {
//     // IMPORTANT: In a real app, you should verify the receipt on your backend.
//     // For this implementation, we will trust the client (less secure).

//     // If verification is successful:
//     await _setSubscribed(true);
//   }

//   Future<void> _setSubscribed(bool status) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool(_kIsSubscribedKey, status);
//     _subscriptionStatusController.add(status);
//   }
// }
