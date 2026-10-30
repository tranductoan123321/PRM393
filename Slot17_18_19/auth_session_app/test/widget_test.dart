import 'package:flutter_test/flutter_test.dart';
import 'package:auth_session_app/main.dart';

void main() {
  testWidgets('App loads LoginScreen when not logged in', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp(initialLoggedIn: false));
    expect(find.text('Login'), findsWidgets);
  });
}
