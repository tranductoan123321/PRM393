import 'dart:async';

/// [StreamService] đóng vai trò là Data Source / Business Logic.
/// Nơi đây chịu trách nhiệm tạo dữ liệu, kiểm soát luồng và phát dữ liệu qua Stream.
/// 
/// 📌 NGUYÊN TẮC:
/// - UI KHÔNG tạo dữ liệu
/// - UI KHÔNG chứa logic đếm hoặc Timer
class StreamService {
  // Dùng broadcast() để cho phép UI rebuild hoặc nhiều nơi cùng lắng nghe mà không bị lỗi:
  // "Bad state: Stream has already been listened to"
  final StreamController<int> _controller = StreamController<int>.broadcast();
  
  Timer? _timer;
  int _counter = 0;
  bool _isRunning = false;
  int _intervalMilliseconds = 1000;

  /// Stream công khai để UI (HomeScreen / StreamBuilder) lắng nghe
  Stream<int> get stream => _controller.stream;

  /// Trạng thái hiện tại
  int get currentCount => _counter;
  bool get isRunning => _isRunning;
  int get intervalMilliseconds => _intervalMilliseconds;

  /// Khởi động phát dữ liệu mỗi chu kỳ (mặc định 1 giây)
  void start() {
    if (_isRunning) return;
    _isRunning = true;
    _timer?.cancel();
    _timer = Timer.periodic(Duration(milliseconds: _intervalMilliseconds), (timer) {
      _counter++;
      // Kiểm tra nếu controller chưa bị đóng thì mới phát dữ liệu
      if (!_controller.isClosed) {
        _controller.add(_counter);
      }
    });
  }

  /// Tạm dừng Stream (Bài tập mở rộng)
  void pause() {
    _timer?.cancel();
    _isRunning = false;
  }

  /// Tiếp tục Stream (Bài tập mở rộng)
  void resume() {
    start();
  }

  /// Đặt lại giá trị Counter về 0
  void reset() {
    _counter = 0;
    if (!_controller.isClosed) {
      _controller.add(_counter);
    }
  }

  /// Thay đổi tốc độ phát dữ liệu (500ms, 1000ms, 2000ms, ...)
  void setSpeed(int milliseconds) {
    _intervalMilliseconds = milliseconds;
    if (_isRunning) {
      pause();
      start();
    }
  }

  /// Mô phỏng bắn lỗi (Error) vào Stream để kiểm thử trạng thái snapshot.hasError
  void simulateError() {
    if (!_controller.isClosed) {
      _controller.addError('Lỗi mô phỏng: Kết nối luồng dữ liệu gián đoạn!');
    }
  }

  /// Hủy tài nguyên khi không còn sử dụng để tránh Memory Leak
  void dispose() {
    _timer?.cancel();
    _controller.close();
  }
}
