import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodhub/utils/app_theme.dart';

class AppToast {
  static void toast(String info) {
    Fluttertoast.showToast(
      timeInSecForIosWeb: 1,
      msg: info,
      backgroundColor: AppTheme.PRIMARY_COLOR,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_LONG,
    );
  }
}
