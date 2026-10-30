import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import '../models/profile_model.dart';

class DatabaseService {
  static const String assetPath = 'database/dataSample.txt';
  static const String localFilePath = 'database/dataSample.txt';

  /// Loads sample profile from database/dataSample.txt
  Future<Profile> loadSampleData() async {
    String raw = '';
    try {
      // 1. Try loading via rootBundle (Flutter assets)
      raw = await rootBundle.loadString(assetPath);
      // ignore: avoid_print
      print("Loaded sample data from Flutter asset: $assetPath");
    } catch (e) {
      // 2. Fallback to direct File read if running on desktop or test
      try {
        final file = File(localFilePath);
        if (await file.exists()) {
          raw = await file.readAsString();
          // ignore: avoid_print
          print("Loaded sample data from local file: $localFilePath");
        } else {
          throw Exception("File $localFilePath not found");
        }
      } catch (fileErr) {
        // ignore: avoid_print
        print("Error reading sample file: $fileErr");
        rethrow;
      }
    }

    final jsonMap = jsonDecode(raw) as Map<String, dynamic>;
    final profile = Profile.fromJson(jsonMap);
    // ignore: avoid_print
    print("Parsed Profile from dataSample.txt: $profile");
    return profile;
  }

  /// Optional: Save updated profile to local file database if supported on current platform
  Future<void> saveSampleData(Profile profile) async {
    try {
      final file = File(localFilePath);
      final jsonString = const JsonEncoder.withIndent('  ').convert(profile.toJson());
      await file.writeAsString(jsonString);
      // ignore: avoid_print
      print("Updated $localFilePath successfully.");
    } catch (e) {
      // ignore: avoid_print
      print("Note: Could not write directly to local file (read-only bundle on mobile/web): $e");
    }
  }
}
