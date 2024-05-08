import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teamsyncai/providers/chatroom_provider.dart';
import 'package:teamsyncai/model/chatroom_model.dart';
import 'package:teamsyncai/screens/chatscreen/chatroomDetail.dart';
import 'chatPage.dart'; // Import the ChatPage

class Chatrooms extends StatefulWidget {
  const Chatrooms({Key? key}) : super(key: key);

  @override
  _ChatroomsState createState() => _ChatroomsState();
}

class _ChatroomsState extends State<Chatrooms> {
  
  Future<void> saveChatroomId(String chatroomId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('chatroomId', chatroomId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chatrooms'),
        backgroundColor: const Color(0xFFd48026), // Set app bar background color
      ),
      body: Consumer<ChatroomProvider>(
        builder: (context, provider, child) => FutureBuilder<List<ChatroomModel>>(
          future: provider.fetchChatrooms(), // Pass userEmail and receiverEmail
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final chatrooms = snapshot.data!;
              return ListView.builder(
                itemCount: chatrooms.length,
                itemBuilder: (context, index) {
                  final chatroom = chatrooms[index];
                  final receiverEmail = chatroom.receiverEmail;
                  final messageText = chatroom.messagetext.join('\n');

                  return Dismissible(
                    key: Key(chatroom.chatID), // Provide a unique key for each chatroom
                    direction: DismissDirection.startToEnd, // Allow swipe from right to left
                    onDismissed: (direction) {
                      provider.deleteChatroom(chatroom.chatID); // Delete the chatroom
                    },
                    background: Container(
                      color: Colors.red, // Customize the background color
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 16),
                      child: Icon(Icons.delete, color: Colors.white), // Add delete icon
                    ),
                    child: Card(
                      elevation: 3,
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: GestureDetector(
  onTap: () async {
    final String chatroomId = chatroom.chatID; // Get the chatroom ID

    // Call saveChatroomId with the chatroom ID
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('chatroomId', chatroomId);

    // Navigate to the ChatroomDetailsPage
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatroomDetailsPage(chatroom: chatroom),
      ),
    );
  },
  child: Icon(Icons.info_outline), // Add an icon to indicate details
),
                  
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              chatroom.name,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8), // Add spacing between chatroom name and emails
                            Text('User Email: ${chatroom.userEmail}'),
                            Text('Receiver Email: ${receiverEmail.join(', ')}'),
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFd48026), // Set chat container background color
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(messageText),
                          ),
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatPage(
                              chatRoomModel: chatroom,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              print('Error fetching chatrooms: ${snapshot.error}');
              // Add null check for snapshot
              if (snapshot.error != null) {
                return Center(child: Text('Error fetching chatrooms: ${snapshot.error}'));
              } else {
                return const Center(child: Text('Unknown error fetching chatrooms'));
              }
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
