import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamsyncai/model/mModel.dart' as MyMessage;
import 'package:teamsyncai/providers/chatroom_provider.dart';
import 'package:teamsyncai/model/chatroom_model.dart';
import 'package:teamsyncai/providers/userprovider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as flutter_local_notifications;
import 'package:permission_handler/permission_handler.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:teamsyncai/screens/chatscreen/chatrooms.dart';
import 'package:teamsyncai/services/gemini_service.dart';
import 'dart:async'; // Import async library for Timer

class ChatPage extends StatefulWidget {
  final ChatroomModel chatRoomModel;

  const ChatPage({Key? key, required this.chatRoomModel}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController textEditingController = TextEditingController();
  late flutter_local_notifications.FlutterLocalNotificationsPlugin
      flutterLocalNotificationsPlugin;
  late flutter_local_notifications.AndroidNotificationDetails
      androidPlatformChannelSpecifics;
  late flutter_local_notifications.NotificationDetails platformChannelSpecifics;
  List<String> suggestions = [];

  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin =
        flutter_local_notifications.FlutterLocalNotificationsPlugin();
    _initializeNotifications();
  }

  void _initializeNotifications() async {
    if (!(await Permission.notification.isGranted)) {
      await Permission.notification.request();
    }

    const flutter_local_notifications.AndroidInitializationSettings
        initializationSettingsAndroid =
        flutter_local_notifications.AndroidInitializationSettings(
            '@mipmap/ic_launcher');
    androidPlatformChannelSpecifics =
        flutter_local_notifications.AndroidNotificationDetails(
      'message_notification_channel',
      'Messages',
      importance: flutter_local_notifications.Importance.high,
      priority: flutter_local_notifications.Priority.high,
      ticker: 'ticker',
    );
    platformChannelSpecifics = flutter_local_notifications.NotificationDetails(
        android: androidPlatformChannelSpecifics);

    final flutter_local_notifications.InitializationSettings
        initializationSettings = flutter_local_notifications
            .InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _showNotification(String messageText) async {
    print('Showing notification: $messageText');

    await flutterLocalNotificationsPlugin.show(
      0,
      'New Message',
      messageText,
      platformChannelSpecifics,
    );
  }

  Future<void> _sendEmailMessage(MyMessage.MessageModel message) async {
  final smtpServer = gmail('mrdjebbi@gmail.com', 'mvgv cdic sydt pyxh');

  final messageToSend = Message()
    ..from = Address(message.senderEmail, 'TeamSynAi-Intermediary')
    ..subject = 'New Message'
    ..text =
        "Un nouvel utilisateur a envoyé un message. Veuillez consulter votre boite de messages.";

  // Add recipients
  for (String recipientEmail in message.receiverEmail) {
    messageToSend.recipients.add(Address(recipientEmail));
  }

  try {
    await send(messageToSend, smtpServer);
    print('Email sent successfully');
  } catch (e) {
    print('Failed to send email: $e');
  }
}

void _sendMessage(ChatroomProvider provider, UserProvider userProvider) async {
  String? userEmail = await userProvider.getUserEmailShared();
  List<String> receiverEmail = widget.chatRoomModel.receiverEmail;

  if (userEmail != null) {
    final String text = textEditingController.text.trim();
    if (text.isNotEmpty) {
      final MyMessage.MessageModel message = MyMessage.MessageModel(
        id: DateTime.now().toString(),
        text: text,
        senderEmail: userEmail,
        receiverEmail: receiverEmail,
        senderID: '',
        receiverID: '',
      );

      Map<String, dynamic> receiverEmails = {'receiverEmail': receiverEmail};

      String? chatID = await provider.createChatroom(
        widget.chatRoomModel.name,
        receiverEmails,
        widget.chatRoomModel.topic,
      );
      if (chatID != null) {
        provider.sendMessage(chatID, message);
      } else {
        print('Error: Failed to create chatroom');
      }

      textEditingController.clear();

      _showNotification(message.text);
      await _sendEmailMessage(message);

      // Navigate to Chatrooms interface after sending message
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Chatrooms()),
      );
    }
  } else {
    print('User email not found');
  }
}


  int previousWordCount = 0; // Variable to track previous word count

  void _updateSuggestions(String input) async {
    // Count the number of words in the input
    int currentWordCount = input.split(' ').length;

    // Check if a new word has been added
    if (currentWordCount > previousWordCount) {
      // Get message suggestions from Gemini API
      suggestions = await GeminiService.getMessageSuggestions(input);
      setState(() {}); // Trigger rebuild to update suggestions display
    }

    // Update the previous word count
    previousWordCount = currentWordCount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatRoomModel.name),
        leading: const BackButton(),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Suggestions Box
                  if (suggestions.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      color: Colors.grey[200],
                      child: Wrap(
                        spacing: 8.0,
                        runSpacing: 4.0,
                        children: suggestions.map((suggestion) {
                          return GestureDetector(
                            onTap: () {
                              // Split the current text into words
                              List<String> words =
                                  textEditingController.text.split(' ');

                              // Replace the last word with the clicked suggestion
                              words[words.length - 1] = suggestion;

                              // Join the words back into a phrase
                              String newText = words.join(' ');

                              // Update the text field
                              textEditingController.text = newText;
                            },
                            child: Chip(
                              label: Text(suggestion),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                  // Text Field for Message Input
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    color: Colors.white,
                    child: TextField(
                      controller: textEditingController,
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        border: InputBorder.none,
                      ),
                      onChanged: (text) async {
                        // Update suggestions as text changes
                        _updateSuggestions(text);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Send Button
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              _sendMessage(
                Provider.of<ChatroomProvider>(context, listen: false),
                Provider.of<UserProvider>(context, listen: false),
              );
            },
          ),
        ],
      ),
    );
  }
}
