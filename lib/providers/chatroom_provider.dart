import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teamsyncai/model/chatroom_model.dart';
import 'package:teamsyncai/model/mbot_model.dart';
import 'package:teamsyncai/model/user_model.dart';
import 'package:teamsyncai/services/chatroom_service.dart';
import 'package:teamsyncai/model/mModel.dart';


class ChatroomProvider extends ChangeNotifier {
  final ChatroomService _service = ChatroomService();

  List<ChatroomModel> _chatrooms = [];
  List<User> _friendList = [];
  String? _receiverEmail; // Instance variable for receiver email
  late SharedPreferences _prefs; // Instance variable for shared preferences
  ChatroomModel? _currentChatroom;
  List<ChatroomModel> _chatroomsWithTopics = []; // List to hold chatrooms filtered by topics

  List<ChatroomModel> get chatroomsWithTopics => _chatroomsWithTopics; // Getter for chatrooms with topics

  late String _userEmail; // Instance variable for user email
  List<ChatroomModel> get chatrooms => _chatrooms;
  List<User> get friendList => _friendList;

  void setCurrentChatroom(ChatroomModel chatroom) {
    _currentChatroom = chatroom;
    notifyListeners();
  }

  Future<void> saveUserEmail(String email) async {
    _userEmail = email;
    await _prefs.setString('userEmail', email); // Save user email to shared preferences
  }

  void init() {
    _chatrooms.clear(); // Ensure chatrooms list is empty during initialization
    // Any other initialization logic can go here
  }

  Future<void> initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _userEmail = _prefs.getString('userEmail') ?? ''; // Fetch user email from shared preferences
  }

  Future<String?> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userEmail');
  }
    Future<String?> getReceiverEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('receiverEmail');
  }
  


Future<List<ChatroomModel>> fetchChatrooms() async {
  try {
    final userEmail = await getUserEmail(); // Await the Future to get the actual email string
    if (userEmail != null) {
      _chatrooms = await _service.getChatrooms(userEmail); // Fetch chatrooms for the current user
      print('Fetched ${_chatrooms.length} chatrooms');
      notifyListeners(); // Notify listeners after updating the chatrooms list
      return _chatrooms; // Return the fetched chatrooms
    } else {
      // Handle the case where userEmail is null
      print('User email is null');
      return []; // Return empty list
    }
  } catch (e) {
    print('Error fetching chatrooms: $e');
    return []; // Return empty list on error
  }
}






 Future<String?> createChatroom(String name, Map<String, dynamic> receiverEmails, String topic) async {
  String? chatID;
  String? userEmail = await getUserEmail();
  if (userEmail != null) {
    List<MessageModel> messages = []; // Initialize messages as an empty list
    try {
      chatID = await _service.createChatroom(
        name,
        userEmail,
        receiverEmails['receiverEmail'], // Pass receiverEmail directly
        topic, // Include the topic parameter
      );
      if (chatID != null) {
        // Store the chatID in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('chatID', chatID);
        // Save the topic locally
        await prefs.setString('chatroomTopic', topic);
        // Call saveUserEmail here
        await saveUserEmail(userEmail);
        await fetchChatrooms();
      } else {
        print('ChatID not received from the server');
      }
    } catch (e) {
      print('Error creating chatroom: $e');
    }
  } else {
    print('User email not found');
  }
  return chatID;
}
Future<void> deleteChatroom(String chatroomId) async {
  try {
    await _service.deleteChatroom(chatroomId);
    await fetchChatrooms(); // Refresh chatrooms after deletion
  } catch (e) {
    print('Error deleting chatroom: $e');
  }
}

Future<List<MessageModel>> getMessagesForChatroomId(String chatroomId) async {
  try {
    // Fetch messages for the specified chatroomId
    return await _service.getMessagesForChatID(chatroomId); // Use the provided chatroomId
  } catch (e) {
    print('Error fetching messages: $e');
    return []; // Return an empty list on error
  }
}

  Future<String?> getLocalChatroomTopic() async {
    return _prefs.getString('chatroomTopic');
  }

Future<List<MessageModel>> getMessagesForChatID(String chatID) async {
  return await _service.getMessagesForChatID(chatID);
}

Future<void> saveChatroomId(String chatroomId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('chatroomId', chatroomId);
}

Future<String?> getChatroomId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('chatroomId');
}

void sendMessage(String chatroomId, MessageModel message) async {
  try {
    // Send message to backend server
    await _service.sendMessage(chatroomId, message); // Use the provided chatroomId
    notifyListeners();
  } catch (e) {
    print('Error sending message: $e');
  }
}



  

  void filterChatroomsByTopics() async {
    String? topic = await getLocalChatroomTopic();
    if (topic != null) {
      _chatroomsWithTopics = _chatrooms.where((chatroom) => chatroom.topic == topic).toList();
      notifyListeners(); // Notify listeners after filtering
    }
  }
}
