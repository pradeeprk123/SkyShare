// profilesetup_service.dart
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ProfileSetupService {
  static const String baseUrl = 'http://10.0.2.2:3000/api/profile';
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<bool> submitProfileData(Map<String, dynamic> profileData) async {
    final String? token = await _storage.read(key: 'jwt_token');
    if (token == null) return false;

    final response = await http.put(
      Uri.parse('$baseUrl/update'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'profileData': profileData}), // Wrap profile data
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      // Print the error message for debugging purposes
      print('Failed to update profile: ${response.body}');
      return false;
    }
  }
}
