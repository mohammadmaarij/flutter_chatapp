import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otp_verification/fetch.dart';
import 'package:otp_verification/fetch_authenticated_user_ids.dart';
import 'package:otp_verification/otp_page.dart';
import 'package:otp_verification/phone.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:otp_verification/phonenumbercheckpage.dart';

import 'firebase_options.dart';

/*void main() => runApp(MyApp());*/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );// Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Fetch(),//6618 is login

    );
  }
}
