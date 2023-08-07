import 'package:flutter/material.dart';
import 'package:foodhub/variables/images.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
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
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
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
                                Images.EMAIL_LOGO,
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
                        "Enter your Email",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w700),
                      ),
                    )
                  ],
                )),
            Expanded(
                flex: 3,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Email",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                                fontWeight: FontWeight.w400),
                          )),
                      TextField(
                        style: TextStyle(fontSize: 16),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 6.0, horizontal: 20),
                          isDense: true,
                          prefixIconConstraints:
                              BoxConstraints(minWidth: 30, maxHeight: 20),
                          prefixIcon: Icon(
                            Icons.mail_outline,
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
                    onTap: () {
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) => OtpScreen()));
                    },
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
