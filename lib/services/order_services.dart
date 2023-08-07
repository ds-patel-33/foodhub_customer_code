import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodhub/models/item.dart';
import 'package:intl/intl.dart';

import '../models/order.dart';
import '../models/user_model.dart';
import '../variables/text_config.dart';
import 'cart_services.dart';

final dateTemplate = DateFormat('dd-MM-yyyy');
final timeTemplate = DateFormat('hh:mm:ss a');

class OrderServices {
  static final CollectionReference _itemsCollection =
      FirebaseFirestore.instance.collection(TextConfig.ITEMS_COLLECTION);
  static final CollectionReference _ordersCollection =
      FirebaseFirestore.instance.collection(TextConfig.ORDERS_COLLECTION);

  static Future<void> createOrder(
      {required OrderModel order,
      required List<Item> items,
      required UserModel user}) async {
    int totalQty = 0;

    //
    String orderId = DateTime.now().millisecondsSinceEpoch.toString();
    String orderDate = dateTemplate
        .format(DateTime.fromMillisecondsSinceEpoch(int.tryParse(orderId)!));
    String orderTime = timeTemplate
        .format(DateTime.fromMillisecondsSinceEpoch(int.tryParse(orderId)!));
    print(orderDate);
    print(orderTime);
    DocumentReference documentReference = _ordersCollection.doc(orderId);

    //
    for (Item item in items) {
      totalQty = totalQty + item.itemQuantity!;
      print(item.itemName);
      documentReference
          .collection(TextConfig.ITEMS_COLLECTION)
          .doc(item.itemId)
          .set(item.toJson());
    }
    //
    order
      ..orderId = documentReference.id
      ..numberOfItems = items.length
      ..orderQuantity = totalQty
      ..orderDate = orderDate
      ..orderTime = orderTime
      ..addedOn = orderId;
    await documentReference.set(order.toJson());
    await CartServices.deleteCart(userId: user.userId!, items: items);
    print("Order has been added ! and Cart items are deleted !");
  }

  static Stream<QuerySnapshot> fetchOrders({required userId}) =>
      _ordersCollection
          .where("user_id", isEqualTo: userId)
          .orderBy('added_on', descending: true)
          .snapshots();

  static Future<List<Item>> getOrderItems({required OrderModel order}) async {
    List<Item> itemList = [];
    QuerySnapshot snapshot = await _ordersCollection
        .doc(order.orderId)
        .collection(TextConfig.ITEMS_COLLECTION)
        .get();

    List? docList = snapshot.docs;
    for (var i = 0; i < docList.length; i++) {
      itemList.add(Item.fromJson(docList[i].data()));
    }
    return itemList;
  }
}
