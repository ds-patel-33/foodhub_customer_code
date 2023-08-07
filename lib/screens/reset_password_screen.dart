import 'package:flutter/material.dart';
import 'package:foodhub/variables/images.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40)),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              gradient: LinearGradient(
                                  colors: [
                                    Color(0xff80ED20),
                                    Color(0xffA2EA62),
                                    Color(0xff84DE35),
                                    Color(0xff75D024),
                                    Color(0xff67C117),
                                  ],
                                  end: Alignment.centerRight,
                                  begin: Alignment.centerLeft)),
                          child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: 40,
                              child: Image.asset(
                                Images.CONFIRM_PASSWORD_LOGO,
                                width: 45,
                                height: 45,
                              )),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text(
                        "Enter Your New\nPassword",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w700),
                      ),
                    )
                  ],
                )),
            Expanded(
                flex: 3,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "New Password",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      TextField(
                        style: TextStyle(fontSize: 16),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 6.0),
                          isDense: true,
                          prefixIconConstraints:
                              BoxConstraints(minWidth: 30, maxHeight: 20),
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            size: 18,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Confirm new Password",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      TextField(
                        style: TextStyle(fontSize: 16),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 6.0),
                          isDense: true,
                          prefixIconConstraints:
                              BoxConstraints(minWidth: 30, maxHeight: 20),
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            size: 18,
                          ),
                        ),
                      ),
                    ])),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    child: Row(
                      children: [
                        Expanded(
                            child: Container(
                          height: 45,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(30)),
                          child: Center(
                              child: Text(
                            "VERIFY",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
