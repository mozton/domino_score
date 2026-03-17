import 'dart:async';
import 'dart:io';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';

class IAPService {
  final InAppPurchase _iap = InAppPurchase.instance;
  final List<String> productIds;

  List<ProductDetails> products = [];
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  // Callbacks
  Function(PurchaseDetails purchase)? onPurchaseSuccess;
  Function(String error)? onPurchaseError;

  IAPService(this.productIds);

  Future<bool> initialize() async {
    final available = await _iap.isAvailable();

    if (!available) {
      onPurchaseError?.call("La tienda no está disponible en este momento.");
      return false;
    }

    // if (Platform.isIOS) {
    //   final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
    //       _iap.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
    //   await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    // }

    _subscription = _iap.purchaseStream.listen(
      _handlePurchases,
      onDone: () {
        _subscription?.cancel();
      },
      onError: (error) {
        onPurchaseError?.call("Hubo un error al conectar con la tienda: ${error.toString()}");
      },
    );

    return await _loadProducts();
  }

  Future<bool> _loadProducts() async {
    final ProductDetailsResponse response =
        await _iap.queryProductDetails(productIds.toSet());

    if (response.error != null) {
      onPurchaseError?.call("Error al cargar productos: ${response.error!.message}");
      return false;
    }

    if (response.notFoundIDs.isNotEmpty) {
      // Opcional: registrar los IDs que no se encontraron
      print("No se encontraron los productos con IDs: ${response.notFoundIDs}");
    }

    products = response.productDetails;
    return products.isNotEmpty;
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
      onPurchaseError?.call("Producto no encontrado o aún no ha cargado.");
      return;
    }

    final param = PurchaseParam(productDetails: product);
    try {
      await _iap.buyNonConsumable(purchaseParam: param);
    } catch (e) {
      onPurchaseError?.call("Error al iniciar compra: ${e.toString()}");
    }
  }

  Future<void> restorePurchases() async {
    try {
      await _iap.restorePurchases();
    } catch (e) {
      onPurchaseError?.call("Error al restaurar compras: ${e.toString()}");
    }
  }

  void _handlePurchases(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      if (purchase.status == PurchaseStatus.pending) {
        // La transacción está pendiente. No hacer nada aquí, solo esperar.
      } else if (purchase.status == PurchaseStatus.error) {
        onPurchaseError?.call("La compra falló o fue cancelada: ${purchase.error?.message}");
      } else if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        
        // Aquí deberías validar el recibo con tu servidor
        bool valid = await _verifyPurchase(purchase);

        if (valid) {
          onPurchaseSuccess?.call(purchase);
        } else {
          onPurchaseError?.call("No se pudo verificar la validez de la compra.");
        }
      }

      if (purchase.pendingCompletePurchase) {
        try {
          // IMPORTANTE: siempre hay que llamar a completePurchase cuando termine.
          await _iap.completePurchase(purchase);
        } catch (e) {
          print("Error al completar compra: $e");
        }
      }
    }
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchase) async {
    // Si tuvieras servidor, enviarías purchase.verificationData
    return true; // Por ahora damos por válido todo
  }

  void dispose() {
    // if (Platform.isIOS) {
    //   final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
    //       _iap.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
    //   iosPlatformAddition.setDelegate(null);
    // }
    _subscription?.cancel();
  }
}

