import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/module.dart';

mixin Task_Module_service {
  static const String baseURL = 'http://192.168.128.222:3000';
  Future<double> fetchCompletionPercentage(String moduleId) async {
    try {
      final response = await http.get(Uri.parse('$baseURL/completionPercentage/$moduleId'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['completionPercentage'] * 1.0; // Convert to double
      } else {
        throw Exception('Failed to fetch completion percentage');
      }
    } catch (error) {
      print('Error fetching completion percentage: $error');
      throw Exception('Failed to fetch completion percentage');
    }
  }
  Future<List<Module>> fetchModulesByEmail(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseURL/getMByEmail'),
        body: jsonEncode({'email': email}), // Pass email in the request body
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<Module> modules = data.map<Module>((moduledata) {
          return Module.fromJson(moduledata);
        }).toList();

        return modules;
      } else {
        throw Exception('Failed to load modules');
      }
    } catch (e) {
      throw Exception('Error fetching modules: $e');
    }
  }

}