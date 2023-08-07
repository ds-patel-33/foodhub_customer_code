import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodhub/services/auth_services.dart';

import '../utils/app_toast.dart';
import '../utils/check_connectivity.dart';

class EmailSignInProvider extends ChangeNotifier {
  final AuthServices _authServices = AuthServices();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserCredential? _userCredential;

  bool isLoading = false;

  bool get loaderStatus => isLoading;

  User? _user;

  User? get use => _user;

  setLoaderStatus(bool status) {
    isLoading = status;
    notifyListeners();
  }

  Future<void> signUpWithEmail(
      {required BuildContext context,
      required String name,
      required String email,
      required String phoneNumber,
      required String password}) async {
    setLoaderStatus(true);
    bool internetStatus = await CheckConnectivity.connectivity();
    if (internetStatus) {
      try {
        print("Sign up with email is called!");
        _userCredential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        print('_userCredential : => $_userCredential');
        if (_userCredential == null) {
          setLoaderStatus(false);
          AppToast.toast("Something went wrong!");
        } else if (_userCredential!.user != null) {
          _user = _userCredential!.user;

          await _authServices
              .addUserToDatabase(
                  context: context,
                  password: password,
                  user: _user!,
                  name: name,
                  phoneNumber: phoneNumber)
              .then((value) {
            setLoaderStatus(false);
            return;
          }).catchError((e) {
            print('CREATE USER ERROR :$e');
          });
          setLoaderStatus(false);
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          setLoaderStatus(false);
          AppToast.toast("This email is already registered!");
        } else {
          setLoaderStatus(false);
          AppToast.toast(e.toString());
          print('CATCH CREATE USER ERROR :${e.message}');

          print(e.message);
          throw e;
        }
      }
      notifyListeners();
    }
    setLoaderStatus(false);
  }

  Future<void> signInWithEmail(
      {required BuildContext context,
      required String email,
      required String password}) async {
    setLoaderStatus(true);
    bool internetStatus = await CheckConnectivity.connectivity();
    if (internetStatus) {
      try {
        await FirebaseAuth.instance.signOut();
        print("Sign out done !");
        _userCredential = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        if (_userCredential != null) {
          _user = _userCredential!.user;
          await _authServices.signIn(context: context).then((value) {
            setLoaderStatus(false);
          });
        } else {
          setLoaderStatus(false);
          AppToast.toast("Authentication Failed!");
          return;
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          setLoaderStatus(false);
          AppToast.toast("This email is not registered, please sign up!");
        } else if (e.code == "wrong-password") {
          setLoaderStatus(false);
          AppToast.toast("Invalid password!");
        } else {
          print(e.code);
          AppToast.toast("Multiple requests , Try After some time!");
        }
      }
      notifyListeners();
    }
    setLoaderStatus(false);
  }
}
