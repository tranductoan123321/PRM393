import 'package:flutter_test/flutter_test.dart';
import 'package:smart_registration_app/utils/validators.dart';
import 'package:smart_registration_app/models/user_model.dart';
import 'package:smart_registration_app/services/fake_auth_service.dart';

void main() {
  group('Validators Test', () {
    test('Required validator tests', () {
      expect(Validators.required(null), "Field is required");
      expect(Validators.required(""), "Field is required");
      expect(Validators.required("   "), "Field is required");
      expect(Validators.required("John Doe"), isNull);
    });

    test('Email validator tests', () {
      expect(Validators.email(null), "Email required");
      expect(Validators.email(""), "Email required");
      expect(Validators.email("invalid-email"), "Invalid email format");
      expect(Validators.email("user@"), "Invalid email format");
      expect(Validators.email("valid.user@example.com"), isNull);
    });

    test('Password validator tests', () {
      expect(Validators.password(null), "Password must be at least 6 characters");
      expect(Validators.password("12345"), "Password must be at least 6 characters");
      expect(Validators.password("123456"), isNull);
      expect(Validators.password("securePassword123"), isNull);
    });
  });

  group('FakeAuthService Test', () {
    test('Successful registration', () async {
      final service = FakeAuthService();
      final user = UserModel(
        name: "Test User",
        email: "user@example.com",
        password: "password123",
      );
      await expectLater(service.register(user), completes);
    });

    test('Failed registration for test@error.com', () async {
      final service = FakeAuthService();
      final user = UserModel(
        name: "Test User",
        email: "test@error.com",
        password: "password123",
      );
      expect(
        () => service.register(user),
        throwsA(isA<Exception>().having((e) => e.toString(), 'message', contains("Email already exists"))),
      );
    });
  });
}
