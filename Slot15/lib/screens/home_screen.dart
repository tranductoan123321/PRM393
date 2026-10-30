import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../services/json_service.dart';
import '../widgets/todo_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Todo> todos = [];
  final TextEditingController controller = TextEditingController();

  void addTodo() {
    if (controller.text.trim().isEmpty) return;
    setState(() {
      todos.add(Todo(title: controller.text.trim()));
    });
    controller.clear();
  }

  void toggleTodo(int index) {
    setState(() {
      todos[index].done = !todos[index].done;
    });
  }

  void exportJson() {
    final jsonData = JsonService.exportTodos(todos);
    // ignore: avoid_print
    print(jsonData);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Exported JSON to console:\n$jsonData"),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo Backup App"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: "Export JSON",
            onPressed: exportJson,
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: "Enter task",
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => addTodo(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: addTodo,
                )
              ],
            ),
          ),
          Expanded(
            child: todos.isEmpty
                ? const Center(
                    child: Text(
                      "No tasks yet. Add one above!",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      final todo = todos[index];
                      return TodoItem(
                        todo: todo,
                        onTap: () => toggleTodo(index),
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }
}
