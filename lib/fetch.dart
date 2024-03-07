/*import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
/*
class AuthenticatedUsersWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<User>>(
      future: _getAuthenticatedUsers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          if (snapshot.hasData) {
            List<User> users = snapshot.data!;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                User user = users[index];
                return ListTile(
                  title: Text('ID: ${user.uid}'),
                  subtitle: Text('Email: ${user.email}'),
                );
              },
            );
          } else {
            return Text('No authenticated users');
          }
        }
      },
    );
  }*/

  Future<List<User>> _getAuthenticatedUsers() async {
    List<User> authenticatedUsers = [];

    try {
      List<UserCredential> userCredentials = (await FirebaseAuth.instance
          .fetchSignInMethodsForEmail('abc@gmail.com')).cast<UserCredential>(); // Provide any email here

      for (UserCredential userCredential in userCredentials) {
        User user = userCredential.user!;
        authenticatedUsers.add(user);
      }
    } catch (e) {
      print('Error fetching authenticated users: $e');
    }

    return authenticatedUsers;
  }
}
*/