class MessageModel {
  final String id;
  final String text;
  final String senderEmail;
  final List<String> receiverEmail; // Change to list of strings
  final String senderID;
  final String receiverID;

  MessageModel({
    required this.id,
    required this.text,
    required this.senderEmail,
    required this.receiverEmail, // Change the type to List<String>
    this.senderID = '',
    this.receiverID = '',
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    // Convert receiverEmail from dynamic to List<String>
    List<String> emailList = List<String>.from(json['receiverEmail'] ?? []);
    
    return MessageModel(
      id: json['id'],
      text: json['text'],
      senderEmail: json['senderEmail'],
      receiverEmail: emailList, // Assign the converted list
      senderID: json['senderID'] ?? '',
      receiverID: json['receiverID'] ?? '',
    );
  }
}
