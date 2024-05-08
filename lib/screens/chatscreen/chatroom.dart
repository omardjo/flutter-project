import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamsyncai/model/chatroom_model.dart';
import 'package:teamsyncai/providers/chatroom_provider.dart';
import 'package:teamsyncai/screens/chatscreen/chatPage.dart';
import 'package:teamsyncai/screens/chatscreen/chatbothomeP.dart';
import 'package:teamsyncai/screens/chatscreen/chatroom_creation.dart'; // Import the ChatbothomeP page
import 'package:teamsyncai/screens/chatscreen/chatrooms.dart';
import 'package:teamsyncai/screens/chatscreen/textinput_page.dart';
import 'package:teamsyncai/screens/chatscreen/translationScreen.dart'; // Import the TextInputPage for translation

class ChatroomListPage extends StatelessWidget {
  const ChatroomListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatroomProvider>(
      builder: (context, provider, child) {
        // Call the method to fetch chatrooms

        // Access the chatrooms from the provider
        final List<ChatroomModel> chatrooms = provider.chatrooms;

        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('./assets/images/backg.jpg'), // Path to your image
              fit: BoxFit.cover, // Adjust the image size
            ),
          ),
          child: Scaffold(
              backgroundColor: Colors.transparent, // Set background to transparent

            appBar: AppBar(
              title: const Text('ChatRoomHome'),
            backgroundColor: const Color(0xFFd48026), // Set the app bar color to orange
            ),
            body: Column(
              children: <Widget>[
                // Beautiful place for showing chatrooms
                Expanded(
                  child: ListView.builder(
                    itemCount: chatrooms.length,
                    itemBuilder: (context, index) {
                      final ChatroomModel chatroom = chatrooms[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatPage(
                                chatRoomModel: chatroom,
                              ),
                            ),
                          );
                        },
              
                      );
                    },
                  ),
                ),

                // Example of an IconButton for adding a chatroom
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FloatingActionButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ChatroomCreationPage(),
                              ),
                            );
                          },
                          child: const Icon(Icons.add),
                        ),
                         SizedBox(height: 16),
                        FloatingActionButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>  const Chatrooms(),
                              ),
                            );
                          },
                         child: Image.asset('assets/images/ViewIcon.png'), // Replace 'your_icon.png' with your image asset path
                        ),
                        
                        SizedBox(height: 16),
                        FloatingActionButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ChatbothomeP(),
                              ),
                            );
                          },
                          child: const Icon(Icons.android),
                        ),
                        SizedBox(height: 16),
                        FloatingActionButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>  TranslationScreen(),
                              ),
                            );
                          },
                          child: const Icon(Icons.translate), // Translation icon
                        ),
                        
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
