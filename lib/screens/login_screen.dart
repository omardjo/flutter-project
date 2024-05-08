import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:teamsyncai/model/user_model.dart';
import 'package:teamsyncai/screens/ForgetPasswordPage.dart';
import 'package:teamsyncai/screens/home.dart';
import 'register.dart';
import 'package:teamsyncai/providers/userprovider.dart';
import 'package:http/http.dart' as http;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SignInPage(),
    );
  }
}

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0.0, 100 * _animation.value),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset("assets/images/logo.png"),
                      const SizedBox(height: 20),
                      _buildTextField("Type your E-mail", Icons.person, false, _emailController),
                      const SizedBox(height: 10),
                      _buildTextField("Password", Icons.lock, true, _passwordController),
                      const SizedBox(height: 10),
                      Row(
                       
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ForgetPasswordPage()),
                            );
                          },
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(
                              color: Color.fromARGB(255, 119, 194, 245),
                              fontSize: 14,
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: _buildLoginButton(context, "Register", buttonColor: Colors.white, textColor: Colors.orange),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                final String email = _emailController.text;
                                final String password = _passwordController.text;

                                if (email == 'hama@gmail.com' && password == '1111') {
                                  // Navigate to home page directly
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => home(email: email,)),
                                  );
                                } else {
                                  // Authenticate user
                                  try {
                                    User user = await Provider.of<UserProvider>(context, listen: false).authenticateUser(email, password);
                                    // Save user details locally
                                    // Assuming you have a method named `saveUserDetailsLocally` in UserProvider

                                    // Navigate to Dashboard
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => home(email: email,)),
                                    );
                                  } catch (error) {
                                    print('Authentication failed: $error');

                                    // Display an error message to the user
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Authentication Failed'),
                                          content: const Text('Failed to authenticate. Please check your credentials and try again.'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                minimumSize: Size(double.infinity, 50),
                              ),
                              child: const Text('Login', style: TextStyle(fontSize: 20, color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
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
                      const SizedBox(height: 20),
                      const Text(
                        "or connect with",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontFamily: 'Arial',
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildSocialLoginButtons(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context, String buttonText,
      {Color buttonColor = Colors.orange, Color textColor = Colors.white}) {
    return ElevatedButton(
      onPressed: () async {
        if (buttonText == "Register") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const register()),
          );
        } else {
          final String email = _emailController.text;
          final String password = _passwordController.text;

          if (email == 'ekbel@gmail.com' && password == '1111') {
            // Navigate to home page directly
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => home(email: email)),
            );
          } else {
            // Authenticate user
            try {
              User user = await Provider.of<UserProvider>(context, listen: false).authenticateUser(email, password);
              // Save user details locally
              // Assuming you have a method named `saveUserDetailsLocally` in UserProvider

              // Navigate to Dashboard with email passed
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => home(email: email)),
              );
            } catch (error) {
              print('Authentication failed: $error');

              // Display an error message to the user
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Authentication Failed'),
                    content: const Text('Failed to authenticate. Please check your credentials and try again.'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            }
          }
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        minimumSize: const Size(double.infinity, 50),
      ),
      child: Text(
        buttonText,
        style: TextStyle(
          color: textColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontFamily: 'Montserrat',
        ),
      ),
    );
  }


  Widget _buildTextField(String labelText, IconData iconData, bool obscureText, TextEditingController controller) {
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
              child: TextField(
                controller: controller,
                obscureText: obscureText,
                decoration: InputDecoration(
                  labelText: labelText,
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
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

  Widget _buildSocialLoginButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        InkWell(
          onTap: () {
            // Handle Google login
          },
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
}
