import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:otp_verification/chat_bubble.dart';
import 'package:otp_verification/chat_service.dart';

class ChatPage extends StatefulWidget {
  final String currentUserPhoneNumber;
  final String chatRoomId;

  const ChatPage({
    Key? key, // Fixing syntax error here
    required this.chatRoomId,
    required this.currentUserPhoneNumber,
  }) : super(key: key); // Fixing syntax error here

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late KeyboardVisibilityController _keyboardVisibilityController;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _messageController = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;


  final ChatService _chatService = ChatService();
  bool _isTyping = false;
  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      bool isRead = false; // Assuming isRead is initially set to false
      await _chatService.sendMessage(
          widget.chatRoomId, _messageController.text, isRead);
      _messageController.clear();
      _updateTypingStatus(false);
    }
  }
  Future<void> deleteChat(String receiverUserId) async {

    QuerySnapshot messagesSnapshot = await FirebaseFirestore.instance
        .collection('chat_rooms')
        .doc(receiverUserId)
        .collection('messages')
        .get();

    // ignore: unused_local_variable
    for (QueryDocumentSnapshot messageDocument in messagesSnapshot.docs)
    {
      await _chatService.deleteMessage(receiverUserId /*, messageDocument.id*/);
    }
  }


  Future<void> deleteMessage(String chatRoomId, String messageId) async {
    // await _chatService.deleteMessage(chatRoomId, messageId);
    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .doc(messageId)
        .delete();
  }

  void _updateTypingStatus(bool isTyping) async {
    try {

      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance.collection('data').get();

      if (snapshot.docs.isNotEmpty) {

        for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot in snapshot.docs) {
          // Update the "isTyping" field for each document
          await documentSnapshot.reference.update({'isTyping': isTyping});
        }
        print('Typing status updated for all documents.');
      } else {
        print('No documents found in the collection.');
      }
    } catch (e) {
      print('Error updating typing status: $e');
    }
  }

  @override
  void initState() {
    super.initState();

    _keyboardVisibilityController = KeyboardVisibilityController();
    _keyboardVisibilityController.onChange.listen((bool isVisible) {
      _updateTypingStatus(isVisible);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatRoomId),
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildMessageInput(),
          _buildTypingIndicator(), // Adding typing indicator here
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(
          widget.chatRoomId, _firebaseAuth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading..');
        }
        return ListView(
          children: snapshot.data!.docs
              .map((document) => buildMessageItem(document))
              .toList(),
        );
      },
    );
  }

  Widget buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

    if (data == null) {
      return Container(
        color: Colors.red,
      );
    }

    String senderId = data['senderId'] ?? '';
    String phoneNumber = data['phoneNumber'] ?? '';
    String message = data['message'] ?? '';

    String messageId = document.id;

    var alignment = (senderId == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: (senderId == _firebaseAuth.currentUser!.uid)
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          mainAxisAlignment: (senderId == _firebaseAuth.currentUser!.uid)
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Text(phoneNumber),
            ChatBubble(message: message),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                _chatService.deleteMessage(messageId);
                print("messageIdddddd is $messageId");
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(children: [
        Expanded(
          child: TextField(
            controller: _messageController,
            decoration: const InputDecoration(
                hintText: 'Enter Message', border: OutlineInputBorder()),
            obscureText: false,
          ),
        ),
        IconButton(
            onPressed: sendMessage,
            icon: const Icon(
              Icons.send,
              size: 40,
            )),
      ]),
    );
  }

  Widget _buildTypingIndicator() {
    return _isTyping
        ? Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Text('Typing...'),

        ],
      ),
    )
        : SizedBox();
  }
}




