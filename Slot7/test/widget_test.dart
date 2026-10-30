import 'package:flutter_test/flutter_test.dart';
import 'package:simple_planner/main.dart';

void main() {
  testWidgets('My Planner initial UI smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify AppBar title is present.
    expect(find.text('My Planner'), findsOneWidget);

    // Verify Create Plan button is present.
    expect(find.text('Create Plan'), findsOneWidget);

    // Verify empty state text is shown.
    expect(
      find.text('No plans yet.\nTap "Create Plan" to add one.'),
      findsOneWidget,
    );
  });
}
