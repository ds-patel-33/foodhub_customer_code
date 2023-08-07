import 'dart:io';

import 'package:foodhub/utils/app_toast.dart';

class CheckConnectivity {
  static Future<bool> connectivity() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        print("Please check your internet connectivity!");
        AppToast.toast("Please check your internet connectivity!");
        return false;
      }
    } on SocketException catch (e) {
      AppToast.toast("Please check your internet connectivity!");
      print("No Internet !");
      return false;
    }
  }
}
