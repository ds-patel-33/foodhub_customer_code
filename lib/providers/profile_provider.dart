import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodhub/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';
import '../services/profile_services.dart';

class ProfileProvider extends ChangeNotifier {
  bool isLoading = false;

  bool get getLoadingState => isLoading;

  ProfileServices _profileServices = ProfileServices();

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  updateProfile({
    required BuildContext context,
    required UserModel user,
    File? image,
  }) async {
    setLoading(true);
    if (image != null) {
      await _profileServices
          .updateProfile(user: user, image: image)
          .then((value) {
        Navigator.pop(context);
      });
    } else {
      UserModel? updatedUser = await _profileServices.updateProfile(user: user);
      await Provider.of<UserProvider>(context, listen: false)
          .setUserToProvider(currentUser: updatedUser!);
      Navigator.of(context).pop();
    }

    setLoading(false);

    notifyListeners();
  }
}
