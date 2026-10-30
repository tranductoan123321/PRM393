import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:student_list_app/main.dart';

void main() {
  testWidgets('Student List App displays items and handles tap', (WidgetTester tester) async {
    await tester.pumpWidget(const StudentListApp());

    // Verify AppBar title
    expect(find.text('Student List'), findsOneWidget);

    // Verify first student item is shown
    expect(find.text('Nguyễn Văn A'), findsOneWidget);
    expect(find.text('SV01'), findsOneWidget);

    // Initially icon is circle_outlined
    expect(find.byIcon(Icons.circle_outlined), findsWidgets);

    // Tap on the first student card
    await tester.tap(find.text('Nguyễn Văn A'));
    await tester.pump();

    // Verify check_circle icon appears for selected item
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
  });
}
