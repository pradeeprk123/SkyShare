import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class CheckInService {
  static const String baseUrl = 'http://10.0.2.2:3000/api/checkin';
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<bool> checkIn(Map<String, dynamic> checkInData, String token) async {
    final String? token = await _storage.read(key: 'jwt_token');
    if (token == null) {
      print("No token found in storage.");
      return false;
    }

    print("Sending check-in data: ${json.encode(checkInData)}");

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(checkInData),
    );

    print("Server response: ${response.body}"); // Debug print

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Failed to check in: ${response.body}');
      return false;
    }
  }
}
