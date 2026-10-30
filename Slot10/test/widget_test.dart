import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_dashboard/main.dart';

void main() {
  testWidgets('Dashboard loads smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ResponsiveDashboardApp());

    // Verify that our title and header render.
    expect(find.text('Dashboard'), findsWidgets);
    expect(find.text('Revenue'), findsOneWidget);
  });
}
