import 'package:flutter/material.dart';
import 'models/student.dart';
import 'routes/app_routes.dart';
import 'screens/home_screen.dart';
import 'screens/student_list_screen.dart';
import 'screens/student_detail_screen.dart';

void main() {
  runApp(const StudentManagerApp());
}

class StudentManagerApp extends StatelessWidget {
  const StudentManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Manager',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.home,
      // Định nghĩa routes tĩnh
      routes: {
        AppRoutes.home: (context) => const HomeScreen(),
        AppRoutes.studentList: (context) => const StudentListScreen(),
        AppRoutes.studentDetail: (context) => const StudentDetailScreen(),
      },
      // onGenerateRoute: chuẩn bị cho các trường hợp route không có trong routes map
      // hoặc xử lý deep link với query parameters: studentapp://student/detail?id=S001
      onGenerateRoute: (settings) {
        debugPrint('onGenerateRoute được gọi với: ${settings.name}');

        final routeName = settings.name;
        if (routeName != null) {
          final uri = Uri.tryParse(routeName);
          if (uri != null) {
            // Kiểm tra nếu là route chi tiết qua deep link (/detail hoặc /students/detail)
            if (uri.path.endsWith('/detail') || uri.path == '/detail') {
              final studentId = uri.queryParameters['id'] ?? 'Unknown';
              // Tạo Student object tương ứng từ param id
              final student = Student(
                id: studentId,
                name: 'Sinh viên ($studentId)',
                age: 20,
              );
              return MaterialPageRoute(
                builder: (context) => StudentDetailScreen(initialStudent: student),
                settings: RouteSettings(name: settings.name, arguments: student),
              );
            }
          }
        }

        return null; // Trả null để MaterialApp dùng tiếp routes map hoặc onUnknownRoute
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
    );
  }
}
