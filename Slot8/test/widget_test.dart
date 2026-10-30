import 'package:flutter_test/flutter_test.dart';

import 'package:student_manager_app/main.dart';

void main() {
  testWidgets('Navigation smoke test', (WidgetTester tester) async {
    // 1. Build StudentManagerApp
    await tester.pumpWidget(const StudentManagerApp());

    // 2. Kiểm tra HomeScreen hiển thị nút 'Xem danh sách sinh viên'
    expect(find.text('Student Manager - Home'), findsOneWidget);
    expect(find.text('Xem danh sách sinh viên'), findsOneWidget);

    // 3. Chạm vào nút xem danh sách để điều hướng sang StudentListScreen
    await tester.tap(find.text('Xem danh sách sinh viên'));
    await tester.pumpAndSettle();

    // 4. Kiểm tra màn hình danh sách sinh viên đã xuất hiện
    expect(find.text('Danh sách sinh viên'), findsOneWidget);
    expect(find.text('Nguyễn Văn A'), findsOneWidget);
    expect(find.text('Trần Thị B'), findsOneWidget);

    // 5. Chạm vào 1 sinh viên để vào màn hình chi tiết
    await tester.tap(find.text('Nguyễn Văn A'));
    await tester.pumpAndSettle();

    // 6. Kiểm tra màn hình chi tiết
    expect(find.text('Chi tiết sinh viên'), findsOneWidget);
    expect(find.text('ID: S001'), findsOneWidget);
    expect(find.text('Tên: Nguyễn Văn A'), findsOneWidget);

    // 7. Quay lại danh sách
    await tester.tap(find.text('Quay lại danh sách'));
    await tester.pumpAndSettle();

    // 8. Đã quay về danh sách
    expect(find.text('Danh sách sinh viên'), findsOneWidget);
  });
}
