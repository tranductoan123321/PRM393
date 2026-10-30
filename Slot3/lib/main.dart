// ============================================================================
// BÀI TẬP 2: FUNCTION PROCESSOR – HIỂU ĐÚNG FUNCTION TRONG DART (LOGIC CORE)
// ============================================================================

// ----------------------------------------------------------------------------
// PHẦN 1: FUNCTION LÀ "HỘP XỬ LÝ" (Input -> Process -> Output)
// ----------------------------------------------------------------------------
// Input: a, b
// Process: a + b
// Output: int (kết quả trả về qua return)
int calculateTotal(int a, int b) {
  int total = a + b;
  return total;
}

// ----------------------------------------------------------------------------
// PHẦN 2: FUNCTION ≠ UI (Tách biệt logic xử lý & hiển thị)
// ----------------------------------------------------------------------------
// Function chỉ tính toán logic và return giá trị.
// Không viết lệnh print() hay UI trong function.
double calculateAverage(int a, int b) {
  return (a + b) / 2;
}

// ----------------------------------------------------------------------------
// PHẦN 3: CALLBACK – FUNCTION LÀ DỮ LIỆU
// ----------------------------------------------------------------------------
// Callback = function được truyền vào như tham số
void processNumber(int number, void Function(int) callback) {
  callback(number);
}

// Function dùng làm callback có tên
void printNumber(int value) {
  print("Value is: $value");
}

// ----------------------------------------------------------------------------
// PHẦN 4: ANONYMOUS FUNCTION (Hàm ẩn danh - Đọc hiểu code Flutter)
// ----------------------------------------------------------------------------
// Tương tự cú pháp onPressed: () { ... } trong Flutter
void process(int number, void Function(int) callback) {
  callback(number);
}

// ----------------------------------------------------------------------------
// BÀI TẬP TỔNG HỢP: Function Processor
// ----------------------------------------------------------------------------
String formatGreeting(String name) {
  return "Xin chào, $name!";
}

void transformAndNotify(int input, int Function(int) transform, void Function(int) onDone) {
  int result = transform(input); // Xử lý biến đổi dữ liệu
  onDone(result);                 // Trả kết quả qua callback
}

// ----------------------------------------------------------------------------
// MAIN: Điểm khởi đầu chương trình & hiển thị kết quả (UI console)
// ----------------------------------------------------------------------------
void main() {
  print("=== PHẦN 1: Function là hộp xử lý ===");
  int total = calculateTotal(5, 7);
  print(total); // Kết quả: 12

  print("\n=== PHẦN 2: Tách biệt Logic & Hiển thị ===");
  double avg = calculateAverage(6, 8);
  print("Average: $avg"); // Kết quả: Average: 7.0

  print("\n=== PHẦN 3: Callback (Truyền function như tham số) ===");
  processNumber(10, printNumber); // Kết quả: Value is: 10

  print("\n=== PHẦN 4: Anonymous Function (Hàm ẩn danh) ===");
  process(5, (value) {
    print("Anonymous value: $value"); // Kết quả: Anonymous value: 5
  });

  print("\n=== BÀI TẬP TỔNG HỢP: Function Processor ===");
  // 1. Xử lý chuỗi
  String greeting = formatGreeting("Sinh viên Flutter");
  print(greeting);

  // 2. Xử lý số với anonymous callback
  transformAndNotify(
    4,
    (x) => x * x, // Bình phương: 4 * 4 = 16
    (res) {
      print("[Callback] Kết quả tính toán: $res");
    },
  );
}
