import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:teamsyncai/model/module.dart';
import 'package:teamsyncai/screens/task.dart/taskPage.dart';

import 'modulesList.dart';

class taskmain extends StatelessWidget {
  final String email;

  const taskmain({Key? key, required this.email}) : super(key: key);

  Future<List<Module>> fetchModulesByEmail(String email) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.128.222:3000/getMByEmail'),
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: const Text(
            'Modules',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: FutureBuilder<List<Module>>(
          future: fetchModulesByEmail(email),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              List<Module> modules = snapshot.data!;
              return ListView.builder(
                itemCount: modules.length,
                itemBuilder: (context, index) {
                  var module = modules[index];
                  return ListTileModule(
                    projectTitle: module.projectID,
                    moduleTitle: module.module_name,
                    teamMembers: module.teamM,
                    profileImagePaths: const ['images/reclamation.jpg'],
                    percentage: 50,
                    imagePath: 'assets/images/pp.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TasksPage(
                            moduleId: module.module_id,
                            moduleName: module.module_name,
                            teamMembers: module.teamM,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}