import 'dart:convert';
import 'package:http/http.dart' as http;

class TranslationService {
  static const String apiUrl = 'https://backend-2-le95.onrender.com/traduction/translate'; // Update with your backend URL

  static Future<String> translateText(String inputText, String inputLanguage, String outputLanguage, String userEmail) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-type': 'application/json'},
        body: jsonEncode({
          'text': inputText,
          'from': inputLanguage,
          'to': outputLanguage,
          'userEmail': userEmail,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['translatedText'];
      } else {
        throw Exception('Failed to translate text');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}