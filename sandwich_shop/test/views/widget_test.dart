// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

// ignore: unused_import
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sandwich_shop/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app inside a MaterialApp and trigger a frame.
    await tester.pumpWidget(const App());
    // Let animations and frames settle.
    await tester.pumpAndSettle();

    // Verify the initial OrderItemDisplay text is present (0 footlong by default).
    expect(find.text('0 footlong sandwich(es): '), findsOneWidget);
  });
}
