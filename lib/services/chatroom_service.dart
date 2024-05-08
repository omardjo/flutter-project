import 'dart:convert'; // for json.decode
import 'package:http/http.dart' as http; // for http requests
import 'package:teamsyncai/model/chatroom_model.dart';
import 'package:teamsyncai/model/user_model.dart';
import 'package:teamsyncai/model/mModel.dart'; // Import Message model
import 'package:shared_preferences/shared_preferences.dart'; // for SharedPreferences

class ChatroomService {
  List<User> users = []; // Initialize an empty list of users
  User currentUser = const User.empty(); // Use User.empty() to initialize currentUser
  List<User> friendList = [];
  List<MessageModel> messages = [];

Future<List<ChatroomModel>> getChatrooms(String userEmail) async {
  print('Fetching chatrooms for user: $userEmail');
  // Mocking API response, replace with actual API call
  String apiUrl = 'https://backend-2-le95.onrender.com/chatrooms/get?userEmail=$userEmail&receiverEmail'; // Pass userEmail as a query parameter
  var response = await http.get(Uri.parse(apiUrl));

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    List<ChatroomModel> chatrooms =
        data.map((item) => ChatroomModel.fromJson(item)).toList();
    return chatrooms;
  } else {
    throw Exception('Failed to load chatrooms');
  }
}

Future<ChatroomModel> getChatroomById(String chatroomId) async {
  try {
    String apiUrl = 'https://backend-2-le95.onrender.com/chatrooms/$chatroomId';
    var response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      ChatroomModel chatroom = ChatroomModel.fromJson(data);
      return chatroom;
    } else {
      throw Exception('Failed to load chatroom');
    }
  } catch (e) {
    print('Error fetching chatroom: $e');
    rethrow; // Rethrow the error to handle it in the calling code
  }
}



Future<void> deleteChatroom(String chatroomId) async {
  try {
    String apiUrl = 'https://backend-2-le95.onrender.com/chatrooms/delete?chatroomId=$chatroomId';
    var response = await http.delete(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      print('Chatroom deleted successfully');
    } else {
      throw Exception('Failed to delete chatroom');
    }
  } catch (e) {
    print('Error deleting chatroom: $e');
  }
}



Future<String?> createChatroom(
  String name,
  String userEmail,
  List<String> receiverEmails,
  String topic, // Add topic parameter
) async {
  try {
    String apiUrl = 'https://backend-2-le95.onrender.com/chatrooms/create';
    var body = json.encode({
      'name': name,
      'userEmail': userEmail,
      'receiverEmail': receiverEmails,
      'topic': topic, // Include the topic field
    });
    var headers = {'Content-Type': 'application/json'};

    var response = await http.post(Uri.parse(apiUrl), body: body, headers: headers);

    if (response.statusCode == 201) {
      Map<String, dynamic> responseData = json.decode(response.body);
      String? chatID = responseData['_id'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('chatID', chatID ?? '');

      print('Chatroom created successfully with ID: $chatID');
      
      return chatID; // Return the chatID
    } else {
      throw Exception('Failed to create chatroom');
    }
  } catch (e) {
    print('Error creating chatroom: $e');
    return null;
  }
}



  Future<void> sendMessage(String chatroomId, MessageModel message) async {
  try {
    // Send message to backend server
    final response = await http.post(
      Uri.parse('https://backend-2-le95.onrender.com/messages/sendMessageBasedOnRole?chatroomId=$chatroomId'), // Include chatroomId in the URL
      body: jsonEncode({
        'senderEmail': message.senderEmail,
        'receiverEmail': message.receiverEmail,
        'text': message.text,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      // Message sent successfully
      print('Message sent successfully');
    } else {
      // Error sending message
      print('Error sending message: ${response.statusCode}');
    }
  } catch (e) {
    print('Error sending message: $e');
  }
}


Future<List<MessageModel>> getMessagesForChatID(String chatID) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String chatID = prefs.getString('chatID') ?? ''; // Retrieve chatID from SharedPreferences

  return messages
      .where((msg) =>
          msg.senderID == chatID || msg.receiverID == chatID)
      .toList();
}

}
