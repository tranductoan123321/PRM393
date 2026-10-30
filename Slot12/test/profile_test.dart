import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_profile_editor/models/profile_model.dart';
import 'package:smart_profile_editor/services/api_service.dart';
import 'package:smart_profile_editor/services/database_service.dart';
import 'package:smart_profile_editor/services/draft_service.dart';
import 'package:smart_profile_editor/repositories/profile_repository.dart';

// Mock ApiService for Repository Testing
class MockApiService extends ApiService {
  Profile? mockProfile;
  bool shouldThrow = false;

  MockApiService({this.mockProfile, this.shouldThrow = false});

  @override
  Future<Profile> fetchProfile() async {
    if (shouldThrow) {
      throw Exception("Network failure");
    }
    return mockProfile ??
        const Profile(
          name: "Mock User",
          email: "mock@example.com",
          phone: "0123456789",
        );
  }

  @override
  Future<void> updateProfile(Profile profile) async {
    if (shouldThrow) {
      throw Exception("Update failure");
    }
    mockProfile = profile;
  }
}

// Mock DatabaseService for Repository Testing
class MockDatabaseService extends DatabaseService {
  @override
  Future<Profile> loadSampleData() async {
    return const Profile(
      name: "Leanne Graham",
      email: "Sincere@april.biz",
      phone: "0987654321",
    );
  }

  @override
  Future<void> saveSampleData(Profile profile) async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('20.1 Profile Model Tests', () {
    test('fromJson and toJson should serialize properly', () {
      final json = {
        'name': 'Nguyen Van A',
        'email': 'a@fpt.edu.vn',
        'phone': '0901234567',
      };

      final profile = Profile.fromJson(json);

      expect(profile.name, 'Nguyen Van A');
      expect(profile.email, 'a@fpt.edu.vn');
      expect(profile.phone, '0901234567');

      final serialized = profile.toJson();
      expect(serialized, json);
    });

    test('copyWith creates new instance with updated values', () {
      const original = Profile(
        name: 'Nguyen Van A',
        email: 'a@fpt.edu.vn',
        phone: '0901234567',
      );

      final updated = original.copyWith(name: 'Tran Thi B');
      expect(updated.name, 'Tran Thi B');
      expect(updated.email, 'a@fpt.edu.vn');
      expect(updated.phone, '0901234567');
    });

    test('equality and hashCode comparison for dirty check', () {
      const p1 = Profile(name: 'A', email: 'a@b.com', phone: '12345678');
      const p2 = Profile(name: 'A', email: 'a@b.com', phone: '12345678');
      const p3 = Profile(name: 'A', email: 'other@b.com', phone: '12345678');

      expect(p1 == p2, isTrue);
      expect(p1.hashCode == p2.hashCode, isTrue);
      expect(p1 == p3, isFalse);
    });
  });

  group('20.2 DraftService Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('saveDraft and loadDraft work correctly', () async {
      final draftService = DraftService();
      const profile = Profile(
        name: 'Draft User',
        email: 'draft@fpt.edu.vn',
        phone: '0988888888',
      );

      // Initially null
      final initialDraft = await draftService.loadDraft();
      expect(initialDraft, isNull);

      // Save and reload
      await draftService.saveDraft(profile);
      final loadedDraft = await draftService.loadDraft();
      expect(loadedDraft, isNotNull);
      expect(loadedDraft!.name, 'Draft User');
      expect(loadedDraft.email, 'draft@fpt.edu.vn');
      expect(loadedDraft.phone, '0988888888');

      // Clear draft
      await draftService.clearDraft();
      final afterClear = await draftService.loadDraft();
      expect(afterClear, isNull);
    });
  });

  group('20.3 ProfileRepository Tests with database/dataSample.txt fallback', () {
    test('getProfile returns API profile when network succeeds', () async {
      final repo = ProfileRepository(
        api: MockApiService(
          mockProfile: const Profile(
            name: 'API User',
            email: 'api@example.com',
            phone: '111222333',
          ),
        ),
        databaseService: MockDatabaseService(),
      );

      final result = await repo.getProfile();
      expect(result.name, 'API User');
      expect(result.email, 'api@example.com');
    });

    test('getProfile falls back to database/dataSample.txt when API throws error', () async {
      final repo = ProfileRepository(
        api: MockApiService(shouldThrow: true),
        databaseService: MockDatabaseService(),
      );

      final result = await repo.getProfile();
      expect(result.name, 'Leanne Graham');
      expect(result.email, 'Sincere@april.biz');
      expect(result.phone, '0987654321');
    });

    test('getSampleProfile directly retrieves from sample database', () async {
      final repo = ProfileRepository(
        api: MockApiService(),
        databaseService: MockDatabaseService(),
      );

      final result = await repo.getSampleProfile();
      expect(result.name, 'Leanne Graham');
    });
  });
}
