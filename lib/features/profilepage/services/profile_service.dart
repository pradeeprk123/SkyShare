import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfileService {
  static const String baseUrl =
      'http://10.0.2.2:3000/api'; // Adjust URL as needed
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<Map<String, dynamic>> fetchUserData(String email) async {
    final String? token = await _storage.read(key: 'jwt_token');
    if (token == null) throw Exception("Token not found");

    final url = Uri.parse('$baseUrl/profile/$email');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load user data: ${response.body}');
    }
  }
}
