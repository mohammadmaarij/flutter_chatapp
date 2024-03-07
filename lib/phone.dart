import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:otp_verification/otp_page.dart';


class Phone extends StatefulWidget {
  const Phone({Key? key}) : super(key: key);

  static String verify ="";

  @override
  State<Phone> createState() => _PhoneState();
}

class _PhoneState extends State<Phone> {
  TextEditingController countrycode = TextEditingController();
  var phone="";
  @override
  void initState() {
    countrycode.text = "+92";
    super.initState();
  }
@override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Center(
            child: Column(

              children: [
                const SizedBox(
                  height: 50,
                ),
                const Text('js xjs x'),
                Container(
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: 40,
                        child: TextField(
                          controller: countrycode,
                          decoration: const InputDecoration(border: InputBorder.none),
                        ),
                      ),
                      const Text(
                        '|',
                        style: TextStyle(fontSize: 25),
                      ),
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.phone,
                          onChanged: (value){
                            phone=value;
                          },
                          decoration: const InputDecoration(
                              border: InputBorder.none, hintText: 'Phone'),
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.verifyPhoneNumber(
                        phoneNumber: '${countrycode.text+phone}',
                        verificationCompleted: (PhoneAuthCredential credential) {},
                        verificationFailed: (FirebaseAuthException e) {},
                        codeSent: (String verificationId, int? resendToken) {
                          Phone.verify=verificationId;
                         // Navigator.pushNamed(context, "OTP");
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> const OTP()));
                        },
                        codeAutoRetrievalTimeout: (String verificationId) {},
                      );
                    //  Navigator.push(context, MaterialPageRoute(builder: (context)=> const OTP()));
                    },
                    child: const Text('Submit')),
              ],
            ),
          )),
    );
  }
}