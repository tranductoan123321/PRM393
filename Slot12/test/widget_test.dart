import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_profile_editor/main.dart';

void main() {
  testWidgets('SmartProfileEditorApp basic smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const SmartProfileEditorApp());
    expect(find.text('Smart Profile Editor'), findsOneWidget);
  });
}
