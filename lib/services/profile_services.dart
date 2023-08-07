import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodhub/services/storage_methods.dart';

import '../models/user_model.dart';
import '../variables/text_config.dart';

class ProfileServices {
  static final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection(TextConfig.USERS_COLLECTION);

  Future<DocumentSnapshot> getUserById({required UserModel user}) async {
    DocumentSnapshot snapshot = await _userCollection.doc(user.userId).get();
    return snapshot;
  }

  Future<UserModel?> updateProfile(
      {required UserModel user, File? image}) async {
    if (image != null) {
      StorageMethods storageMethods = StorageMethods();

      var imageData =
          await storageMethods.uplaodImageToServer(image, 'user_images');

      print('Uploaded image url :- ${imageData['url']}');
      user.userImage = imageData['url'];
    }
    DocumentReference doc = _userCollection.doc(user.userId);
    await doc.update(user.toJson());
    return user;
  }
}
