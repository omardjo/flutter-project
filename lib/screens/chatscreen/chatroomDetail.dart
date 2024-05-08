import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamsyncai/model/chatroom_model.dart';
import 'package:teamsyncai/model/mModel.dart' as MyMessage;
import 'package:teamsyncai/providers/chatroom_provider.dart';
import 'chatPage.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

class ChatroomDetailsPage extends StatelessWidget {
  final ChatroomModel chatroom;

  const ChatroomDetailsPage({Key? key, required this.chatroom}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController messageController = TextEditingController();

    return ChangeNotifierProvider(
      create: (context) => ChatroomProvider(), // Create a new instance of ChatroomProvider
      child: Scaffold(
        appBar: AppBar(
          title: Text('Chatroom Details'),
          backgroundColor: Color(0xFFd48026), // Set AppBar color
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sender Email: ${chatroom.userEmail}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Messages:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Expanded(
                child: Builder(
                  builder: (context) {
                    return FutureBuilder<List<MyMessage.MessageModel>>(
                      future: Provider.of<ChatroomProvider>(context).getMessagesForChatroomId(chatroom.chatID),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else {
                          final List<MyMessage.MessageModel> messages = snapshot.data ?? [];
                          return ListView.builder(
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              final MyMessage.MessageModel message = messages[index];
                              return ListTile(
                                title: Text(message.text),
                                subtitle: Text(message.senderEmail),
                              );
                            },
                          );
                        }
                      },
                    );
                  },
                ),
              ),
              Divider(),
              Text(
                'Receiver Email: ${chatroom.receiverEmail.join(", ")}', // Use join to remove brackets
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        decoration: InputDecoration(
                          hintText: 'Type your message...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () async {
                        // Get the message text from the text field
                        String messageText = messageController.text;
                        final String? chatID = chatroom.chatID; // Use the chatroom's chatID

                        if (chatID != null) {
                          // Get the sender email from the provider
                          String sender = await Provider.of<ChatroomProvider>(context, listen: false).getUserEmail() ?? '';

                          // Get the receiver email from the chatroom model
                          final List<String> receiverEmails = chatroom.receiverEmail;

                          // Create a MessageModel object using the message text, sender email, and receiver email
                          final MyMessage.MessageModel message = MyMessage.MessageModel(
                            id: DateTime.now().toString(),
                            text: messageText,
                            senderEmail: sender,
                            receiverEmail: receiverEmails,
                            senderID: '',
                            receiverID: '',
                          );

                          // Call the function to send the message using the provider
                          Provider.of<ChatroomProvider>(context, listen: false).sendMessage(chatID, message);

                          // Clear the text field after sending the message
                          messageController.clear();
                        } else {
                          // Handle the case where chatID is null
                          print('Error: Chatroom ID is null');
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
