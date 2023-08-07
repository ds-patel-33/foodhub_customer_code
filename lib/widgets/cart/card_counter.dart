import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/item.dart';
import '../../models/user_model.dart';
import '../../providers/user_provider.dart';
import '../../services/cart_services.dart';
import '../../variables/text_config.dart';
import 'buttons.dart';

class CardCounter extends StatefulWidget {
  final Item item;
  final UserModel user;
  const CardCounter({required this.item, required this.user, Key? key})
      : super(key: key);

  @override
  _CardCounterState createState() => _CardCounterState();
}

class _CardCounterState extends State<CardCounter> {
  UserModel? user;
  bool _exists = false;
  int _qty = 0;
  bool _updating = false;

  addQuantity() {
    setState(() {
      _qty++;
      _updating = true;
    });
  }

  minusQuantity() {
    setState(() {
      if (_qty != 0) {
        _qty = _qty - 1;
      }
    });
  }

  getCart() {
    FirebaseFirestore.instance
        .collection(TextConfig.CART_COLLECTION)
        .doc(widget.user.userId)
        .collection(TextConfig.ITEMS_COLLECTION)
        .where('item_id', isEqualTo: widget.item.itemId)
        .get()
        .then((QuerySnapshot querySnapshot) => {
              if (querySnapshot.docs.isNotEmpty)
                {
                  querySnapshot.docs.forEach((doc) {
                    if (doc['item_id'] == widget.item.itemId) {
                      if (mounted) {
                        setState(() {
                          _qty = doc['item_quantity'];
                          _exists = true;
                        });
                      }
                    }
                  })
                }
              else
                {
                  if (mounted)
                    {
                      setState(() {
                        _exists = false;
                      })
                    }
                }
            });
  }

  @override
  void initState() {
    getCart();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context).getUser;

    return StreamBuilder(
        stream: getCart(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _updating
                  ? Align(
                      alignment: Alignment.center,
                      child: Container(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 1.5,
                          )),
                    )
                  : Align(
                      alignment: Alignment.center,
                      child: FittedBox(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                                onTap: () {
                                  if (_qty != 0) {
                                    setState(() {
                                      _updating = true;
                                    });
                                    if (_qty == 1) {
                                      minusQuantity();
                                      CartServices.removeFromCart(
                                              item: widget.item,
                                              qty: _qty,
                                              userId: user!.userId!)
                                          .then((value) {
                                        setState(() {
                                          _updating = false;
                                          _exists = false;
                                        });
                                      });
                                    } else if (_qty > 1) {
                                      minusQuantity();
                                      CartServices.updateCartQty(
                                              item: widget.item,
                                              qty: _qty,
                                              userId: user!.userId!)
                                          .then((value) {
                                        setState(() {
                                          _updating = false;
                                        });
                                      });
                                    }
                                  }
                                },
                                child: remove(context: context)),
                            SizedBox(
                              width: 2,
                            ),
                            Text(
                              '$_qty',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w400),
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    _updating = true;
                                  });
                                  if (_qty == 0) {
                                    addQuantity();
                                    CartServices.addToCart(
                                            item: widget.item,
                                            qty: _qty,
                                            userId: user!.userId!)
                                        .then((value) {
                                      setState(() {
                                        _updating = false;
                                      });
                                    });
                                  } else {
                                    addQuantity();
                                    CartServices.updateCartQty(
                                            item: widget.item,
                                            qty: _qty,
                                            userId: user!.userId!)
                                        .then((value) {
                                      setState(() {
                                        _updating = false;
                                      });
                                    });
                                  }
                                },
                                child: add(context: context)),
                          ],
                        ),
                      ),
                    ),
            ],
          );
        });
  }
}
