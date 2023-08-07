import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/item.dart';
import '../variables/text_config.dart';

class CartServices {
  static final CollectionReference _itemsCollection =
      FirebaseFirestore.instance.collection(TextConfig.ITEMS_COLLECTION);

  static final CollectionReference _cartCollection =
      FirebaseFirestore.instance.collection(TextConfig.CART_COLLECTION);

  static Stream<QuerySnapshot> getCart({
    required userId,
  }) =>
      _cartCollection.doc(userId).collection('items').snapshots();

  static Future<void> addToCart(
      {required Item item, required int qty, required String userId}) async {
    item.itemQuantity = qty;
    item.addedOn = DateTime.now().millisecondsSinceEpoch.toString();
    return await _cartCollection
        .doc(userId)
        .collection(TextConfig.ITEMS_COLLECTION)
        .doc(item.itemId)
        .set(item.toJson())
        .then((value) => print("Item added to cart !"));
  }

  static Future<void> updateCartQty(
      {required Item item, required int qty, required String userId}) {
    // Create a reference to the document the transaction will use
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection(TextConfig.CART_COLLECTION)
        .doc(userId)
        .collection(TextConfig.ITEMS_COLLECTION)
        .doc(item.itemId);

    return FirebaseFirestore.instance
        .runTransaction((transaction) async {
          // Get the document
          DocumentSnapshot snapshot = await transaction.get(documentReference);

          if (!snapshot.exists) {
            throw Exception("Item does not exist!");
          }

          transaction.update(documentReference, {'item_quantity': qty});

          // Return the new count
          return qty;
        })
        .then((value) => print("Cart Updated !"))
        .catchError((error) => print("Failed to update cart: $error"));
  }

  static Future<void> removeFromCart(
      {required Item item, required int qty, required String userId}) async {
    return _cartCollection
        .doc(userId)
        .collection(TextConfig.ITEMS_COLLECTION)
        .doc(item.itemId)
        .delete()
        .then((value) => print("Item removed from cart !"));
  }

  static Future<void> deleteCart(
      {required String userId, required List<Item> items}) async {
    print(userId);
    for (Item item in items)
      _cartCollection
          .doc(userId)
          .collection(TextConfig.ITEMS_COLLECTION)
          .doc(item.itemId)
          .delete();
    print("Cart has been removed !");
  }

  static Stream<QuerySnapshot> getNumberOfCartItems({required userId}) =>
      _cartCollection
          .doc(userId)
          .collection(TextConfig.ITEMS_COLLECTION)
          .snapshots();
}
