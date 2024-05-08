import 'dart:convert';
import 'package:http/http.dart' as http;

class APIService {
  static Future<List<String>> getLastKeywords(String userInput) async {
    final response = await http.post(
      Uri.parse('https://backend-2-le95.onrender.com/search'),
      body: {'userInput': userInput},
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return List<String>.from(responseData['lastKeywords'] ?? []);
    } else {
      throw Exception('Failed to load keywords');
    }
  }
}