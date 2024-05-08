/*import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/foundation.dart'; // Import foundation.dart for ChangeNotifier
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:convert';

import '../model/user_model.dart';
import '../model/message_model.dart';

class ChatModel extends Model { // Change ChatModel to extend Model
  late List<User> users;
  late User currentUser;
  late List<User> friendList = [];
  late List<Message> messages = [];
  late IO.Socket socketIO;

  ChatModel(this.users, this.currentUser) {
    init();
  }

  void init() {
    friendList = users.where((user) => user != currentUser).toList();

    socketIO = IO.io(
      'http://172.16.3.158:3000/send_message',
      IO.OptionBuilder()
        .setTransports(['websocket']) // Use websockets
        .disableAutoConnect() // Disable auto-connection
        .build(),
    );

    // Socket connection events
    socketIO.onConnect((_) => print('Connected'));
    socketIO.onDisconnect((_) => print('Disconnected'));
    socketIO.onError((_) => print('Error'));
    socketIO.onConnecting((_) => print('Connecting'));
    socketIO.onConnectError((_) => print('Connect Error'));
    socketIO.onConnectTimeout((_) => print('Connect Timeout'));

    // Event received from server
    socketIO.on('receive_message', (jsonData) {
      Map<String, dynamic> data = json.decode(jsonData);
      messages.add(Message(data['content'], data['senderChatID'], data['receiverChatID']));
      notifyListeners();
    });

    socketIO.connect();
  }

  void sendMessage(String text, String receiverChatID) {
    messages.add(Message(text, currentUser as String, receiverChatID));
    socketIO.emit(
      'send_message',
      json.encode({
        'receiverChatID': receiverChatID,
        'senderChatID': currentUser,
        'content': text,
      }),
    );
    notifyListeners();
  }

  List<Message> getMessagesForChatID(String chatID) {
    return messages
        .where((msg) => msg.senderID == chatID || msg.receiverID == chatID)
        .toList();
  }

  void disposeSocket() {
    socketIO.disconnect();
    socketIO.dispose();
  }
}
*/