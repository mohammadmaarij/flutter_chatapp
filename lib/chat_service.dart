/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:otp_verification/message_model.dart';

class ChatService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _chatRoomId = "";

  Future<void> sendMessage(String receiverId, String messageText, bool isRead) async {
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserphoneNumber = _firebaseAuth.currentUser!.phoneNumber!;
    final Timestamp timestamp = Timestamp.now();

    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    _chatRoomId = ids.join("_");

    print('this is the real id--------------$_chatRoomId');

    Message newMessage = Message(
      senderId: currentUserId,
      phoneNumber: currentUserphoneNumber,
      receiverId: receiverId,
      timestamp: timestamp,
      message: messageText,
      isRead: isRead,
    );

    await _firestore
        .collection('chat_rooms')
        .doc(_chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
  }

  Stream<QuerySnapshot> getMessages(String currentUserId, String receiverUserId) {
    List<String> ids = [currentUserId, receiverUserId];
    ids.sort();
    _chatRoomId = ids.join("_");

    print("chatroomiddd isss $_chatRoomId");

    return _firestore
        .collection('chat_rooms')
        .doc(_chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  Future<void> deleteMessage(String messageId) async {
    try {
      print("collection is $_chatRoomId and message id $messageId");

      await _firestore
          .collection('chat_rooms')
          .doc(_chatRoomId)
          .collection('messages')
          .doc(messageId)
          .delete()
          .then(
            (doc) => print("Document deleted"),
        onError: (e) => print("Error updating document $e"),
      );
    } catch (e) {
      print('Error deleting message: $e');
    }
  }
}
*/
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:otp_verification/message_model.dart';

class ChatService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _chatRoomId = "";
//METHODSENDMESSAGE
  Future<void> sendMessage(String receiverId, String messageText, bool isRead) async {
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserphoneNumber = _firebaseAuth.currentUser!.phoneNumber!;
    final Timestamp timestamp = Timestamp.now();

    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    _chatRoomId = ids.join("_");

    print('this is the real id--------------$_chatRoomId');

    Message newMessage = Message(
      senderId: currentUserId,
      phoneNumber: currentUserphoneNumber,
      receiverId: receiverId,
      timestamp: timestamp,
      message: messageText,
      isRead: isRead,
    );

    await _firestore
        .collection('chat_rooms')
        .doc(_chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
  }
//METHODGETMESSAGES
  Stream<QuerySnapshot> getMessages(String currentUserId, String receiverUserId) {
    List<String> ids = [currentUserId, receiverUserId];
    ids.sort();
    _chatRoomId = ids.join("_");

    print("chatroomiddd isss $_chatRoomId");

    return _firestore
        .collection('chat_rooms')
        .doc(_chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
//METHODDELETEMESSAGES
  Future<void> deleteMessage(String messageId) async {
    try {
      print("collection is $_chatRoomId and message id $messageId");

      await _firestore
          .collection('chat_rooms')
          .doc(_chatRoomId)
          .collection('messages')
          .doc(messageId)
          .delete()
          .then(
            (doc) => print("Document deleted"),
        onError: (e) => print("Error updating document $e"),
      );
    } catch (e) {
      print('Error deleting message: $e');
    }
  }
//METHODINCMESSAGECOUNT
  Future<void> incrementMessageCount(String chatRoomId, String userId) async {
    try {
      await _firestore.collection('chat_rooms').doc(chatRoomId).set({
        'MessageCount': FieldValue.increment(1),
        '${userId}MessageCount': FieldValue.increment(1),
      }, SetOptions(merge: true));
    } catch (error) {
      print('Error incrementing message count: $error');
    }
  }
//METHODUPDATEMESSAGECOUNT
  Future<void> updateMessageCount(String chatRoomId, String userId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('chat_rooms')
          .doc(chatRoomId)
          .collection('messages')
          .get();

      await _firestore.collection('chat_rooms').doc(chatRoomId).set({
        '${userId}MessageCount': snapshot.size,
      }, SetOptions(merge: true));
    } catch (error) {
      print('Error updating message count: $error');
    }
  }
//METHODGETUNREADMESSAGECOUNT
  Future<int> getUnreadMessageCount(String chatRoomId, String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> docSnapshot =
      await _firestore.collection('chat_rooms').doc(chatRoomId).get();

      int totalMessages = docSnapshot['MessageCount'] ?? 0;
      int userMessageCount = docSnapshot['${userId}MessageCount'] ?? 0;

      return totalMessages - userMessageCount;
    } catch (error) {
      print('Error getting unread message count: $error');
      return 0;
    }
  }
}
