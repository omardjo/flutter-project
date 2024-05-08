import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GeminiService {
  static Future<List<String>> getMessageSuggestions(String input) async {
    try {
      final url = Uri.parse('https://backend-2-le95.onrender.com/suggestions');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'input': input}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final suggestions = List<String>.from(data);
        print('Suggestions: $suggestions');
        return suggestions;
      } else {
        print('Failed to fetch suggestions. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching suggestions: $e');
    }

    return [];
  }
}