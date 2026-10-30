import 'package:flutter/material.dart';
import '../models/item.dart';
import '../services/fake_api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Biến lưu trữ Future để tránh bị gọi lại mỗi lần hàm build() chạy lại
  // Đồng thời cho phép reload lại dữ liệu khi nhấn nút Refresh (Bài tập mở rộng 10)
  late Future<List<Item>> _itemsFuture;
  int _delaySeconds = 2;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() {
    setState(() {
      _itemsFuture = FakeApiService.fetchItems(delaySeconds: _delaySeconds);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Async Product Loader'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          // Nút Reload theo Bài tập mở rộng 10
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Tải lại danh sách',
            onPressed: _loadItems,
          ),
          // Menu điều chỉnh thời gian delay để quan sát UX (1s - 5s)
          PopupMenuButton<int>(
            tooltip: 'Chọn thời gian delay',
            icon: const Icon(Icons.timer_outlined),
            onSelected: (seconds) {
              setState(() {
                _delaySeconds = seconds;
              });
              _loadItems();
            },
            itemBuilder: (context) => [1, 2, 3, 5].map((sec) {
              return PopupMenuItem<int>(
                value: sec,
                child: Text('Chờ $sec giây ${_delaySeconds == sec ? '✓' : ''}'),
              );
            }).toList(),
          ),
        ],
      ),
      // BƯỚC 6: GẮN FUTURE VÀO UI BẰNG FutureBuilder
      body: FutureBuilder<List<Item>>(
        future: _itemsFuture,
        builder: (context, snapshot) {
          // BƯỚC 6.6: XỬ LÝ TRẠNG THÁI LOADING (BẮT BUỘC)
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text('Đang tải dữ liệu (${_delaySeconds}s)...'),
                ],
              ),
            );
          }

          // BƯỚC 6.7: XỬ LÝ LỖI FUTURE
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 12),
                  Text(
                    'Có lỗi xảy ra: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _loadItems,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          // BƯỚC 6.8 & 6.9: LẤY DỮ LIỆU & HIỂN THỊ RA UI
          final items = snapshot.data ?? [];
          if (items.isEmpty) {
            return const Center(child: Text('Không có dữ liệu'));
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text('${index + 1}'),
                  ),
                  title: Text(
                    item.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('${item.price.toStringAsFixed(0)} VND'),
                  trailing: const Icon(Icons.shopping_bag_outlined),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
