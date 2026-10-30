import 'package:flutter/material.dart';
import '../services/stream_service.dart';

/// [HomeScreen] đại diện cho tầng Giao diện (Presentation Layer).
/// 
/// 📌 NGUYÊN TẮC QUAN TRỌNG:
/// 1. UI KHÔNG tạo ra dữ liệu.
/// 2. UI KHÔNG dùng setState() để tăng counter.
/// 3. UI tự động cập nhật (rebuild) nhờ lắng nghe dữ liệu từ [StreamBuilder].
/// 4. Quản lý vòng đời (Lifecycle): Phải gọi [dispose()] để đóng Stream tránh Memory Leak.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final StreamService _streamService;
  
  // Danh sách lưu lại các log sự kiện để sinh viên quan sát trực tiếp trên màn hình
  final List<String> _eventLogs = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Khởi tạo StreamService
    _streamService = StreamService();

    // Bước 3 trong bài học: Lắng nghe Stream ở tầng Service/Debug độc lập với UI
    _streamService.stream.listen(
      (data) {
        // Log ra Console (Terminal)
        debugPrint('[Stream Event Emit]: $data');
      },
      onError: (err) {
        debugPrint('[Stream Event Error]: $err');
      },
    );

    // Bắt đầu phát dữ liệu
    _streamService.start();
  }

  void _addLog(String msg) {
    setState(() {
      _eventLogs.insert(0, '${DateTime.now().toIso8601String().substring(11, 19)}: $msg');
      if (_eventLogs.length > 30) {
        _eventLogs.removeLast();
      }
    });
  }

  @override
  void dispose() {
    // Bước 8: Đóng Stream khi Widget bị hủy để giải phóng bộ nhớ (Tránh rò rỉ - Memory Leak)
    _streamService.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Counter Stream App'),
        centerTitle: true,
        elevation: 2,
        backgroundColor: theme.colorScheme.primaryContainer,
        foregroundColor: theme.colorScheme.onPrimaryContainer,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Card giới thiệu kiến thức
            Card(
              elevation: 0,
              color: theme.colorScheme.surfaceContainerHighest.withAlpha(128),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: theme.colorScheme.outlineVariant),
              ),
              child: const Padding(
                padding: EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '💡 UI REACTIVE & STREAMBUILDER',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    SizedBox(height: 6),
                    Text(
                      '• UI cập nhật hoàn toàn tự động mỗi khi Stream phát ra giá trị mới.\n'
                      '• Tuyệt đối KHÔNG gọi setState() để tăng counter.\n'
                      '• Chỉ khối bên trong StreamBuilder rebuild, các widget khác giữ nguyên.',
                      style: TextStyle(fontSize: 13, height: 1.4),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // KHU VỰC STREAM BUILDER (CỐT LÕI BÀI HỌC)
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary.withAlpha(18),
                      theme.colorScheme.secondary.withAlpha(18),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    const Text(
                      'GIÁ TRỊ COUNTER REALTIME',
                      style: TextStyle(
                        fontSize: 14,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 🎯 BƯỚC 5 & 6: KẾT NỐI STREAM VỚI UI BẰNG STREAMBUILDER
                    StreamBuilder<int>(
                      stream: _streamService.stream,
                      builder: (context, snapshot) {
                        // 1. Quan sát UI rebuild (Bước 6)
                        debugPrint('🔄 UI rebuild: ${snapshot.data}');

                        // 2. Trạng thái Đang chờ (Loading / Waiting)
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 12),
                              Text(
                                'Đang đợi dữ liệu từ Stream...',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          );
                        }

                        // 3. Trạng thái Có lỗi (Error)
                        if (snapshot.hasError) {
                          return Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.red.shade200),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.error_outline, color: Colors.red, size: 36),
                                const SizedBox(height: 8),
                                Text(
                                  'Lỗi: ${snapshot.error}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    _streamService.reset();
                                    _streamService.start();
                                    _addLog('Khôi phục sau lỗi và đếm lại');
                                  },
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('Khôi phục & Đếm lại'),
                                )
                              ],
                            ),
                          );
                        }

                        // 4. Trạng thái Không có dữ liệu (No Data)
                        if (!snapshot.hasData) {
                          return const Text(
                            'Chưa có dữ liệu (No data)',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          );
                        }

                        // 5. Trạng thái Bình thường (Has Data) -> Hiển thị Counter
                        final counterValue = snapshot.data!;
                        return Column(
                          children: [
                            Text(
                              '$counterValue',
                              style: TextStyle(
                                fontSize: 64,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Chip(
                              avatar: const Icon(Icons.radio_button_checked, size: 16, color: Colors.green),
                              label: Text('ConnectionState: ${snapshot.connectionState.name}'),
                              backgroundColor: Colors.green.shade50,
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // KHU VỰC ĐIỀU KHIỂN & BÀI TẬP MỞ RỘNG
            const Text(
              '🎮 BẢNG ĐIỀU KHIỂN LUỒNG DỮ LIỆU',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Các nút Start / Pause / Resume / Reset
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    _streamService.resume();
                    _addLog('Gọi StreamService.resume() / start()');
                  },
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Start / Resume'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _streamService.pause();
                    _addLog('Gọi StreamService.pause()');
                  },
                  icon: const Icon(Icons.pause),
                  label: const Text('Pause'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _streamService.reset();
                    _addLog('Gọi StreamService.reset()');
                  },
                  icon: const Icon(Icons.restart_alt),
                  label: const Text('Reset'),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    _streamService.simulateError();
                    _addLog('Mô phỏng lỗi: streamService.simulateError()');
                  },
                  icon: const Icon(Icons.warning_amber_rounded, color: Colors.red),
                  label: const Text('Bắn lỗi vào Stream', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Tùy chỉnh tốc độ phát (Bài tập mở rộng)
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '⏱️ Thay đổi chu kỳ phát Stream (Tốc độ):',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    SegmentedButton<int>(
                      segments: const [
                        ButtonSegment(value: 2000, label: Text('2s (Chậm)')),
                        ButtonSegment(value: 1000, label: Text('1s (Chuẩn)')),
                        ButtonSegment(value: 300, label: Text('0.3s (Nhanh)')),
                      ],
                      selected: {_streamService.intervalMilliseconds},
                      onSelectionChanged: (newSelection) {
                        setState(() {
                          _streamService.setSpeed(newSelection.first);
                          _addLog('Đổi tốc độ phát: ${newSelection.first}ms');
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // KHU VỰC NHẬT KÝ SỰ KIỆN (EVENT LOG)
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '📜 Nhật ký sự kiện (UI Logs):',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _eventLogs.clear();
                            });
                          },
                          child: const Text('Xóa log', style: TextStyle(fontSize: 12)),
                        )
                      ],
                    ),
                    Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: _eventLogs.isEmpty
                          ? const Center(
                              child: Text(
                                'Các sự kiện tương tác sẽ hiển thị ở đây...',
                                style: TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                            )
                          : ListView.builder(
                              itemCount: _eventLogs.length,
                              itemBuilder: (context, index) {
                                return Text(
                                  _eventLogs[index],
                                  style: const TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 11,
                                    color: Colors.black87,
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
