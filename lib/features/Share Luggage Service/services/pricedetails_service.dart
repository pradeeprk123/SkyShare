import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PriceDetailsService {
  static const String baseUrl = 'http://10.0.2.2:3000/api/flights';

  static Future<Map<String, dynamic>> fetchFlightDetails(
      String flightNumber) async {
    final secureStorage = FlutterSecureStorage();
    final String? token = await secureStorage.read(key: 'jwt_token');

    if (token == null) {
      throw Exception('Authentication token not found.');
    }

    var uri = Uri.parse('$baseUrl/details/$flightNumber');
    var response =
        await http.get(uri, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch flight details: ${response.body}');
    }
  }
}
