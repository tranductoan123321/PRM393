import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';
import 'screens/product_grid_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Product Dashboard',
      debugShowCheckedModeBanner: false,
      // route mặc định khi app mở lên
      initialRoute: '/',
      // Định nghĩa named routes
      routes: {
        '/': (context) => const DashboardScreen(),
        '/products': (context) => const ProductGridScreen(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
    );
  }
}
