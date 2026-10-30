import 'package:flutter/material.dart';
import '../widgets/dashboard_header.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Phần header (row + stack)
          const DashboardHeader(),
          // Khoảng cách nhỏ
          const SizedBox(height: 16),
          // Phần nội dung chính chiếm toàn bộ không gian còn lại
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Welcome to Simple Product Dashboard',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Điều hướng đến màn hình Grid qua named route
                      Navigator.pushNamed(context, '/products');
                    },
                    child: const Text('Xem danh sách sản phẩm'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
