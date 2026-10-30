import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_registration_app/main.dart';

void main() {
  testWidgets('Smart Registration App smoke and validation test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Register'), findsWidgets);

    // Tap register without filling anything
    await tester.tap(find.widgetWithText(ElevatedButton, 'Register'));
    await tester.pump();

    // Check validation errors
    expect(find.text('Field is required'), findsNWidgets(2)); // Name & Confirm Password
    expect(find.text('Email required'), findsOneWidget);
    expect(find.text('Password must be at least 6 characters'), findsOneWidget);
  });
}
