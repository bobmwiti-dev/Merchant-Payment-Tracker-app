// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:merchant_payment_tracker_app/main.dart';

void main() {
  testWidgets('MerchantPaymentApp builds and shows sign-in screen',
      (WidgetTester tester) async {
    // Build app and trigger a frame.
    await tester.pumpWidget(const MerchantPaymentApp());

    // Basic smoke assertion: sign-in title text is present.
    expect(find.text('Welcome Back'), findsOneWidget);
  });
}
