import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gemini/flutter_gemini.dart';
import 'dart:convert';

import 'package:teamsyncai/screens/screenrec/recType.dart';
class AddReclamation extends StatefulWidget {
    final String email;
  const AddReclamation({super.key, required this.email});

  @override
  _AddReclamationState createState() => _AddReclamationState();
}

class _AddReclamationState extends State<AddReclamation> {
  final String geminiApiKey =
      'AIzaSyClWfgG5mWkUT8q5gIOU9H0FyY09FUhYfg'; 
  final _formKey = GlobalKey<FormState>();
  final _titreController = TextEditingController();
  final _projetController = TextEditingController();
  final _emailController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDate;

  final _backendUrl = 'http://192.168.128.222:3000/reclamation';

  List<String> _types = [
    'Ideas and Suggestions',
    'Reporting Problems',
    'Task and Project Management',
    'Support Requests',
    'Feedback',
    'Health'
  ];
  String _selectedType = 'Ideas and Suggestions';

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
   Gemini.init(apiKey: geminiApiKey);
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
        backgroundColor: Colors.orange,

    ),
    body: Stack(
      children: [
        SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: 100),
                      const Text(
                        'Date : ',
                        style: TextStyle(fontSize: 20),
                      ),
                      Expanded(
                        child: ListTile(
                          title: InputDecorator(
                            decoration: const InputDecoration(
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              focusedErrorBorder: InputBorder.none,
                            ),
                            child: Text(_selectedDate == null
                                ? 'Select Date'
                                : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  DropdownButtonFormField<String>(
                    value: _selectedType,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedType = newValue!;
                      });
                    },
                    items: _types.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'Type',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide: const BorderSide(color: Colors.orange),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide: const BorderSide(color: Colors.orange),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  _buildCustomTextField(
                    labelText: 'Title',
                    controller: _titreController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  _buildCustomTextField(
                    labelText: 'Project Name',
                    controller: _projetController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a project name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  _buildCustomTextField(
                    labelText: 'Complaints coordinator Email',
                    controller: _emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
                      }
                      if (!isValidEmail(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        child: _buildCustomTextField(
                          labelText: 'Description',
                          controller: _descriptionController,
                          maxLines: 5,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a description';
                            }
                            return null;
                          },
                        ),
                      ),
                     IconButton(
                       onPressed: () async {
                          final gemini = Gemini.instance;
                          final currentDescription = _descriptionController.text;

                          try {
                           final improvedDescriptionResponse = await gemini.text(
                            "make this descrption $currentDescription  like it is the paragraphe in a mail professional , return me only the paragraph without dear .",
                           );

                            final improvedDescription =
                                improvedDescriptionResponse?.output;
                            if (improvedDescription != null) {
                              setState(() {
                                _descriptionController.text = improvedDescription;
                              });
                            } else {
                              print('Failed to generate improved description');
                            }
                          } catch (error) {
                            print('Error during text generation: $error');
                          }
                        },
                        icon: const Icon(Icons.lightbulb_outline),
                        tooltip: 'Suggest improvements for the description',
                        color: Colors.orange,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Row(
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
    Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Image.asset(
        'assets/imageRec/3.png',
        width: 200,
        height: 200, 
        fit: BoxFit.contain, 
      ),
    ),
   Expanded(
  child: SizedBox(
    width: 100, // Définir une largeur minimale
    child: ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          try {
            final response = await http.post(
              Uri.parse(_backendUrl),
              body: jsonEncode({
                'title': _titreController.text,
                'description': _descriptionController.text,
                'date': _selectedDate.toString(),
                'status': 'In progress',
                'type': _selectedType.toLowerCase(),
                'emailManager': _emailController.text,
                'projectName': _projetController.text,
                'userEmail': getCurrentUserEmail(),
                  
              }),
              headers: {'Content-Type': 'application/json'},
            );

            if (response.statusCode == 200) {
              _showSuccessDialog();
            } else {
              print('Error adding reclamation: ${response.statusCode}');
            }
          } catch (error) {
            print('Error: $error');
          }
        }
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
      ),
      child: const Text('Send'),
    ),
  ),
),

  ],
),

                ],
              ),
            ),
          ),
        ),
        
      ],
    ),
  );
}


  Widget _buildCustomTextField({
    required String labelText,
    TextEditingController? controller,
    int maxLines = 1,
    FormFieldValidator<String>? validator,
    Widget? child,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: validator,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.normal,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.0),
            borderSide: const BorderSide(color: Colors.orange, width: 2.0),
          ),
           focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.0),
            borderSide: const BorderSide(color: Colors.orange, width: 2.0),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          errorStyle: const TextStyle(color: Colors.orange), // Définition de la couleur du message d'erreur
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.0),
            borderSide: const BorderSide(color: Colors.orange),
          ),
        ),
      ),
    );
  }



String getCurrentUserEmail() {
    // Logique pour obtenir l'e-mail de l'utilisateur actuellement connecté
    // Par exemple, si vous utilisez une authentification, vous pouvez le récupérer à partir de là
    return widget.email; // Remplacez ceci par la logique réelle
  }

  bool isValidEmail(String email) {
    String emailRegex =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(emailRegex);
    return regex.hasMatch(email);
  }

  Future<void> _showSuccessDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
             
            Text(
  'Your complaint has been successfully submitted.',
  textAlign: TextAlign.center,
  style: TextStyle(
    fontSize: 20, // Définir la taille de police à 20
    color: Colors.black,
  ),
),
Text(
  'Expect our response soon.',
  style: TextStyle(
    fontSize: 20, // Définir la taille de police à 20
    color: Colors.black,
  ),
),

            ],
          ),
          actions: <Widget>[
  Center(
    child: TextButton(
      onPressed: () {
       Navigator.of(context).push(MaterialPageRoute(builder: (context) => RecTypeScreen(email: widget.email),));



      },
      child: const Text(
        'OK',
        style: TextStyle(
          color: Colors.orange,
        ),
      ),
    ),
  ),
],

          
        );
      },
    );
  }
}