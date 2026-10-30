import 'package:flutter_test/flutter_test.dart';
import 'package:product_explorer/main.dart';

void main() {
  testWidgets('ProductExplorerApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProductExplorerApp());
    expect(find.byType(ProductExplorerApp), findsOneWidget);
  });
}
