import 'package:flutter/material.dart';
import '../models/student.dart';
import '../widgets/student_tile.dart';
import '../routes/app_routes.dart';
import 'student_form_screen.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  // Danh sách sinh viên giả lập (trong bộ nhớ)
  final List<Student> _students = [
    Student(id: 'S001', name: 'Nguyễn Văn A', age: 20),
    Student(id: 'S002', name: 'Trần Thị B', age: 21),
    Student(id: 'S003', name: 'Lê Văn C', age: 19),
  ];

  Future<void> _goToDetail(Student student) async {
    // Navigator 1.0 + Named Route + arguments
    final result = await Navigator.pushNamed(
      context,
      AppRoutes.studentDetail,
      arguments: student,
    );

    // Khi màn hình chi tiết pop về, nếu có cập nhật thì làm mới danh sách
    if (result is Student && mounted) {
      setState(() {
        final index = _students.indexWhere((s) => s.id == result.id);
        if (index != -1) {
          _students[index] = result;
        }
      });
    }
  }

  Future<void> _goToForm() async {
    // Mở form để tạo mới
    // Ở đây dùng push (không named) để sinh viên thấy sự khác nhau
    final result = await Navigator.push<Student?>(
      context,
      MaterialPageRoute(
        builder: (ctx) => const StudentFormScreen(),
      ),
    );

    // Khi form pop về, nếu có student mới thì thêm vào list
    if (result != null && mounted) {
      setState(() {
        _students.add(result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách sinh viên'),
      ),
      body: _students.isEmpty
          ? const Center(child: Text('Chưa có sinh viên nào.'))
          : ListView.builder(
              itemCount: _students.length,
              itemBuilder: (context, index) {
                final student = _students[index];
                return StudentTile(
                  student: student,
                  onTap: () => _goToDetail(student),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToForm,
        child: const Icon(Icons.add),
      ),
    );
  }
}
