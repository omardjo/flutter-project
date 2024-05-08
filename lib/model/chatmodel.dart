import 'dart:io';

import 'package:scoped_model/scoped_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO; // Import IO from socket_io_client
import 'package:teamsyncai/model/mbot_model.dart';
import 'package:teamsyncai/model/user_model.dart';

class ChatModel extends Model { // Change ChatModel to extend Model
  late List<User> users;
  late User currentUser;
  late List<User> friendList = [];
  late List<Message> messages = [];
  late IO.Socket socketIO;
}