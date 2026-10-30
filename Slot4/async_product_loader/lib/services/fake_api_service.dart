import '../models/item.dart';

class FakeApiService {
  static Future<List<Item>> fetchItems({int delaySeconds = 2, bool simulateError = false}) async {
    // ignore: avoid_print
    print(' 1. BẮT ĐẦU gọi fetchItems');
    await Future.delayed(Duration(seconds: delaySeconds));
    // ignore: avoid_print
    print(' 2. SAU khi Future.delayed xong');

    if (simulateError) {
      throw Exception('Lỗi kết nối máy chủ!');
    }

    return [
      Item(name: 'Táo', price: 10000),
      Item(name: 'Cam', price: 15000),
      Item(name: 'Chuối', price: 8000),
    ];
  }
}
