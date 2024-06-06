// import 'dart:convert';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BaggageDetailsService {
  static const String baseUrl = 'http://10.0.2.2:3000/api/baggage';
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<bool> postBaggageDetails({
    required String weight,
    required String description,
    required String flightNumber,
    required List<XFile>? imageFiles,
  }) async {
    final String? token = await _storage.read(key: 'jwt_token');
    if (token == null) {
      print("No token found in storage.");
      return false;
    }

    var request = http.MultipartRequest('POST', Uri.parse(baseUrl));
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['weight'] = weight;
    request.fields['description'] = description;
    request.fields['flightNumber'] = flightNumber;

    if (imageFiles != null) {
      for (var file in imageFiles) {
        request.files
            .add(await http.MultipartFile.fromPath('pictures', file.path));
      }
    }

    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final baggageId = jsonDecode(response.body)['baggageId'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('baggageId', baggageId.toString());
        print('Baggage ID saved: $baggageId');
        return true;
      } else {
        print("Server response: ${response.body}");
        return false;
      }
    } catch (e) {
      print('Error posting baggage details: $e');
      return false;
    }
  }
}
