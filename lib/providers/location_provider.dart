import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodhub/models/restaurant.dart';

import '../variables/text_config.dart';

class LocationProvider with ChangeNotifier {
  double? latitude;
  double? longitude;
  Restaurant? nearestRestaurant;
  bool permissionAllowed = false;
  var selectedAddress;
  bool loading = false;
  double mindist = double.maxFinite;
  List<Restaurant> restaurants = [];

  Restaurant get getRestaurant => nearestRestaurant!;

  List<Restaurant> get allRestaurant => restaurants;

  static final CollectionReference _restaurantCollection =
      FirebaseFirestore.instance.collection(TextConfig.RESTAURANTS_COLLECTION);

  void setLoading(bool value) {
    loading = value;
    notifyListeners();
  }

  void setRestaurant(Restaurant restaurant) {
    nearestRestaurant = restaurant;
    notifyListeners();
  }

  Future<void> getAllRestaurants({required BuildContext context}) async {
    setLoading(true);
    //

    QuerySnapshot snapshot = await _restaurantCollection.get();
    var docList = snapshot.docs;
    print(docList.length);
    restaurants = [];
    for (int i = 0; i < docList.length; i++) {
      Map<String, dynamic> data = docList[i].data() as Map<String, dynamic>;
      Restaurant restaurant = Restaurant.fromJson(data);
      restaurants.add(restaurant);
    }
    setLoading(false);
    notifyListeners();
  }
}
