import 'package:flutter/material.dart';
import '../models/student.dart';
import 'student_form_screen.dart';

class StudentDetailScreen extends StatefulWidget {
  final Student? initialStudent;

  const StudentDetailScreen({super.key, this.initialStudent});

  @override
  State<StudentDetailScreen> createState() => _StudentDetailScreenState();
}

class _StudentDetailScreenState extends State<StudentDetailScreen> {
  Student? _student;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_student == null) {
      if (widget.initialStudent != null) {
        _student = widget.initialStudent;
      } else {
        final args = ModalRoute.of(context)?.settings.arguments;
        if (args is Student) {
          _student = args;
        }
      }
    }
  }

  Future<void> _editStudent() async {
    if (_student == null) return;
    final updated = await Navigator.push<Student?>(
      context,
      MaterialPageRoute(
        builder: (ctx) => StudentFormScreen(student: _student),
      ),
    );

    if (updated != null && mounted) {
      setState(() {
        _student = updated;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_student == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Chi tiết sinh viên'),
        ),
        body: const Center(
          child: Text('Không có dữ liệu sinh viên (arguments null hoặc sai kiểu).'),
        ),
      );
    }

    final student = _student!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết sinh viên'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Chỉnh sửa',
            onPressed: _editStudent,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${student.id}', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Tên: ${student.name}', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('Tuổi: ${student.age}', style: Theme.of(context).textTheme.titleMedium),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Pop để quay lại list (truyền _student về để cập nhật nếu đã chỉnh sửa)
                  Navigator.pop(context, _student);
                },
                child: const Text('Quay lại danh sách'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
