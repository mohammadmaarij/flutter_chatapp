/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otp_verification/chat_page.dart';
import 'package:otp_verification/phone.dart';
import 'package:otp_verification/phonenumbercheckpage.dart';

class Fetch extends StatefulWidget {
  const Fetch({Key? key}) : super(key: key);

  @override
  State<Fetch> createState() => _FetchState();
}

class _FetchState extends State<Fetch> with WidgetsBindingObserver {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  int _unreadMessageCount = 0;

  @override
  void initState() {
    super.initState();
    _updateUnreadMessageCount();
  }

  void _updateUnreadMessageCount() async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('messages')
        .where('receiverId', isEqualTo: _auth.currentUser!.uid)//senderId
        .where('isRead', isEqualTo: false)
        .get();
    print('auth.currentuser is -------------------------${_auth.currentUser!.uid}');
    setState(() {
      _unreadMessageCount = snapshot.docs.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'User Lists (${_unreadMessageCount > 0 ? '$_unreadMessageCount unread' : 'No unread messages'})'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.dialog(AlertDialog(
            title: const Text('Add User'),
            content: const Text('Existing or New?'),
            actions: [
              TextButton(
                onPressed: () {
                  Get.to(PhoneNumberCheckPage());
                },
                child: const Text('EXISTING'),
              ),
              TextButton(
                onPressed: () {
                  Get.to(const Phone());
                },
                child: const Text('NEW'),
              ),
            ],
          ));
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('data').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return ListView(
            children: snapshot.data!.docs
                .map<Widget>((doc) => _buildUserListItem(doc))
                .toList(),
          );
        },
      ),
    );
  }

  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

    if (data != null && _auth.currentUser!.phoneNumber != data['phonenumber']) {
      return ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(data['phonenumber'] ?? 'No phonenumber'),
            _buildUnreadMessageCount(data['uid']),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                currentUserPhoneNumber: data['phonenumber'],
                chatRoomId: data['uid'],
              ),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }

  Widget _buildUnreadMessageCount(String userId) {
    return FutureBuilder<int>(
      future: _getUnreadMessageCount(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          int unreadCount = snapshot.data ?? 0;
          return Text('$unreadCount unread');
        }
      },
    );
  }

  Future<int> _getUnreadMessageCount(String userId) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('messages')
        .where('receiverId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .get();
    print('userid is--------------------$userId');

    return snapshot.docs.length;
  }
}*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otp_verification/chat_page.dart';
import 'package:otp_verification/phone.dart';
import 'package:otp_verification/phonenumbercheckpage.dart';
import 'package:otp_verification/chat_service.dart'; // Import your ChatService class

class Fetch extends StatefulWidget {
  const Fetch({Key? key}) : super(key: key);

  @override
  State<Fetch> createState() => _FetchState();
}

class _FetchState extends State<Fetch> with WidgetsBindingObserver {
  final ChatService _chatService = ChatService();
  final FirebaseAuth _auth = FirebaseAuth.instance;


  int _unreadMessageCount = 0;

  @override
  void initState() {
    super.initState();
    _updateUnreadMessageCount();
  }

  /*void _updateUnreadMessageCount() async {
    // Use the method from ChatService to get unread message count
    int count = await _chatService.getUnreadMessageCount(_auth.currentUser!.uid);
    setState(() {
      _unreadMessageCount = count;
    });
  }*/
  void _updateUnreadMessageCount() async {
    String currentUserId = _auth.currentUser!.uid;
    // Assuming you have access to the chatRoomId in your Fetch widget
    String chatRoomId = 'YOUR_CHAT_ROOM_ID'; // Replace with the actual chat room ID
    int count = await _chatService.getUnreadMessageCount(chatRoomId, currentUserId);
    setState(() {
      _unreadMessageCount = count;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'User Lists (${_unreadMessageCount > 0 ? '$_unreadMessageCount unread' : 'No unread messages'})'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.dialog(AlertDialog(
            title: const Text('Add User'),
            content: const Text('Existing or New?'),
            actions: [
              TextButton(
                onPressed: () {
                  Get.to(PhoneNumberCheckPage());
                },
                child: const Text('EXISTING'),
              ),
              TextButton(
                onPressed: () {
                  Get.to(const Phone());
                },
                child: const Text('NEW'),
              ),
            ],
          ));
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('data').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return ListView(
            children: snapshot.data!.docs
                .map<Widget>((doc) => _buildUserListItem(doc))
                .toList(),
          );
        },
      ),
    );
  }
  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

   // if (data != null && _auth.currentUser!.phoneNumber != data['phonenumber']) {
    if (data != null && _auth.currentUser!.phoneNumber != null && data['phonenumber'] != null && data['uid'] != null) {
      return ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(data['phonenumber'] ?? 'No phonenumber'),
            _buildUnreadMessageCount(data['chatRoomId'], data['uid']),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                currentUserPhoneNumber: data['phonenumber'],
                chatRoomId: data['uid'],
              ),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }

/*
  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

    if (data != null && _auth.currentUser!.phoneNumber != data['phonenumber']) {
      return ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(data['phonenumber'] ?? 'No phonenumber'),
            _buildUnreadMessageCount(data['uid']),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                currentUserPhoneNumber: data['phonenumber'],
                chatRoomId: data['uid'],
              ),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }*/

 /* Widget _buildUnreadMessageCount(String userId) {
    return FutureBuilder<int>(
      future: _chatService.getUnreadMessageCount(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          int unreadCount = snapshot.data ?? 0;
          return Text('$unreadCount unread');
        }
      },
    );
  }*/
  Widget _buildUnreadMessageCount(String chatRoomId, String userId) {
    return FutureBuilder<int>(
      future: _chatService.getUnreadMessageCount(chatRoomId, userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          int unreadCount = snapshot.data ?? 0;
          return Text('$unreadCount unread');
        }
      },
    );
  }
}