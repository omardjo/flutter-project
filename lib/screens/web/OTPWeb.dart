import 'package:flutter/material.dart';
import 'package:teamsyncai/screens/onboardingscreen.dart';
import 'package:http/http.dart' as http;

class OTPWeb extends StatefulWidget {
  @override
  _OTPWebState createState() => _OTPWebState();
}

class _OTPWebState extends State<OTPWeb> {
  final TextEditingController _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 15,
        iconTheme: const IconThemeData(color: Colors.black38),
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Enter Confirmation Code',
              style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Enter the 4-digit code we sent to your phone number',
              style: TextStyle(fontSize: 18.0, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30.0),
            SizedBox(
              width: 200, // Adjust the width according to your preference
              child: TextFormField(
                controller: _codeController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24.0, color: Colors.black87, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  hintText: 'Enter code',
                  hintStyle: const TextStyle(fontSize: 18.0, color: Colors.black54),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.orange, width: 2.0),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black26, width: 2.0),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                ),
              ),
            ),
            const SizedBox(height: 30.0),
            ElevatedButton(
              onPressed: () {
                verifyOTP(_codeController.text, context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 16.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
              ),
              child: const Text('Confirm', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> verifyOTP(String enteredOTP, BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('your_backend_url/verifyOTP'),
        body: {'enteredOTP': enteredOTP},
      );

      if (response.statusCode == 200) {
        // OTP verified successfully, proceed with next steps
        // For example, navigate to the next screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OnboardingScreen()),
        );
      } else {
        // Handle error, display appropriate message to user
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('OTP Verification Failed'),
              content: Text('Invalid OTP. Please try again.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (error) {
      // Handle network or other errors
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to verify OTP. Please try again later.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
