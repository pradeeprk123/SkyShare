import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ChatService {
  static const String baseUrl = 'http://10.0.2.2:3000/api/chats';

  static Future<void> createChat(List<String> participantIds) async {
    final secureStorage = FlutterSecureStorage();
    final token = await secureStorage.read(key: 'jwt_token');

    if (token == null) {
      throw Exception('Authentication token not found.');
    }

    final response = await http.post(Uri.parse('$baseUrl/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'participants': participantIds,
        }));

    if (response.statusCode != 201) {
      throw Exception('Failed to create chat: ${response.body}');
    }
  }

  static Future<List<dynamic>> getChatMessages(String chatId) async {
    final secureStorage = FlutterSecureStorage();
    final token = await secureStorage.read(key: 'jwt_token');

    if (token == null) {
      throw Exception('Authentication token not found.');
    }

    final response = await http.get(Uri.parse('$baseUrl/$chatId'), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch chat messages: ${response.body}');
    }
  }

  static Future<void> sendMessage(String chatId, String message) async {
    final secureStorage = FlutterSecureStorage();
    final token = await secureStorage.read(key: 'jwt_token');

    if (token == null) {
      throw Exception('Authentication token not found.');
    }

    final response = await http.post(Uri.parse('$baseUrl/$chatId/messages'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'message': message,
        }));

    if (response.statusCode != 200) {
      throw Exception('Failed to send message: ${response.body}');
    }
  }
}
