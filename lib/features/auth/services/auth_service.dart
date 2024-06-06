import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final _storage = FlutterSecureStorage();
  static const String baseUrl =
      'http://10.0.2.2:3000'; // Use your API's base URL.

  Future<void> signUp(String email, String password) async {
    final url = Uri.parse('$baseUrl/api/auth/signup');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to sign up. ${json.decode(response.body)['message']}');
    }
    // You can also process the response further if needed.
  }

  Future<void> signIn(String email, String password) async {
    final url = Uri.parse('$baseUrl/api/auth/signin');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      // Assuming the token is returned in the response body under 'token'
      final String token = responseData['token'];
      // After receiving the token from the server response, store it securely
      print("Received token: $token");
      await _storage.write(key: 'jwt_token', value: token);
      await _storage.write(key: 'user_email', value: email);
    } else {
      final error = json.decode(response.body)['message'];
      print("Failed to sign in: $error");
      throw Exception(
          'Failed to sign in. ${json.decode(response.body)['message']}');
    }
  }

  Future<bool> isProfileComplete() async {
    final token = await _storage.read(key: 'jwt_token');
    final url = Uri.parse('$baseUrl/api/profile/isProfileComplete');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return responseData['isProfileComplete'];
    } else {
      // Log the response body for more details on the error
      print('Failed to check profile completion status: ${response.body}');
      throw Exception('Failed to check profile completion status.');
    }
  }

  Future<void> printToken() async {
    final String? token = await _storage.read(key: 'jwt_token');
    if (token != null) {
      print("Token is: $token");
    } else {
      print("No token stored.");
    }
  }
}
