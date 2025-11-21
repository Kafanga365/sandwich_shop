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

  testWidgets('Switch toggles sandwich size between six-inch and footlong',
      (WidgetTester tester) async {
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    // Initially should show footlong
    expect(find.text('0 footlong sandwich(es): '), findsOneWidget);

    // Find the Switch and tap it to toggle to six-inch
    const sizeKey = Key('size');

    final Finder sizeSwitch = find.byKey(sizeKey);
    expect(sizeSwitch, findsOneWidget);

    await tester.tap(sizeSwitch);
    await tester.pumpAndSettle();

    // After toggling, the display should update to six-inch
    expect(find.text('0 six-inch sandwich(es): '), findsOneWidget);

    // Toggle back to footlong to ensure bi-directional behavior
    await tester.tap(sizeSwitch);
    await tester.pumpAndSettle();
    expect(find.text('0 footlong sandwich(es): '), findsOneWidget);
  });
}
