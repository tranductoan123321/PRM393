import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/exceptions.dart';
import '../models/profile_model.dart';

class ApiService {
  // JSONPlaceholder: giả lập user id=1
  final String baseUrl = "https://jsonplaceholder.typicode.com/users/1";

  Future<Profile> fetchProfile() async {
    final uri = Uri.parse(baseUrl);
    // ignore: avoid_print
    print("Calling GET $uri ...");
    final response = await http
        .get(uri)
        .timeout(const Duration(seconds: 10));

    // ignore: avoid_print
    print("GET $uri -> ${response.statusCode}");
    // ignore: avoid_print
    print("Body: ${response.body}");

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final jsonMap = jsonDecode(response.body) as Map<String, dynamic>;
      return Profile.fromJson(jsonMap);
    } else {
      throw ApiException(
        "Failed to load profile (${response.statusCode})",
        statusCode: response.statusCode,
      );
    }
  }

  Future<void> updateProfile(Profile profile) async {
    final uri = Uri.parse(baseUrl);
    // ignore: avoid_print
    print("Calling PUT $uri with body: ${jsonEncode(profile.toJson())}");
    final response = await http
        .put(
          uri,
          body: jsonEncode(profile.toJson()),
          headers: {'Content-Type': 'application/json'},
        )
        .timeout(const Duration(seconds: 10));

    // ignore: avoid_print
    print("PUT $uri -> ${response.statusCode}");
    // ignore: avoid_print
    print("Body: ${response.body}");

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        "Failed to update profile (${response.statusCode})",
        statusCode: response.statusCode,
      );
    }
  }
}
