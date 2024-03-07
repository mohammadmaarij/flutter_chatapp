import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:otp_verification/chat_page.dart';

class PhoneNumberCheckPage extends StatefulWidget {
  @override
  _PhoneNumberCheckPageState createState() => _PhoneNumberCheckPageState();
}

class _PhoneNumberCheckPageState extends State<PhoneNumberCheckPage> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _checkPhoneNumberAndNavigate() async {
    String phoneNumber = _phoneNumberController.text.trim();

    // Check if the entered phone number exists in Firestore
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
        .collection('data')
        .where('phonenumber', isEqualTo: phoneNumber)
        .get();

    if (snapshot.docs.isNotEmpty) {
      // Phone number exists, navigate to chat page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatPage(
            currentUserPhoneNumber: _auth.currentUser!.phoneNumber!, chatRoomId: '',
            // Pass additional parameters as needed
          ),
        ),
      );
    } else {
      // Phone number doesn't exist, show dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Number Not Found'),
          content: const Text('The entered phone number does not exist.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check Phone Number'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _phoneNumberController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Enter Phone Number',
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _checkPhoneNumberAndNavigate,
              child: const Text('Check and Navigate'),
            ),
          ],
        ),
      ),
    );
  }
}
