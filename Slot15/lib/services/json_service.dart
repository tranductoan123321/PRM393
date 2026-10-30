import 'dart:convert';
import '../models/todo.dart';

class JsonService {
  static String exportTodos(List<Todo> todos) {
    final list = todos.map((e) => e.toJson()).toList();
    return jsonEncode(list);
  }
}
