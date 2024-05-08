import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:teamsyncai/screens/displayprofile.dart';
import 'package:teamsyncai/screens/otp.dart';
import 'package:teamsyncai/providers/GoogleSignInApi.dart';
import 'package:teamsyncai/providers/userprovider.dart';
import 'package:teamsyncai/model/user_model.dart';
import 'package:file_selector/file_selector.dart';
class RegisterWeb extends StatefulWidget {
  const RegisterWeb({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<RegisterWeb>{
  
  final UserProvider _userProvider = UserProvider(); 

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController numTelController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController _cvSkillsController = TextEditingController();

  bool _isLoading = false;
   File? _cvFile;
  
  Widget _buildTextField(TextEditingController controller, String labelText, IconData iconData, bool obscureText) {
    List<String> usernameSuggestions = ['john_doe', 'user123', 'example'];
  
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: [
            Icon(iconData, color: Colors.orange),
            const SizedBox(width: 10),
            Expanded(
              child: Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  // Filter suggestions based on the entered text
                  return usernameSuggestions
                      .where((suggestion) =>
                          suggestion.toLowerCase().contains(textEditingValue.text.toLowerCase()))
                      .toList();
                },
                onSelected: (String selectedUsername) {
                  // Update the text field with the selected username
                  controller.text = selectedUsername;
                },
                fieldViewBuilder: (BuildContext context, TextEditingController fieldController, FocusNode fieldFocusNode, VoidCallback onFieldSubmitted) {
                  // This is the text field view builder
                  fieldController = controller; // Assign the controller to the outer variable
                  return TextFormField(
                    controller: fieldController,
                    focusNode: fieldFocusNode,
                    onFieldSubmitted: (_) => onFieldSubmitted(),
                    obscureText: obscureText,
                    decoration: InputDecoration(
                      labelText: labelText,
                      border: InputBorder.none,
                    ),
                  );
                },
                optionsViewBuilder: (BuildContext context, AutocompleteOnSelected<String> onSelected, Iterable<String> options) {
                  // This is the view builder for the suggestions list
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                      elevation: 4,
                      child: SizedBox(
                        height: 200,
                        child: ListView(
                          children: options
                              .map((String option) => GestureDetector(
                                    onTap: () => onSelected(option),
                                    child: ListTile(
                                      title: Text(option),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
Future<void> _pickCV() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf'],
  );

  if (result != null) {
    setState(() {
      _cvFile = File(result.files.single.path!);
    });
    _extractSkillsFromCV();
  } else {
    setState(() {
      _cvFile = null; // Set _cvFile to null if no file is selected
    });
  }
}

  Future<String> extractTextFromPDF(File pdfFile) async {
    // Placeholder implementation for extracting text from PDF
    // Implement your logic to extract text from the PDF file
    return '';
  }

  List<String> extractSkills(String text) {
    // Placeholder implementation for extracting skills from text
    // Implement your logic to extract skills from the provided text
    return [];
  }

  void _extractSkillsFromCV() async {
    String selectedSkill = '';

    if (_cvFile != null) {
      try {
        final text = await extractTextFromPDF(_cvFile!);
        final List<String> cvSkills = extractSkills(text);
        final List<String> availableSkills = _getAvailableSkills(cvSkills);

        if (availableSkills.isNotEmpty) {
          // Pick one skill randomly from the available skills
          final Random random = Random();
          selectedSkill = availableSkills[random.nextInt(availableSkills.length)];
        } else {
          // No matching skills found in the CV, choose one skill randomly from the list
          final List<String> allSkills = _getAllSkills();
          final Random random = Random();
          selectedSkill = allSkills[random.nextInt(allSkills.length)];
        }
      } catch (e) {
        print('Error extracting skills: $e');
      }
    }

    setState(() {
      _cvSkillsController.text = selectedSkill;
    });
  }

  List<String> _getAvailableSkills(List<String> cvSkills) {
    // Placeholder implementation for getting available skills
    // Compare cvSkills with a predefined list of skills
  const List<String> skillList = [
 
  "organization",
  "analytical skills",
 
  "java",
  "python",
  "javascript",
  "c++",
  "c#",
  "sql",
  "html",
  "css",
  "linux",
  "machine learning",
  "php",
  "swift",
  "kotlin",
  "rust",
  "react",
  "angular",
  "vue.js",
  "node.js",
  "express.js",
  "django",
  "spring boot",
  "mongodb",
  "cassandra",
  "hadoop",
  "spark",
  "aws",
  "azure",
  "gcp",
  "network security",
  "devops",
  "pandas",
  "r",
  "tensorflow",
  "pytorch",
  "agile",
  "scrum",
  "ux/ui",
  "seo",
  "sem",
];

    return cvSkills
        .where((skill) => skillList.contains(skill.toLowerCase()))
        .toList();
  }

  List<String> _getAllSkills() {
    // Return a list of all predefined skills
    return [
      "organization",
  "analytical skills",
  "java",
  "python",
  "javascript",
  "c++",
  "c#",
  "sql",
  "html",
  "css",
  "linux",
  "machine learning",
  "php",
  "ruby",
  "swift",
  "kotlin",
  "react",
  "angular",
  "vue.js",
  "node.js",
  "express.js",
  "django",
  "spring boot",
  "mongodb",
  "aws",
  "azure",
  "gcp",
  "network security",
  "tensorflow",
  "pytorch",
  "agile",
  "scrum",
  "ux/ui",
  "seo",
  "sem",
      // Add more skills as needed
    ];
  }

 @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20.0),
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset("assets/images/logo.png"), 
                  const Text(
                    'GET STARTED',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              _buildTextField(usernameController, 'Name', Icons.person, false),
              const SizedBox(height: 10.0),
              _buildTextField(emailController, 'Email Address', Icons.email, false),
              const SizedBox(height: 10.0),
              _buildTextField(numTelController, 'Phone Number', Icons.phone, false),
              const SizedBox(height: 10.0),
              _buildTextField(passwordController, 'Password', Icons.lock, true),
              const SizedBox(height: 10.0),
              _buildTextField(passwordController, 'Confirm Password', Icons.lock, true),
            ElevatedButton(
  onPressed: _pickCV,
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      const Icon(Icons.file_upload),
      const SizedBox(width: 5),
      Text(_cvFile != null ? 'Change CV' : 'Pick CV'),
    ],
  ),
),

if (_cvFile != null)
  Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    child: Text(
      _cvFile!.path,
      style: const TextStyle(fontWeight: FontWeight.bold),
    ),
  ),



              const SizedBox(height: 10.0),
              Row(
                children: <Widget>[
                  Checkbox(
                    value: false,
                    onChanged: (value) {},
                  ),
                  const Text(
                    "By signing in, you agree to our ",
                    style: TextStyle(fontSize: 12),
                  ),
                  GestureDetector(
                    onTap: () {
                      _showPrivacyPolicyBottomSheet(context);
                    },
                    child: const Text(
                      "Terms & Conditions",
                      style: TextStyle(
                        fontSize: 12,
                        decoration: TextDecoration.underline,
                        color: Color.fromARGB(255, 119, 194, 245),
                        fontFamily: 'Montserrat', 
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
     ElevatedButton(
  onPressed: () async {
    if (usernameController.text.isEmpty || emailController.text.isEmpty || numTelController.text.isEmpty || passwordController.text.isEmpty || _cvSkillsController.text.isEmpty) {
      // Show an error message or dialog indicating that all fields are required
      return;
    }

 try {
      final User newUser = await _userProvider.createUser(
        usernameController.text,
        emailController.text,
        numTelController.text,
        passwordController.text,
        _cvSkillsController.text,
        _cvFile, // Pass the PDF file to createUser function
      );
      // User creation successful, navigate to the next screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => otp()), 
      );
    } catch (e) {
      print('Error creating user: $e');
      // Handle error
    }
  },

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  textStyle: const TextStyle(color: Colors.white),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white) // Show progress indicator while loading
                    : const Text('Sign up'),
              ),
              const SizedBox(height: 10.0),
              const Text('or sign up with'),
              const SizedBox(height: 10.0),
              _buildSocialLoginButtons(),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('Have an account?'),
                  TextButton(
                    child: const Text(
                      'SIGN IN',
                      style: TextStyle(color: Colors.orange),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // Go back to the previous screen
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildSocialLoginButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        InkWell(
          onTap: signIn,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.25),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Image.asset("assets/icons/search.png"),
            ),
          ),
        ),
        const SizedBox(width: 10),
        InkWell(
          onTap: () {
            // Handle Facebook login
          },
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Image.asset("assets/icons/facebook.png"),
            ),
          ),
        ),
        const SizedBox(width: 10),
        InkWell(
          onTap: () {
            // Handle LinkedIn login
          },
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Image.asset("assets/icons/linkedin.png"),
            ),
          ),
        ),
      ],
    );
  }

 

  Future signIn() async {
    final user = await GoogleSignInApi.login();

    if (user == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Sign in Failed')));
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => displayprofile(user: user),
      ));
    }
  }

  void _showPrivacyPolicyBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20.0),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "How We Use Your Data",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                " We collect and store data provided by users to improve our services and customize user experiences. Your use of the app is at your own risk.Limitation of Liability: Our company shall not be liable for any direct, indirect, incidental, consequential, or punitive damages arising out of or in connection with your use of the app. Governing Law: These Terms & Conditions shall be governed by and construed in accordance with the laws of Tunisia, without regard to its conflict of law provisions. Contact Us: If you have any questions or concerns about these Terms & Conditions, please contact us at teamsyncai@gmail.tn.Thank you for using our app!",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              // Add more text or content here as needed
            ],
          ),
        );
      },
    );
  }
}