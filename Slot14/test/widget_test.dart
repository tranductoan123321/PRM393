import 'package:flutter_test/flutter_test.dart';
import 'package:smart_task_manager/models/task.dart';

void main() {
  group('Smart Task Manager Unit Tests', () {
    test('Part 1: SharedPreferences Task toJson & fromJson', () {
      final task = Task(
        id: '123',
        title: 'Học SharedPreferences',
        isDone: false,
      );

      final json = task.toJson();
      expect(json['id'], '123');
      expect(json['title'], 'Học SharedPreferences');
      expect(json['isDone'], false);

      final fromJsonTask = Task.fromJson(json);
      expect(fromJsonTask.id, '123');
      expect(fromJsonTask.title, 'Học SharedPreferences');
      expect(fromJsonTask.isDone, false);
    });

    test('Part 2: SQLite Task toMap & fromMap (is_done 0/1)', () {
      final task = Task(
        id: '456',
        title: 'Học SQLite (sqflite)',
        isDone: true,
        createdAt: 1700000000000,
      );

      final map = task.toMap();
      expect(map['id'], '456');
      expect(map['title'], 'Học SQLite (sqflite)');
      expect(map['is_done'], 1);
      expect(map['created_at'], 1700000000000);

      final fromMapTask = Task.fromMap(map);
      expect(fromMapTask.id, '456');
      expect(fromMapTask.title, 'Học SQLite (sqflite)');
      expect(fromMapTask.isDone, true);
      expect(fromMapTask.createdAt, 1700000000000);
    });

    test('Part 3: Hive Task Map serialization', () {
      final task = Task(
        id: '789',
        title: 'Học Hive Persistence',
        isDone: false,
        createdAt: 1700000005000,
      );

      final map = task.toMap();
      final fromMapTask = Task.fromMap(map);
      expect(fromMapTask.id, '789');
      expect(fromMapTask.title, 'Học Hive Persistence');
      expect(fromMapTask.isDone, false);
    });
  });
}
