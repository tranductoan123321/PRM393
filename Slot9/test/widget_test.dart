import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:simple_dashboard_app/main.dart';

void main() {
  testWidgets('Dashboard renders and navigates to products grid', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that Dashboard elements are rendered.
    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Hello, User 👋'), findsOneWidget);
    expect(find.text('Welcome to Simple Product Dashboard'), findsOneWidget);
    expect(find.text('Xem danh sách sản phẩm'), findsOneWidget);

    // Tap button to navigate to products screen.
    await tester.tap(find.text('Xem danh sách sản phẩm'));
    await tester.pumpAndSettle();

    // Verify that Products screen is rendered.
    expect(find.text('Products'), findsOneWidget);
    expect(find.text('Product #0'), findsOneWidget);
    expect(find.text('\$10.00'), findsOneWidget);
  });
}
