import 'package:flutter_test/flutter_test.dart';
import 'package:live_counter_stream/main.dart';

void main() {
  testWidgets('Live Counter Stream App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the title is rendered.
    expect(find.text('Live Counter Stream App'), findsOneWidget);

    // Initial state: Waiting for stream or shows loading/waiting
    await tester.pump();
    
    // Check buttons are present
    expect(find.text('Start / Resume'), findsOneWidget);
    expect(find.text('Pause'), findsOneWidget);
    expect(find.text('Reset'), findsOneWidget);
  });
}
