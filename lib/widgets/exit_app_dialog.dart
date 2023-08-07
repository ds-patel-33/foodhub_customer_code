import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/signin_screen.dart';

exitAppDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        'Do you want to exit application?',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      actions: <Widget>[
        GestureDetector(
          onTap: () {
            print("you choose no");
            Navigator.of(context).pop(false);
          },
          child: Container(
            width: 60,
            height: 30,
            color: Theme.of(context).primaryColor,
            child: Center(
              child: Text(
                'No',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        GestureDetector(
          onTap: () async {
            FirebaseAuth.instance.signOut().then((value) {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => SigninScreen()),
                  (route) => false);
            });
          },
          child: Container(
            width: 60,
            height: 30,
            color: Theme.of(context).primaryColor,
            child: Center(
              child: Text(
                'Yes',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
