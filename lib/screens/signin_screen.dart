import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:foodhub/providers/email_sign_in_provider.dart';
import 'package:foodhub/screens/loader_layout_widget.dart';
import 'package:foodhub/screens/signup_screen.dart';
import 'package:provider/provider.dart';

import '../variables/images.dart';

class SigninScreen extends StatefulWidget {
  SigninScreen({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool obscurePassWord = true;
  bool isLoading = false;

  Widget _entryField(String title,
      {bool isPassword = false,
      TextInputType? textInputType,
      FormFieldValidator<String>? validator,
      TextEditingController? controller}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
              obscureText: isPassword,
              keyboardType: textInputType ?? null,
              controller: controller,
              validator: validator ?? null,
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () async {
        if (_formKey.currentState!.validate()) {
          FocusScope.of(context).unfocus();
          await Provider.of<EmailSignInProvider>(context, listen: false)
              .signInWithEmail(
                  context: context,
                  email: _emailController.text.toLowerCase(),
                  password: _passwordController.text.toLowerCase());
        }
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
            child: const Center(
                child: Text(
              "SIGN IN",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            )),
          )),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: const <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('or'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignUpScreen()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Don\'t have an account ?',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Register',
              style: TextStyle(
                  color: Theme.of(context).primaryColorDark,
                  fontSize: 15,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return Container(
      // color: Colors.red,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
            text: 'Food',
            style: TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).primaryColor),
            children: [
              TextSpan(
                text: ' Hub',
                style: TextStyle(color: Colors.black, fontSize: 38),
              ),
              // TextSpan(
              //   text: 'rnz',
              //   style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
              // ),
            ]),
      ),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("Email id", controller: _emailController,
            validator: (text) {
          if (text!.isEmpty) {
            return "Email is empty!";
          } else if (!EmailValidator.validate(text)) {
            return "Enter valid email!";
          }
        }),
        _entryField("Password",
            controller: _passwordController,
            isPassword: true, validator: (text) {
          if (text!.isEmpty) {
            return "Password is empty!";
          }
        }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    isLoading =
        Provider.of<EmailSignInProvider>(context, listen: true).isLoading;
    final height = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Scaffold(
            body: Container(
          height: height,
          child: Stack(
            children: <Widget>[
              topLeftSideImage(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 28.0),
                        //   child: topLeftSideImage(),
                        // ),
                        SizedBox(height: height * .23),
                        _title(),
                        SizedBox(height: 50),
                        _emailPasswordWidget(),
                        SizedBox(height: 20),
                        _submitButton(),
                        _divider(),
                        const SizedBox(height: 10),
                        _createAccountLabel(),
                        termsAndConditions(),
                      ],
                    ),
                  ),
                ),
              ),
              // Positioned(top: 40, left: 0, child: _backButton()),
            ],
          ),
        )),
        if (isLoading) LoaderLayoutWidget()
      ],
    );
  }

  Widget termsAndConditions() {
    return Row(
      children: [
        Expanded(
            child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    style: const TextStyle(color: Colors.black, height: 1.4),
                    text: "By Signing in you are agree to Food Hub",
                    children: [
                      TextSpan(
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              height: 1.4),
                          text: "Terms and\nServices , Privercy Police,"),
                      const TextSpan(
                          style: TextStyle(color: Colors.black, height: 1.4),
                          text: " and "),
                      TextSpan(
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              height: 1.4),
                          text: "Content Policty")
                    ])))
      ],
    );
  }

  Widget topLeftSideImage() {
    return Container(
      height: MediaQuery.of(context).size.height / 5,
      width: double.infinity,
      child: Row(
        children: [
          Expanded(child: Container()),
          Expanded(child: Container()),
          Expanded(
              child: Image.asset(
            Images.SIGNIN_DESIGN,
            width: double.infinity,
          ))
        ],
      ),
    );
  }
}
