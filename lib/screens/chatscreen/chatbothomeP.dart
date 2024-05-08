import 'package:flutter/material.dart';
import 'package:teamsyncai/screens/chatscreen/feature_list.dart';
import 'package:teamsyncai/screens/chatscreen/imagetextinput_page.dart';
import 'package:teamsyncai/screens/chatscreen/textinput_page.dart';

import 'package:lottie/lottie.dart';

class ChatbothomeP extends StatefulWidget {
  const ChatbothomeP({super.key});

  @override
  State<ChatbothomeP> createState() => _HomepageState();
}

class _HomepageState extends State<ChatbothomeP> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Change background color to white
      appBar: AppBar(
        backgroundColor:
            const Color(0xFFd48026), // Change app bar color to orange
        centerTitle: true,
        title: const Text(
          'CHATGEM',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 4,
              fontFamily: "Cera Pro"),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //bot profile image animations
            Center(
              child: Lottie.asset(
                'assets/Animations/GreetingBot.json',
                height: 300,
              ),
            ),

            //suggestions title text
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(top: 10, left: 20),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Select any one feature',
                style: TextStyle(
                    color:
                        Color(0xFFd48026), // Change text color to orange
                    fontSize: 20,
                    fontFamily: "Cera Pro",
                    fontWeight: FontWeight.bold),
              ),
            ),

            //features of bot
            Column(
              children: [
                //Multi-turn chat feature
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TextInputPage(),
                      ),
                    );
                  },
                  child: FeaturelistBox(
                    textcolor: Colors.black, // Change text color to black
                    color: const Color(0xFFd48026).withOpacity(
                        0.6), // Change box color to orange with adjusted opacity
                    headertext: "Chat with Gem",
                    descriptiontext:
                        "Aids users by generating text, enhancing conversations effectively",
                  ),
                ),

                //Image with text feature
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ImageTextInputPage(),
                      ),
                    );
                  },
                  child: FeaturelistBox(
                    textcolor: Colors.black, // Change text color to black
                    color: const Color(0xFFd48026).withOpacity(
                        0.6), // Change box color to orange with adjusted opacity
                    headertext: "Get Image Insights",
                    descriptiontext:
                        "Helps you to discover the insights of an image",
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}