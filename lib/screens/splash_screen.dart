import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:flutter/material.dart';
import 'package:foodhub/models/user_model.dart';
import 'package:foodhub/providers/user_provider.dart';
import 'package:foodhub/screens/screen_container.dart';
import 'package:foodhub/screens/signin_screen.dart';
import 'package:foodhub/variables/images.dart';
import 'package:foodhub/variables/text_config.dart';
import 'package:foodhub/widgets/loders/small_loader.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(Duration(seconds: 3), () async {
      Auth.User? currentUser = Auth.FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => SigninScreen()));
      } else {
        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
            .collection(TextConfig.USERS_COLLECTION)
            .doc(currentUser.uid)
            .get();
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        UserModel user = UserModel.fromJson(data);
        await Provider.of<UserProvider>(context, listen: false)
            .setUserToProvider(currentUser: user);
        await Provider.of<UserProvider>(context, listen: false).setCategories();

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => ScreenContainer()));
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Expanded(
              child: Stack(children: [
                Container(
                  color: Color(0xff67C117),
                ),
                Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                              Images.SPALSH_SCREEN_DESIGN,
                            ),
                            fit: BoxFit.cover))),
                Center(
                  child: Container(
                      // height: MediaQuery.of(context).size.height / 5,
                      // width: MediaQuery.of(context).size.width / 2,
                      child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RichText(
                          text: TextSpan(
                              text: "FoodHub",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 42))),
                      SizedBox(
                        height: 30,
                      ),
                      smallLoader(context: context, color: Colors.white)
                    ],
                  )),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
