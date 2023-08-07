import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodhub/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../../models/item.dart';
import '../../screens/cart_screen.dart';
import '../../services/cart_services.dart';
import '../../variables/images.dart';

Widget cartIcon({required BuildContext context}) {
  return IconButton(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CartScreen(
                  u: Provider.of<UserProvider>(context, listen: false).getUser,
                )));
      },
      icon: Stack(
        children: [
          Container(
              padding: const EdgeInsets.only(
                right: 5.0,
              ),
              child: Image.asset(
                Images.CART,
                height: 30,
                width: 30,
              )),
          StreamBuilder<QuerySnapshot>(
              stream: CartServices.getNumberOfCartItems(
                  userId: FirebaseAuth.instance.currentUser!.uid),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  int totalQty = 0;
                  var docList = snapshot.data!.docs;
                  for (int i = 0; i < docList.length; i++) {
                    Map<String, dynamic> data =
                        docList[i].data() as Map<String, dynamic>;
                    Item item = Item.fromJson(data);
                    totalQty += item.itemQuantity!;
                  }

                  return Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Text(
                        "${totalQty}",
                        style: TextStyle(color: Colors.white, fontSize: 11),
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              }),
        ],
      ));
}
