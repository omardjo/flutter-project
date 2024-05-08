  class Message {
    final String id;
    final String text;
    final String senderEmail;
    final String receiverEmail;
    final String senderID; // Define senderID
    final String receiverID; // Define receiverID

    Message({
      required this.id,
      required this.text,
      required this.senderEmail,
      required this.receiverEmail,
      this.senderID = '', // Initialize senderID with an empty string
      this.receiverID = '', // Initialize receiverID with an empty string
    });
  }