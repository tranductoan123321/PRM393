import 'package:flutter/material.dart';
import '../part1_shared_preferences/screens/home_screen.dart' as part1;
import '../part2_sqlite/screens/home_screen.dart' as part2;
import '../part3_hive/screens/home_screen.dart' as part3;
import '../part4_drift/screens/home_screen.dart' as part4;

class MainMasterScreen extends StatefulWidget {
  const MainMasterScreen({super.key});

  @override
  State<MainMasterScreen> createState() => _MainMasterScreenState();
}

class _MainMasterScreenState extends State<MainMasterScreen> {
  int _currentIndex = 0;

  final List<_EngineInfo> _engines = [
    _EngineInfo(
      title: 'Phần 1: SharedPreferences',
      shortName: 'SharedPreferences',
      badge: 'Key-Value (JSON)',
      color: Colors.green,
      icon: Icons.flash_on_outlined,
      description:
          'Lưu trữ dạng Key-Value XML/plist. Thích hợp cho config nhỏ, settings. Cần serialize List<Task> sang chuỗi JSON string.',
    ),
    _EngineInfo(
      title: 'Phần 2: SQLite (sqflite)',
      shortName: 'SQLite',
      badge: 'Relational DB (SQL)',
      color: Colors.blue,
      icon: Icons.storage_outlined,
      description:
          'Hệ quản trị CSDL quan hệ nhúng file .db. Dùng câu lệnh SQL, bảng tasks có id, title, is_done (0/1), created_at. Query và filter mạnh mẽ.',
    ),
    _EngineInfo(
      title: 'Phần 3: Hive',
      shortName: 'Hive',
      badge: 'NoSQL Box',
      color: Colors.deepOrange,
      icon: Icons.inventory_2_outlined,
      description:
          'NoSQL key-value database thuần Dart cực nhanh. Dùng Box ("tủ dữ liệu"), không cần SQL, lưu trực tiếp Map hoặc TypeAdapter.',
    ),
    _EngineInfo(
      title: 'Phần 4: Drift (SQLite ORM)',
      shortName: 'Drift ORM',
      badge: 'Type-Safe ORM',
      color: Colors.teal,
      icon: Icons.code_outlined,
      description:
          'ORM cho SQLite viết hoàn toàn bằng code Dart type-safe. Sử dụng build_runner sinh mã, tự động kiểm tra cú pháp và hỗ trợ reactive Stream.',
    ),
  ];

  void _showInfoDialog(BuildContext context) {
    final current = _engines[_currentIndex];
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(current.icon, color: current.color),
            const SizedBox(width: 8),
            Text(current.shortName),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: current.color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                current.badge,
                style: TextStyle(
                  color: current.color,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(current.description, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 16),
            const Divider(),
            const Text(
              '🎯 Cách kiểm tra Persistence:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              '1. Thêm một vài task, tick hoàn thành.\n'
              '2. Đóng hẳn ứng dụng hoặc Hot Restart.\n'
              '3. Mở lại ứng dụng: dữ liệu vẫn còn nguyên vẹn!',
              style: TextStyle(fontSize: 13, height: 1.4),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Đã hiểu'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final current = _engines[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Smart Task Manager',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            Text(
              current.title,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        backgroundColor: current.color.withValues(alpha: 0.12),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'Thông tin công nghệ',
            onPressed: () => _showInfoDialog(context),
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          part1.HomeScreen(showAppBar: false),
          part2.HomeScreen(showAppBar: false),
          part3.HomeScreen(showAppBar: false),
          part4.HomeScreen(showAppBar: false),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) {
          setState(() {
            _currentIndex = idx;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.flash_on_outlined),
            selectedIcon: Icon(Icons.flash_on, color: Colors.green),
            label: '1. Prefs',
          ),
          NavigationDestination(
            icon: Icon(Icons.storage_outlined),
            selectedIcon: Icon(Icons.storage, color: Colors.blue),
            label: '2. SQLite',
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2, color: Colors.deepOrange),
            label: '3. Hive',
          ),
          NavigationDestination(
            icon: Icon(Icons.code_outlined),
            selectedIcon: Icon(Icons.code, color: Colors.teal),
            label: '4. Drift',
          ),
        ],
      ),
    );
  }
}

class _EngineInfo {
  final String title;
  final String shortName;
  final String badge;
  final Color color;
  final IconData icon;
  final String description;

  _EngineInfo({
    required this.title,
    required this.shortName,
    required this.badge,
    required this.color,
    required this.icon,
    required this.description,
  });
}
