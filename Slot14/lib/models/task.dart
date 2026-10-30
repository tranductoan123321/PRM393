class Task {
  final String id;
  String title;
  bool isDone;
  final int createdAt;

  Task({
    required this.id,
    required this.title,
    this.isDone = false,
    int? createdAt,
  }) : createdAt = createdAt ?? DateTime.now().millisecondsSinceEpoch;

  /// JSON serialization (SharedPreferences - Phần 1)
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'isDone': isDone,
        'createdAt': createdAt,
      };

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json['id'] as String,
        title: json['title'] as String,
        isDone: (json['isDone'] as bool?) ?? false,
        createdAt: (json['createdAt'] as int?) ?? 0,
      );

  /// Map serialization (SQLite sqflite - Phần 2 & Hive - Phần 3)
  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'is_done': isDone ? 1 : 0,
        'isDone': isDone,
        'created_at': createdAt,
        'createdAt': createdAt,
      };

  factory Task.fromMap(Map map) => Task(
        id: map['id'] as String,
        title: map['title'] as String,
        isDone: (map['is_done'] == 1 || map['isDone'] == true),
        createdAt: (map['created_at'] ?? map['createdAt'] as int?) ?? 0,
      );
}
