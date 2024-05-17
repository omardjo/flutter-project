import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamsyncai/providers/chatroom_provider.dart';
import 'package:teamsyncai/model/chatroom_model.dart'; // Import the ChatroomModel class
import 'chatPage.dart'; // Import the ChatPage

class ChatroomCreationPage extends StatefulWidget {
  const ChatroomCreationPage({Key? key}) : super(key: key);

  @override
  _ChatroomCreationPageState createState() => _ChatroomCreationPageState();
}

class _ChatroomCreationPageState extends State<ChatroomCreationPage> {
  late TextEditingController _chatroomNameController;
  late TextEditingController _chatroomMemberEmailController;
  late TextEditingController _chatroomTopicController;

  @override
  void initState() {
    super.initState();
    _chatroomNameController = TextEditingController();
    _chatroomMemberEmailController = TextEditingController();
    _chatroomTopicController = TextEditingController();
  }

  @override
  void dispose() {
    _chatroomNameController.dispose();
    _chatroomMemberEmailController.dispose();
    _chatroomTopicController.dispose();
    super.dispose();
  }

  void _createChatroom(ChatroomProvider provider) async {
  final String name = _chatroomNameController.text.trim();
  final String topic = _chatroomTopicController.text.trim();
  final String memberEmailsString = _chatroomMemberEmailController.text.trim();
    
  if (name.isNotEmpty && topic.isNotEmpty && memberEmailsString.isNotEmpty) {
    try {
      final userEmail = await provider.getUserEmail(); // Await getUserEmail()
      if (userEmail != null) {
Map<String, dynamic> receiverEmailsMap = Map.fromIterable(
  memberEmailsString.split(','),
  key: (email) => email,
  value: (_) => true,
);

        await provider.createChatroom(name, receiverEmailsMap, topic);
        // await provider.saveReceiverEmail(receiverEmails);

        _chatroomNameController.clear();
        _chatroomMemberEmailController.clear();
        _chatroomTopicController.clear();

        // Navigate to the ChatPage after creating the chatroom
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(
              chatRoomModel: ChatroomModel(
                name: name,
                userEmail: userEmail, // Use the awaited userEmail
               receiverEmail: receiverEmailsMap.keys.toList(), // Extract keys from the map
                topic: topic,
                messagetext: [], // Empty messages list initially
                createdAt: DateTime.now(), // Current date and time
              ),
            ),
          ),
        );
      } else {
        print('User email is null');
        // Handle the case where user email is null
      }
    } catch (e) {
      // Handle error
      print('Error creating chatroom: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Failed to create chatroom. Please try again later.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
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


  @override
  Widget build(BuildContext context) {
    return Consumer<ChatroomProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Create Chatroom'),
             backgroundColor: const Color(0xFFd48026),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _chatroomNameController,
                  decoration: const InputDecoration(
                    hintText: 'Enter chatroom name...',
                    labelText: 'Chatroom Name',
                  ),
                ),
                TextField(
                  controller: _chatroomMemberEmailController,
                  decoration: const InputDecoration(
                    hintText: 'Enter member emails separated by commas...',
                    labelText: 'Member Emails',
                  ),
                ),
                TextField(
                  controller: _chatroomTopicController,
                  decoration: const InputDecoration(
                    hintText: 'Enter chatroom topic...',
                    labelText: 'Chatroom Topic',
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _createChatroom(provider),
                  child: const Text('Create Chatroom'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
