import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:otp_verification/phone.dart';
import 'package:pinput/pinput.dart';

class OTP extends StatefulWidget {
  const OTP({Key? key}) : super(key: key);

  @override
  State<OTP> createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  final FirebaseAuth auth = FirebaseAuth.instance;
 // final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore =FirebaseFirestore.instance;
  String code = "";

  Future<void> saveUserData(String uid, String phoneNumber) async {
    try {
      // Get a reference to the Firestore collection
      CollectionReference dataCollection =
          FirebaseFirestore.instance.collection('data');

      // Add a new document with a unique ID
      await dataCollection.add({
        'uid': uid,
        'phonenumber':phoneNumber,
        'timestamp': FieldValue.serverTimestamp(),
        // Optionally add a timestamp
      });

      print('User data saved to Firestore.');
    } catch (error) {
      print('Error saving user data: $error');
      // Handle the error as needed
    }
  }

  @override

  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(10, 239, 600, 91)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const Text('Enter OTP:'),
            Center(
              child: Pinput(
                pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                showCursor: true,
                length: 6,
                onCompleted: (pin) {
                  setState(() {
                    code = pin;
                  });
                },
                onChanged: (value) {
                  code = value;
                },
              ),
            ),
        ElevatedButton(
          onPressed: () async {
            try {
              PhoneAuthCredential credential = PhoneAuthProvider.credential(
                  verificationId: Phone.verify, smsCode: code);
              UserCredential userCredential =
              await auth.signInWithCredential(credential);
              User? user = userCredential.user;
              if (user != null) {
              //  String uid = user.uid;
                String phoneNumber = user.phoneNumber ?? '';
                String uid = userCredential.user?.uid ?? '';// Retrieve phone number
                print("Logged in with UID: $uid");
                print("Phone number: $phoneNumber");
                saveUserData(uid, phoneNumber);
                // Perform further actions with user data if needed
              } else {
                print("User is null");
              }
            } catch (error) {
              print("Error: $error");
            }
          },
          child: const Text('Submit OTP'),
        ),

          ],
        ),
      ),
    );
  }
}
/*ElevatedButton(
              onPressed: () async {
                try {
                  PhoneAuthCredential credential = PhoneAuthProvider.credential(
                      verificationId: Phone.verify, smsCode: code);
                  UserCredential userCredential =
                      await auth.signInWithCredential(credential);
                  String uid = userCredential.user?.uid ?? '';

                  print("Logged in with UID-----: $uid");
                  saveUserData(uid);
                  // Perform further actions with user data if needed
                } catch (error) {
                  print("Error: $error");
                }
              },
              child: const Text('Submit OTP'),
            ),*/