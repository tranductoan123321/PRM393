import '../models/profile_model.dart';
import '../services/api_service.dart';
import '../services/database_service.dart';

class ProfileRepository {
  final ApiService _api;
  final DatabaseService _databaseService;

  ProfileRepository({
    ApiService? api,
    DatabaseService? databaseService,
  })  : _api = api ?? ApiService(),
        _databaseService = databaseService ?? DatabaseService();

  /// Gets profile from API with graceful fallback to database/dataSample.txt if offline or error
  Future<Profile> getProfile({bool preferApi = true}) async {
    if (!preferApi) {
      return await _databaseService.loadSampleData();
    }
    try {
      return await _api.fetchProfile();
    } catch (e) {
      // ignore: avoid_print
      print("API fetch failed ($e). Falling back to database/dataSample.txt");
      try {
        return await _databaseService.loadSampleData();
      } catch (dbErr) {
        // ignore: avoid_print
        print("Fallback to database/dataSample.txt also failed: $dbErr");
        rethrow;
      }
    }
  }

  /// Explicitly load from database/dataSample.txt
  Future<Profile> getSampleProfile() => _databaseService.loadSampleData();

  /// Updates profile on API and syncs to local sample database
  Future<void> updateProfile(Profile profile) async {
    await _api.updateProfile(profile);
    await _databaseService.saveSampleData(profile);
  }
}
