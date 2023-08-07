import 'package:flutter/material.dart';
import 'package:foodhub/models/item_category.dart';
import 'package:foodhub/models/user_model.dart';
import 'package:foodhub/services/restaurant_services.dart';

class UserProvider extends ChangeNotifier {
  UserModel? user;
  List<ItemCategory>? categoryList;

  UserModel? get getUser => user;
  List<ItemCategory>? get getCategoryList => categoryList;

  setUserToProvider({required UserModel currentUser}) {
    user = currentUser;
    notifyListeners();
  }

  setCategories() async {
    categoryList = await RestaurantServices.getCategories();
    notifyListeners();
  }
}
