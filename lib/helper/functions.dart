import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';

import '../variables/enums.dart';

class Functions {
  static Future<String?> getDeviceId() async {
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    String? device_id;

    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        print("Android ID : " + build.androidId);
        device_id = build.androidId;
      } else if (Platform.isIOS) {
        var build = await deviceInfoPlugin.iosInfo;
        print("Apple ID : " + build.identifierForVendor);
        device_id = build.identifierForVendor;
      }
      return device_id!;
    } on PlatformException {
      print("Platform version cannot be found");
    }
  }

  static PaymentMethod getPaymentMethod({required int method}) {
    if (method == 0) {
      return PaymentMethod.payLater;
    } else {
      return PaymentMethod.payWithCard;
    }
  }

  static DeliveryType getDeliveryType({required int type}) {
    if (type == 0) {
      return DeliveryType.pickup;
    } else {
      return DeliveryType.delivery;
    }
  }
}
