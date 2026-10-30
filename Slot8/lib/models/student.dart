class Student {
  final String id;
  final String name;
  final int age;

  Student({
    required this.id,
    required this.name,
    required this.age,
  });

  // Optional: tiện cho debug / log
  @override
  String toString() {
    return 'Student(id: $id, name: $name, age: $age)';
  }

  // Copy with để dễ chỉnh sửa (edit student)
  Student copyWith({
    String? id,
    String? name,
    int? age,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
    );
  }
}
