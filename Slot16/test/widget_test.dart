import 'package:flutter_test/flutter_test.dart';
import 'package:auth_session_app/main.dart';

void main() {
  testWidgets('App renders LoginScreen when not logged in', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp(initialLoggedIn: false));
    await tester.pumpAndSettle();

    expect(find.text('Login'), findsWidgets);
    expect(find.text('Username'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
  });
}
