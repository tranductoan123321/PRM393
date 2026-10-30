import 'dart:async';
import '../models/user_model.dart';

class FakeAuthService {
  Future<void> register(UserModel user) async {
    await Future.delayed(const Duration(seconds: 2));
    if (user.email == "test@error.com") {
      throw Exception("Email already exists");
    }
  }
}
