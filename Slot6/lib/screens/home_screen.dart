import 'package:flutter/material.dart';
import '../models/student.dart';
import '../widgets/student_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // BƯỚC 3: Chuẩn bị danh sách sinh viên mẫu
  final List<Student> students = [
    Student(id: 'SV01', name: 'Nguyễn Văn A'),
    Student(id: 'SV02', name: 'Trần Thị B'),
    Student(id: 'SV03', name: 'Lê Văn C'),
    Student(id: 'SV04', name: 'Phạm Văn D'),
    Student(id: 'SV05', name: 'Hoàng Thị E'),
  ];

  @override
  Widget build(BuildContext context) {
    // BƯỚC 4: Tạo Home Screen với Scaffold
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student List'),
        centerTitle: true,
      ),
      // BƯỚC 5: Xây dựng ListView.builder
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          final student = students[index];
          // BƯỚC 7: Kết nối StudentCard vào ListView
          return StudentCard(
            student: student,
            onTap: () {
              // BƯỚC 9: Xử lý setState cho UI
              setState(() {
                student.isSelected = !student.isSelected;
              });
            },
          );
        },
      ),
    );
  }
}
