import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodhub/models/user_model.dart';
import 'package:foodhub/providers/user_provider.dart';
import 'package:foodhub/screens/screen_container.dart';
import 'package:foodhub/screens/signin_screen.dart';
import 'package:foodhub/services/storage_methods.dart';
import 'package:foodhub/utils/app_toast.dart';
import 'package:foodhub/variables/text_config.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices {
  static FirebaseAuth _auth = FirebaseAuth.instance;

  static final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection(TextConfig.USERS_COLLECTION);

  final StorageMethods _storageMethods = StorageMethods();

  Future<void> signIn({
    required BuildContext context,
  }) async {
    QuerySnapshot result = await _usersCollection
        .where('user_id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    List<DocumentSnapshot> documents = result.docs;
    if (documents.length > 0) {
      print("User already registered!");
      Map<String, dynamic> data =
          documents.first.data() as Map<String, dynamic>;

      UserModel user = UserModel.fromJson(data);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => ScreenContainer()));
    } else {
      print("User isn't registered!");
      AppToast.toast("Something went wrong , try it again!");
    }
  }

  Future<void> addUserToDatabase(
      {required BuildContext context,
      required User user,
      required String password,
      required String phoneNumber,
      required String name}) async {
    if (true) {
      UserModel user = UserModel(
          userId: FirebaseAuth.instance.currentUser!.uid,
          userName: name,
          userEmail: FirebaseAuth.instance.currentUser!.email ?? "",
          userPhoneNumber: phoneNumber,
          userMemberId: phoneNumber,
          deviceToken: "",
          userImage: "",
          userPassword: password,
          addedOn: DateTime.now().microsecondsSinceEpoch.toString());

      await _usersCollection
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set(user.toJson())
          .then((value) {
        print("User Added To Database!");
      }).then((value) async {
        Provider.of<UserProvider>(context, listen: false)
            .setUserToProvider(currentUser: user);
        SharedPreferences _preferences = await SharedPreferences.getInstance();
        await _preferences.setString('user', jsonEncode(user.toJson()));

        Provider.of<UserProvider>(context, listen: false)
            .setUserToProvider(currentUser: user);
        AppToast.toast("Registration Successful!");
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SigninScreen()));
      });
    }
  }
}
