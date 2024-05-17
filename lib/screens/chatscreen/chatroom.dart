import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamsyncai/model/chatroom_model.dart';
import 'package:teamsyncai/providers/chatroom_provider.dart';
import 'package:teamsyncai/screens/chatscreen/chatPage.dart';
import 'package:teamsyncai/screens/chatscreen/chatbothomeP.dart';
import 'package:teamsyncai/screens/chatscreen/chatroom_creation.dart';
import 'package:teamsyncai/screens/chatscreen/chatrooms.dart';
import 'package:teamsyncai/screens/chatscreen/translationScreen.dart';

class ChatroomListPage extends StatelessWidget {
  const ChatroomListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatroomProvider>(
      builder: (context, provider, child) {
        final List<ChatroomModel> chatrooms = provider.chatrooms;

        return Scaffold(
          appBar: AppBar(
            title: const Text('ChatRoomHome'),
            backgroundColor: const Color(0xFFd48026),
          ),
        
          body: Column(
            children: <Widget>[
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
                      child: Padding(
                        padding: const EdgeInsets.all(10.0), // Adjusted padding
                        child: Bubble(  // Use custom Bubble widget
                          child: Text(
                            chatroom.name,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                      ),
                      )
                    );
                  },
                ),
              ),
          Container(
                padding: const EdgeInsets.all(20.0), // Increased padding
                child: Wrap( // Use Wrap for flexible layout
                  spacing: 20.0, // Space between icons
                  runSpacing: 20.0, // Space between rows
                  alignment: WrapAlignment.center, // Center icons
                  children: [
                    _buildStyledIconButton(context, Icons.add, 'Create Chatroom', const ChatroomCreationPage(), Colors.blue),
                    _buildStyledIconButton(context, Icons.android, 'Join Bot Chat', const ChatbothomeP(), Colors.green),
                    _buildStyledIconButton(context, Icons.translate, 'Translate', TranslationScreen(), Colors.purple),
                    _buildStyledIconButton(context, Icons.view_list, 'View Chatrooms', const Chatrooms(), Colors.orange),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
    
  }

  Widget _buildStyledIconButton(BuildContext context, IconData icon, String label, Widget targetPage, Color color) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => targetPage));
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2), // Add a subtle background color
              borderRadius: BorderRadius.circular(12.0), // Rounded corners
            ),
            child: Icon(icon, size: 48, color: color),
          ),
          SizedBox(height: 8),
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)), // Bold text
        ],
      ),
    );
  }
}
class Bubble extends StatelessWidget {
  final Widget child;

  const Bubble({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient( // Add a gradient
          colors: [Color(0xFFd48026), Color(0xFFFFC107)], // Orange gradient
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
          bottomLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(2.0), // Make bottom right corner less rounded
        ),
        boxShadow: [ // Add a subtle shadow
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}