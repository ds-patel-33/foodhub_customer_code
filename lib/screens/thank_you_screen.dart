import 'package:flutter/material.dart';
import 'package:foodhub/screens/screen_container.dart';

import '../variables/images.dart';

class ThankYouScreen extends StatefulWidget {
  const ThankYouScreen({Key? key}) : super(key: key);

  @override
  _ThankYouScreenState createState() => _ThankYouScreenState();
}

class _ThankYouScreenState extends State<ThankYouScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Image.asset(Images.DONE),
              Text(
                "Thank you for your order",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xff0B2E40),
                  fontSize: 30,
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Text(
                "You can track your delivery in the\n 'My Order' sections",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Color(0xff0B2E40)),
              ),
              SizedBox(
                height: 40,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ScreenContainer(
                                selectedIndex: 1,
                              )));
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Theme.of(context).primaryColor),
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15.0,
                      ),
                      child: Center(
                          child: Text("TRACK MY ORDER",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700)))),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ScreenContainer()));
                },
                child: Text(
                  "Order Something else",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Color(0xff0B2E40)),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
