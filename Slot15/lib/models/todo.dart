class Todo {
  String title;
  bool done;

  Todo({required this.title, this.done = false});

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'done': done,
    };
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      title: json['title'],
      done: json['done'],
    );
  }
}
