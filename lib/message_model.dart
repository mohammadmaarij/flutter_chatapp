import 'package:cloud_firestore/cloud_firestore.dart';

class Message{
  final String senderId;
  final String phoneNumber;
  final String receiverId;
  final String message;
  final Timestamp timestamp;
  final bool isRead;

  Message({
    required this.senderId,
    required this.phoneNumber,
    required this.receiverId,
    required this.message,
    required this.timestamp,
    required this.isRead
  });
  Message.fromMap(Map<String, dynamic> map)
      : senderId = map['senderId'],
        phoneNumber = map['phoneNumber'],
        receiverId = map['receiverId'],
        timestamp = map['timestamp'],
        message = map['message'],
        isRead = map['isRead'];

  // Convert Message to a Map
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderEmail': phoneNumber,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp,
      'isread': isRead,
    };
  }
}

