import 'package:flutter/material.dart';
import 'package:teamsyncai/screens/select_plan.dart';
import 'home.dart'; // Import the home.dart file

class NextPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/graduation.png', height: 200), // Adjusted image height
              SizedBox(height: 50.0), // Add spacing
              Text(
                'Congratulations',
                style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              SizedBox(height: 20.0), // Add spacing
              Text(
                ' We hope you continue to achieve great things with Teamsyncai.',
                style: TextStyle(fontSize: 18.0, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 100.0), // Add spacing
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SubscriptionScreen()), 
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(200, 50),
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  'Done',
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
