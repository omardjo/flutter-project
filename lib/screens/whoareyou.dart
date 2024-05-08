// who_are_you.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teamsyncai/screens/next.dart';
import 'home.dart'; // Import your home.dart file

class WhoAreYou extends StatefulWidget {
  @override
  _WhoAreYouState createState() => _WhoAreYouState();
}

class _WhoAreYouState extends State<WhoAreYou> {
  int _selectedIndex = 0; // Initialize the selected index to 0

  final List<String> _classes = [
    "Individual",
    "Company",
    "Start-up",
    "Student",
    "University",
    "High School",
  ]; // Your list of classes

  Widget buildPageContent(String imagePath, String title, String description) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath, height: 300),
          SizedBox(height: 40.0),
          Text(
            title,
            style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          SizedBox(height: 20.0),
          Text(
            description,
            style: TextStyle(fontSize: 18.0, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // CupertinoPicker Implementation
  Widget _cupertinoPicker() {
    return CupertinoPicker(
      itemExtent: 32.0, // Height of each item
      onSelectedItemChanged: (int index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      children: _classes.map((String classItem) {
        return Text(
          classItem,
          style: TextStyle(
            fontSize: 20.0,
            color: _selectedIndex == _classes.indexOf(classItem) ? Colors.red : Colors.black,
          ),
        );
      }).toList(),
    );
  }

  void _navigateToHomePage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NextPage()), // Navigate to Home page
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildPageContent(
              'assets/images/checkmark.png',
              'Choose what defines you',
              'Select from the options below to define yourself.',
            ),
            SizedBox(height: 40.0),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[200],
              ),
              child: _cupertinoPicker(), // Cupertino Picker
            ),
            SizedBox(height: 50.0), // Add spacing between picker and button
            ElevatedButton(
              onPressed: () {
                _navigateToHomePage(context); // Navigate to home page
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(200, 50),
                backgroundColor: Colors.orange, // Set button color
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                'Next',
                style: TextStyle(fontSize: 20.0, color: Colors.white), // Set text color to white
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: WhoAreYou(),
  ));
}
