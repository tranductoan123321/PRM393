import 'dart:async';
import 'package:flutter/material.dart';
import '../models/profile_model.dart';
import '../repositories/profile_repository.dart';
import '../services/draft_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _phoneFocus = FocusNode();

  final _repository = ProfileRepository();
  final _draftService = DraftService();

  bool _loading = false;
  String? _errorText;
  Profile? _originalProfile;
  bool _hasDraft = false;

  // Debounce 400ms để tránh ghi đĩa quá dồn dập
  Timer? _draftDebounce;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap({bool forceFromDatabase = false}) async {
    setState(() {
      _loading = true;
      _errorText = null;
    });

    try {
      if (forceFromDatabase) {
        // Tải trực tiếp từ database/dataSample.txt
        final sampleProfile = await _repository.getSampleProfile();
        _applyProfileToForm(sampleProfile);
        setState(() {
          _originalProfile = sampleProfile;
          _hasDraft = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Đã tải dữ liệu từ database/dataSample.txt"),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        // 1) Ưu tiên draft trước (nếu có)
        final draft = await _draftService.loadDraft();
        if (draft != null) {
          _applyProfileToForm(draft);
          setState(() {
            _hasDraft = true;
          });
          // Lấy API ngầm để gán originalProfile phục vụ dirty check
          try {
            _originalProfile = await _repository.getProfile();
          } catch (_) {
            _originalProfile = draft;
          }
        } else {
          // 2) Không có draft => gọi API (tự fallback về database/dataSample.txt nếu lỗi mạng)
          final profile = await _repository.getProfile();
          _applyProfileToForm(profile);
          setState(() {
            _originalProfile = profile;
            _hasDraft = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        _errorText = "Không tải được dữ liệu. Thử lại.\nChi tiết: $e";
      });
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  void _applyProfileToForm(Profile p) {
    _nameCtrl.text = p.name;
    _emailCtrl.text = p.email;
    _phoneCtrl.text = p.phone;
  }

  Profile _currentProfile() {
    return Profile(
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
    );
  }

  bool get _isDirty {
    if (_originalProfile == null) return false;
    return _originalProfile != _currentProfile();
  }

  // Validation
  String? _validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) return "Không được để trống";
    return null;
  }

  String? _validateEmail(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return "Không được để trống";
    final ok = RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(v);
    if (!ok) return "Email không hợp lệ (ví dụ: a@b.com)";
    return null;
  }

  String? _validatePhone(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return "Không được để trống";
    final ok = RegExp(r'^[0-9+\-\s()]{8,}$').hasMatch(v);
    if (!ok) return "SĐT không hợp lệ (ít nhất 8 ký tự số)";
    return null;
  }

  void _scheduleDraftSave() {
    _draftDebounce?.cancel();
    _draftDebounce = Timer(const Duration(milliseconds: 400), () async {
      try {
        final profile = _currentProfile();
        await _draftService.saveDraft(profile);
        if (mounted) {
          setState(() {
            _hasDraft = true;
          });
        }
      } catch (e) {
        // ignore: avoid_print
        print("Save draft error: $e");
      }
    });
    // Trigger rebuild để cập nhật trạng thái dirty / draft badge
    setState(() {});
  }

  Future<void> _submit() async {
    // 1) Đóng bàn phím
    FocusScope.of(context).unfocus();

    // 2) Validate form
    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) return;

    setState(() {
      _loading = true;
      _errorText = null;
    });

    try {
      final updatedProfile = _currentProfile();
      await _repository.updateProfile(updatedProfile);
      await _draftService.clearDraft();

      setState(() {
        _originalProfile = updatedProfile;
        _hasDraft = false;
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Cập nhật thành công! (Draft đã được xoá)"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() {
        _errorText = "Cập nhật thất bại.\nChi tiết: $e";
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Cập nhật thất bại: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _clearDraftManually() async {
    await _draftService.clearDraft();
    setState(() {
      _hasDraft = false;
    });
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Đã xoá bản nháp (Draft cleared)")),
    );
  }

  Future<bool> _handlePopScope() async {
    if (!_isDirty && !_hasDraft) return true;

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Bạn chưa lưu thay đổi"),
        content: const Text(
          "Bạn có các thay đổi chưa được cập nhật lên máy chủ. Bạn có muốn thoát không?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Ở lại"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Thoát", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  void dispose() {
    _draftDebounce?.cancel();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isDirty && !_hasDraft,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final shouldPop = await _handlePopScope();
        if (shouldPop && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Smart Profile Editor",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          elevation: 2,
          actions: [
            IconButton(
              tooltip: "Tải lại từ API",
              onPressed: _loading ? null : () => _bootstrap(forceFromDatabase: false),
              icon: const Icon(Icons.refresh),
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'load_sample') {
                  _bootstrap(forceFromDatabase: true);
                } else if (value == 'clear_draft') {
                  _clearDraftManually();
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'load_sample',
                  child: Row(
                    children: [
                      Icon(Icons.folder_open, size: 20),
                      SizedBox(width: 8),
                      Text("Tải từ dataSample.txt"),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'clear_draft',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline, size: 20),
                      SizedBox(width: 8),
                      Text("Xoá bản nháp (Draft)"),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        body: SafeArea(
          child: Stack(
            children: [
              if (_errorText != null)
                _ErrorView(
                  message: _errorText!,
                  onRetry: () => _bootstrap(),
                  onLoadSample: () => _bootstrap(forceFromDatabase: true),
                )
              else
                _buildForm(),
              if (_loading)
                Container(
                  color: Colors.black26,
                  child: const Center(
                    child: Card(
                      elevation: 4,
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 12),
                            Text("Đang xử lý..."),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar section
              const Center(
                child: CircleAvatar(
                  radius: 44,
                  backgroundColor: Colors.blueAccent,
                  child: Icon(Icons.person, size: 52, color: Colors.white),
                ),
              ),
              const SizedBox(height: 12),

              // Draft & Dirty status banner
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_hasDraft)
                    Chip(
                      avatar: const Icon(Icons.edit_note, size: 18, color: Colors.deepOrange),
                      label: const Text(
                        "Đang dùng bản nháp (Draft)",
                        style: TextStyle(fontSize: 12, color: Colors.deepOrange),
                      ),
                      backgroundColor: Colors.deepOrange.shade50,
                      side: BorderSide(color: Colors.deepOrange.shade200),
                    )
                  else if (_isDirty)
                    Chip(
                      avatar: const Icon(Icons.change_circle, size: 18, color: Colors.blue),
                      label: const Text(
                        "Có thay đổi chưa lưu",
                        style: TextStyle(fontSize: 12, color: Colors.blue),
                      ),
                      backgroundColor: Colors.blue.shade50,
                      side: BorderSide(color: Colors.blue.shade200),
                    )
                  else
                    Chip(
                      avatar: const Icon(Icons.check_circle_outline, size: 18, color: Colors.green),
                      label: const Text(
                        "Đã đồng bộ với máy chủ",
                        style: TextStyle(fontSize: 12, color: Colors.green),
                      ),
                      backgroundColor: Colors.green.shade50,
                      side: BorderSide(color: Colors.green.shade200),
                    ),
                ],
              ),
              const SizedBox(height: 16),

              // Name Field
              TextFormField(
                controller: _nameCtrl,
                focusNode: _nameFocus,
                decoration: const InputDecoration(
                  labelText: "Họ và tên",
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                  helperText: "Nhập họ tên đầy đủ",
                ),
                textInputAction: TextInputAction.next,
                validator: _validateRequired,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_emailFocus),
                onChanged: (_) => _scheduleDraftSave(),
              ),
              const SizedBox(height: 16),

              // Email Field
              TextFormField(
                controller: _emailCtrl,
                focusNode: _emailFocus,
                decoration: const InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
                  helperText: "Ví dụ: username@example.com",
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: _validateEmail,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_phoneFocus),
                onChanged: (_) => _scheduleDraftSave(),
              ),
              const SizedBox(height: 16),

              // Phone Field
              TextFormField(
                controller: _phoneCtrl,
                focusNode: _phoneFocus,
                decoration: const InputDecoration(
                  labelText: "Số điện thoại",
                  prefixIcon: Icon(Icons.phone_outlined),
                  border: OutlineInputBorder(),
                  helperText: "Tối thiểu 8 ký tự số",
                ),
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                validator: _validatePhone,
                onFieldSubmitted: (_) => _submit(),
                onChanged: (_) => _scheduleDraftSave(),
              ),
              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _loading ? null : _submit,
                  icon: const Icon(Icons.save),
                  label: const Text(
                    "Lưu cập nhật",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Button to test load directly from dataSample.txt
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _loading ? null : () => _bootstrap(forceFromDatabase: true),
                  icon: const Icon(Icons.storage),
                  label: const Text("Tải dữ liệu mẫu từ database/dataSample.txt"),
                ),
              ),
              const SizedBox(height: 16),

              // Hint card
              Card(
                color: Colors.grey.shade100,
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Text(
                        "📌 Hướng dẫn kiểm tra:",
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "• Nhập sai email/phone để thấy validation tức thì.\n"
                        "• Phím Next/Done trên bàn phím nhảy mượt mà.\n"
                        "• Sửa dữ liệu -> Thoát app mở lại -> Vẫn giữ nguyên (Draft).\n"
                        "• Bấm 'Lưu cập nhật' -> Gửi PUT -> Xóa draft.\n"
                        "• Nút 'Tải dữ liệu mẫu' dùng database/dataSample.txt.",
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;
  final Future<void> Function() onLoadSample;

  const _ErrorView({
    required this.message,
    required this.onRetry,
    required this.onLoadSample,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 60),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(color: Colors.red, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => onRetry(),
              icon: const Icon(Icons.refresh),
              label: const Text("Thử lại"),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => onLoadSample(),
              icon: const Icon(Icons.storage),
              label: const Text("Tải từ database/dataSample.txt"),
            ),
          ],
        ),
      ),
    );
  }
}
