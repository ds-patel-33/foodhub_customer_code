import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodhub/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../models/item.dart';
import '../models/item_category.dart';
import '../models/restaurant.dart';
import '../variables/text_config.dart';

class RestaurantServices {
  static final CollectionReference _itemsCollection =
      FirebaseFirestore.instance.collection(TextConfig.ITEMS_COLLECTION);

  static final CollectionReference _categoriesCollection =
      FirebaseFirestore.instance.collection(TextConfig.CATEGORIES_COLLECTION);
  static final CollectionReference _restaurantCollection =
      FirebaseFirestore.instance.collection(TextConfig.RESTAURANTS_COLLECTION);

  static Future<List<Item>> fetchAllItems(
      {required Restaurant restaurant}) async {
    List<Item> itemList = [];

    QuerySnapshot snapshot = await _itemsCollection
        .where("restaurant_id", isEqualTo: restaurant.restaurantId)
        .where('item_available_in_stock', isEqualTo: true)
        .get();

    List? docList = snapshot.docs;
    print(docList.length);
    for (var i = 0; i < docList.length; i++) {
      itemList.add(Item.fromJson(docList[i].data()));
    }
    return itemList;
  }

  static Future<List<Item>> fetchPopularItems(
      {required Restaurant restaurant}) async {
    List<Item> itemList = [];

    QuerySnapshot snapshot = await _itemsCollection
        .where("restaurant_id", isEqualTo: restaurant.restaurantId)
        .where('item_available_in_stock', isEqualTo: true)
        .where('item_show_in_popular', isEqualTo: true)
        .get();

    List? docList = snapshot.docs;
    print(docList.length);
    for (var i = 0; i < docList.length; i++) {
      itemList.add(Item.fromJson(docList[i].data()));
    }
    return itemList;
  }

  // static Stream<QuerySnapshot> fetchAllItems(
  //         {required Restaurant restaurant, required bool active}) =>
  //     _itemsCollection
  //         .where("restaurant_id", isEqualTo: restaurant.restaurantId)
  //         .where('item_available_in_stock', isEqualTo: true)
  //         .orderBy('added_on', descending: true)
  //         .snapshots();

  static Future<List<Item>> fetchItemsByCategory(
      {required Restaurant restaurant,
      required String categoryId,
      required bool active}) async {
    List<Item> itemList = [];

    QuerySnapshot snapshot = await _itemsCollection
        .where("category_id", isEqualTo: categoryId)
        .where("restaurant_id", isEqualTo: restaurant.restaurantId)
        .where('item_available_in_stock', isEqualTo: true)
        .get();
    // .orderBy(
    //   "added_on",
    // )

    List? docList = snapshot.docs;
    print(docList.length);
    for (var i = 0; i < docList.length; i++) {
      itemList.add(Item.fromJson(docList[i].data()));
    }
    //print(itemList.length.toString() + "Items");
    return itemList;
  }

  // static Stream<QuerySnapshot> fetchItemsByCategory(
  //         {required Restaurant restaurant,
  //         required String categoryId,
  //         required bool active}) =>
  //     _itemsCollection
  //         .where("category_id", isEqualTo: categoryId)
  //         .where("restaurant_id", isEqualTo: restaurant.restaurantId)
  //         .where('item_available_in_stock', isEqualTo: true)
  //         .orderBy('added_on', descending: true)
  //         .snapshots();

  static Stream<QuerySnapshot> numberOfItemByCategory({
    required categoryId,
    required Restaurant restaurant,
    required bool active,
  }) =>
      _itemsCollection
          .where("category_id", isEqualTo: categoryId)
          .where("restaurant_id", isEqualTo: restaurant.restaurantId)
          .where('item_available_in_stock', isEqualTo: true)
          .snapshots();

  static Future<List<ItemCategory>> getCategories() async {
    List<ItemCategory> categoryList = [];
    QuerySnapshot snapshot = await _categoriesCollection
        .orderBy(
          "added_on",
        )
        .get();
    List? docList = snapshot.docs;
    for (var i = 0; i < docList.length; i++) {
      categoryList.add(ItemCategory.fromJson(docList[i].data()));
    }
    return categoryList;
  }

  static String getCategoryName(
      {required categoryId, required BuildContext context}) {
    List? categoryList =
        Provider.of<UserProvider>(context, listen: false).getCategoryList;
    for (int i = 0; i < categoryList!.length; i++) {
      if (categoryList[i].categoryId == categoryId) {
        return categoryList[i].categoryName!;
      }
    }
    return "";
  }

  static Future<Restaurant> getRestaurantById({required restaurantId}) async {
    List<ItemCategory> categoryList = [];
    DocumentSnapshot snapshot =
        await _restaurantCollection.doc(restaurantId).get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    Restaurant restaurant = Restaurant.fromJson(data);
    return restaurant;
  }
}
