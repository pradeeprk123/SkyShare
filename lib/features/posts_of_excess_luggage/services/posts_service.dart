import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PostsService {
  static const String baseUrl = 'http://10.0.2.2:3000/api/posts';

  static Future<List<dynamic>> getPosts(String flightNumber) async {
    final secureStorage = FlutterSecureStorage();
    final token = await secureStorage.read(key: 'jwt_token');

    if (token == null) {
      print("No token found in storage.");
      throw Exception('Authentication token not found.');
    }

    final response =
        await http.get(Uri.parse('$baseUrl/$flightNumber'), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print("Failed to fetch posts: ${response.body}");
      throw Exception(
          'Failed to fetch posts: ${response.statusCode} ${response.reasonPhrase}');
    }
  }
}
