import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class WalletService {
  static const String baseUrl = 'http://10.0.2.2:3000/api/wallet';
  static final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  static Future<double> getTotalBalance() async {
    final String? token = await secureStorage.read(key: 'jwt_token');
    if (token == null) {
      throw Exception('Authentication token not found.');
    }
    var uri = Uri.parse('$baseUrl/balance');
    var response =
        await http.get(uri, headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return (data['balance'] is int)
          ? (data['balance'] as int).toDouble()
          : data['balance'];
    } else {
      print('Error fetching wallet balance: ${response.body}');
      throw Exception('Failed to fetch wallet balance: ${response.body}');
    }
  }

  static Future<bool> addToWallet(double amount, String baggageId) async {
  final String? token = await secureStorage.read(key: 'jwt_token');
  if (token == null) {
    throw Exception('Authentication token not found.');
  }
  var uri = Uri.parse('$baseUrl/add');
  var response = await http.post(
    uri,
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: json.encode({'amount': amount, 'baggageId': baggageId}),
  );
  return response.statusCode == 200;
}
}
