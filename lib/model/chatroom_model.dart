import 'package:teamsyncai/model/message_model.dart';

class ChatroomModel {
  final String chatID;
  final String name;
  final String userEmail;
  final List<String> receiverEmail; // Change type to List<String>
  final String topic;
  final List<String> messagetext; // Change type to List<String>
  final DateTime createdAt;

  ChatroomModel({
    this.chatID = '',
    required this.name,
    required this.userEmail,
    required this.receiverEmail,
    required this.topic,
    required this.messagetext,
    required this.createdAt,
  });

  factory ChatroomModel.fromJson(Map<String, dynamic> json) {
    // Parse messages from JSON
    List<String> messagesText = [];
    if (json['messages'] != null && json['messages'] is List) {
      messagesText = List<String>.from(json['messages'].map(
        (messageJson) => messageJson['text'].toString(),
      ));
    }

    return ChatroomModel(
      chatID: json['_id'] ?? '',
      name: json['name'] ?? '', // Handle potential null value
      userEmail: json['userEmail'] ?? '', // Handle potential null value
      receiverEmail: List<String>.from(json['receiverEmail'] ?? []),
      topic: json['topic'] ?? '', // Handle potential null value
      messagetext: messagesText,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }
}
