import 'dart:async';

import 'package:dominos_score/presentation/view/screen/subscription/subscription_screen.dart';
import 'package:dominos_score/presentation/viewmodel/subscription_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

class MockInAppPurchase extends Mock implements InAppPurchase {}

class MockProductDetails extends Mock implements ProductDetails {}

void main() {
  late MockFlutterSecureStorage mockSecureStorage;
  late MockInAppPurchase mockInAppPurchase;
  late SubscriptionViewModel viewModel;

  setUp(() {
    registerFallbackValue(<String>{});
    mockSecureStorage = MockFlutterSecureStorage();
    mockInAppPurchase = MockInAppPurchase();

    // Mock initial interactions
    when(() => mockSecureStorage.read(key: 'is_premium'))
        .thenAnswer((_) async => null);
    when(() => mockInAppPurchase.isAvailable()).thenAnswer((_) async => true);
    when(() => mockInAppPurchase.purchaseStream)
        .thenAnswer((_) => Stream.value([]));
    when(() => mockInAppPurchase.queryProductDetails(any()))
        .thenAnswer((_) async => ProductDetailsResponse(
              productDetails: [],
              notFoundIDs: [],
            ));

    viewModel = SubscriptionViewModel(
      mockSecureStorage,
      inAppPurchase: mockInAppPurchase,
    );
  });

  Widget createWidgetUnderTest() {
    return ChangeNotifierProvider<SubscriptionViewModel>.value(
      value: viewModel,
      child: const MaterialApp(
        home: SubscriptionScreen(),
      ),
    );
  }

  testWidgets('SubscriptionScreen shows subscription button when not premium',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.runAsync(() async {
      await viewModel.initializationComplete;
    });
    await tester.pump(); // Rebuild after init completes

    expect(find.text('Suscribirse Ahora'), findsOneWidget);
    expect(find.text('Restaurar Compras'), findsOneWidget);
    expect(find.text('Ya eres Premium'), findsNothing);
  });

  testWidgets('SubscriptionScreen shows premium badge when premium',
      (WidgetTester tester) async {
    // Setup premium state
    when(() => mockSecureStorage.read(key: 'is_premium'))
        .thenAnswer((_) async => 'true');
    
    // Re-init view model with new storage state
     viewModel = SubscriptionViewModel(
      mockSecureStorage,
      inAppPurchase: mockInAppPurchase,
    );

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.runAsync(() async {
      await viewModel.initializationComplete;
    });
    await tester.pump();

    expect(find.text('Ya eres Premium'), findsOneWidget);
    expect(find.text('Suscribirse Ahora'), findsNothing);
  });
}
