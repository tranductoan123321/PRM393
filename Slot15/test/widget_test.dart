import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_backup_app/main.dart';
import 'package:todo_backup_app/models/todo.dart';
import 'package:todo_backup_app/services/json_service.dart';

void main() {
  test('JsonService exports todos correctly', () {
    final todos = [
      Todo(title: 'Buy milk', done: false),
      Todo(title: 'Study Flutter', done: true),
    ];

    final jsonStr = JsonService.exportTodos(todos);
    expect(
      jsonStr,
      '[{"title":"Buy milk","done":false},{"title":"Study Flutter","done":true}]',
    );
  });

  testWidgets('Add and toggle todo test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('No tasks yet. Add one above!'), findsOneWidget);

    // Enter text and add task
    await tester.enterText(find.byType(TextField), 'Buy milk');
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text('Buy milk'), findsOneWidget);

    // Tap task to toggle done
    await tester.tap(find.text('Buy milk'));
    await tester.pump();

    // Verify Save icon exists
    expect(find.byIcon(Icons.save), findsOneWidget);
    await tester.tap(find.byIcon(Icons.save));
    await tester.pump();
  });
}
