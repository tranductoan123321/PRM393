import 'package:flutter/material.dart';
import '../models/student.dart';

class StudentFormScreen extends StatefulWidget {
  final Student? student;

  const StudentFormScreen({super.key, this.student});

  @override
  State<StudentFormScreen> createState() => _StudentFormScreenState();
}

class _StudentFormScreenState extends State<StudentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _idController;
  late final TextEditingController _nameController;
  late final TextEditingController _ageController;

  bool get _isEditing => widget.student != null;

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController(text: widget.student?.id ?? '');
    _nameController = TextEditingController(text: widget.student?.name ?? '');
    _ageController = TextEditingController(
      text: widget.student != null ? widget.student!.age.toString() : '',
    );
  }

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _saveStudent() {
    // Kiểm tra tính hợp lệ của form
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    final id = _idController.text.trim();
    final name = _nameController.text.trim();
    final age = int.tryParse(_ageController.text.trim()) ?? 0;
    final studentData = Student(id: id, name: name, age: age);

    // Pop và trả kết quả studentData về cho màn hình trước
    Navigator.pop(context, studentData);
  }

  Future<bool> _onWillPop() async {
    // Nếu có dữ liệu đã nhập mà chưa lưu, hỏi xác nhận
    final hasData = _idController.text.isNotEmpty ||
        _nameController.text.isNotEmpty ||
        _ageController.text.isNotEmpty;

    if (!hasData) return true;

    final shouldLeave = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận'),
        content: const Text('Bạn có chắc muốn hủy thay đổi không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Ở lại'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hủy'),
          ),
        ],
      ),
    );

    return shouldLeave ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop && context.mounted) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isEditing ? 'Chỉnh sửa sinh viên' : 'Thêm sinh viên'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _idController,
                  readOnly: _isEditing,
                  decoration: InputDecoration(
                    labelText: 'Mã sinh viên',
                    helperText: _isEditing ? 'Mã sinh viên không thể thay đổi' : null,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Vui lòng nhập mã sinh viên';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Họ tên',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Vui lòng nhập họ tên';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _ageController,
                  decoration: const InputDecoration(
                    labelText: 'Tuổi',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    final text = value?.trim() ?? '';
                    final age = int.tryParse(text);
                    if (text.isEmpty) {
                      return 'Vui lòng nhập tuổi';
                    }
                    if (age == null || age <= 0) {
                      return 'Tuổi không hợp lệ';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _saveStudent,
                      child: const Text('Lưu'),
                    ),
                    OutlinedButton(
                      onPressed: () async {
                        final shouldPop = await _onWillPop();
                        if (shouldPop && context.mounted) {
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Hủy'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
