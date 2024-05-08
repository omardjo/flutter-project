import 'package:flutter/material.dart';
import 'package:teamsyncai/screens/home.dart';
import 'package:teamsyncai/screens/whoareyou.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentPage = 0;
  PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: [
              buildPageContent('assets/images/1.png', 'Create Projects',
                  'Create projects that you can easily share with your team members for better collaboration and tracking.'),
              buildPageContent('assets/images/2.png', 'Track Tasks',
                  'Track your tasks efficiently and stay updated on your project\'s progress.'),
              buildPageContent('assets/images/3.png', 'Reach Goals',
                  'Set ambitious goals and track your progress towards achieving them with our intuitive platform.'),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 80.0,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WhoAreYou(/*email: ''*/)), // Navigate to home.dart
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  minimumSize: Size(200, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  'Get Started',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List<Widget>.generate(
                3,
                (index) => buildDot(index: index),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDot({required int index}) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      margin: EdgeInsets.only(right: 5),
      height: 8,
      width: _currentPage == index ? 24 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index ? Colors.orange : Colors.grey,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

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
}