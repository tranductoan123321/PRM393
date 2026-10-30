import 'package:flutter_test/flutter_test.dart';
import 'package:slot3/main.dart';

void main() {
  test('Kiểm tra calculateTotal (Input -> Process -> Output)', () {
    expect(calculateTotal(5, 7), 12);
  });

  test('Kiểm tra calculateAverage (Function chỉ return, không in UI)', () {
    expect(calculateAverage(6, 8), 7.0);
  });

  test('Kiểm tra Callback và Anonymous Function', () {
    int receivedValue = 0;
    processNumber(10, (val) {
      receivedValue = val;
    });
    expect(receivedValue, 10);
  });
}
