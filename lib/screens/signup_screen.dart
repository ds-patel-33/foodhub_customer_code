import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodhub/providers/email_sign_in_provider.dart';
import 'package:foodhub/screens/loader_layout_widget.dart';
import 'package:foodhub/screens/signin_screen.dart';
import 'package:provider/provider.dart';

import '../variables/images.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  bool obscurePassWord = true;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            const Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget _entryField(String title,
      {bool isPassword = false,
      List<TextInputFormatter>? inputFormatters,
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
              inputFormatters: inputFormatters ?? [],
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
          await Provider.of<EmailSignInProvider>(context, listen: false)
              .signUpWithEmail(
                  context: context,
                  name: _nameController.text.toLowerCase(),
                  email: _emailController.text.toLowerCase(),
                  password: _passwordController.text.toLowerCase(),
                  phoneNumber: _phoneNumberController.text);
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
              "Register Now",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            )),
          )),
        ],
      ),
    );
  }

  Widget _loginAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SigninScreen()));
      },
      child: Container(
        margin: EdgeInsets.only(top: 10, bottom: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Already have an account ?',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Login',
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
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'Food',
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).primaryColor),
          children: [
            TextSpan(
              text: ' Hub',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
          ]),
    );
  }

  Widget _allFieldsWidget() {
    return Column(
      children: <Widget>[
        _entryField("Name", controller: _nameController, validator: (text) {
          if (text!.isEmpty) {
            return "Name is empty!";
          }
        }),
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
          } else if (text.length <= 6) {
            return "Password must contains more than 6 characters!";
          }
        }),
        _entryField("Confirm Password",
            controller: _confirmPasswordController,
            isPassword: true, validator: (text) {
          if (text!.isEmpty) {
            return "Confirm password is empty!";
          } else if (_passwordController.text !=
              _confirmPasswordController.text) {
            return "Password and confirm password isn't same!";
          }
        }),
        _entryField("Phone Number",
            inputFormatters: [
              LengthLimitingTextInputFormatter(10),
            ],
            controller: _phoneNumberController, validator: (text) {
          if (text!.isEmpty) {
            return "Phone Number is empty!";
          } else if (text.length != 10) {
            return "Please entere valid phone number";
          }
        }, textInputType: TextInputType.number),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    isLoading =
        Provider.of<EmailSignInProvider>(context, listen: true).isLoading;
    return Stack(
      children: [
        Scaffold(
          resizeToAvoidBottomInset: true,
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      height: height,
                      child: Stack(
                        children: <Widget>[
                          topLeftSideImage(),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(height: height * .14),
                                  _title(),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  _allFieldsWidget(),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  _submitButton(),
                                  _loginAccountLabel(),
                                ],
                              ),
                            ),
                          ),
                          // Positioned(top: 40, left: 0, child: _backButton()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (isLoading) LoaderLayoutWidget()
      ],
    );
  }

  Widget topLeftSideImage() {
    return Container(
      height: MediaQuery.of(context).size.height / 7,
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
