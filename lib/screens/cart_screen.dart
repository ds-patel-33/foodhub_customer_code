import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodhub/models/item.dart';
import 'package:foodhub/models/order.dart';
import 'package:foodhub/models/restaurant.dart';
import 'package:foodhub/models/user_model.dart';
import 'package:foodhub/providers/location_provider.dart';
import 'package:foodhub/providers/user_provider.dart';
import 'package:foodhub/screens/thank_you_screen.dart';
import 'package:foodhub/services/cart_services.dart';
import 'package:foodhub/services/order_services.dart';
import 'package:foodhub/variables/enums.dart' as Enum;
import 'package:foodhub/variables/universal_colors.dart';
import 'package:foodhub/widgets/cart/card_counter.dart';
import 'package:foodhub/widgets/custom_appbar.dart';
import 'package:foodhub/widgets/custom_image.dart';
import 'package:foodhub/widgets/loders/loader.dart';
import 'package:foodhub/widgets/loders/small_loader.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  UserModel? u;
  CartScreen({Key? key, this.u}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  int quantity = 0;
  Restaurant? restaurant;
  UserModel? user;
  int holeNumber = 1;
  double salesTax = 3.00;
  double deliveryFee = 10.00;
  double tip = 0.00;
  double total = 0.0;
  double grandTotal = 0.0;
  String tipText = "";
  Enum.DeliveryType deliveryType = Enum.DeliveryType.pickup;
  Enum.PaymentMethod paymentMethod = Enum.PaymentMethod.payWithCard;
  List<Item> itemList = [];

  TextEditingController notesController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController tipController = TextEditingController();
  bool isLoading = false;
  bool showCustomTip = false;

  //payment

  @override
  void initState() {
    if (widget.u != null) {
      addressController.text = widget.u!.userAddress ?? "";
    }
    super.initState();
  }

  void paymentSetup() async {}

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context, listen: false).getUser;
    restaurant =
        Provider.of<LocationProvider>(context, listen: false).getRestaurant;

    return Stack(
      children: [
        Scaffold(
            key: _scaffoldkey,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(56),
              child: customAppbar(
                leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back_ios)),
                title: Text(
                  "Cart",
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
                ),
                centerTitle: true,
                context: context,
              ),
            ),
            body: SingleChildScrollView(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                StreamBuilder<QuerySnapshot>(
                    stream: CartServices.getCart(userId: user!.userId!),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        List? listData = snapshot.data!.docs;

                        if (listData.length == 0) {
                          return Center(
                            child: Container(
                              height: MediaQuery.of(context).size.height - 60,
                              child: Center(child: Text("Cart is Empty !")),
                            ),
                          );
                        } else {
                          //
                          double total = 0.0;
                          List<Item> list = [];

                          //
                          for (int i = 0; i < listData.length; i++) {
                            Item item = Item.fromJson(listData[i].data());
                            list.add(item);
                            total += item.itemPrice! * item.itemQuantity!;
                          }

                          //
                          itemList = list;

                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: listData.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      Item item =
                                          Item.fromJson(listData[index].data());

                                      return itemTile(item: item);
                                    }),
                                Column(
                                  children: [
                                    instruction(),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    deliveryTypeWidget(),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Visibility(
                                        visible: deliveryType ==
                                            Enum.DeliveryType.delivery,
                                        child: delivery()),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    tipTile(),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    placeOrderButton(total: total),
                                    SizedBox(
                                      height: 24,
                                    ),
                                    totalBill(total: total),
                                    SizedBox(
                                      height: 30,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        }
                      } else {
                        return Container(
                            height: MediaQuery.of(context).size.height - 60,
                            child: smallLoader(context: context));
                      }
                    }),
              ],
            ))),
        isLoading
            ? Loader(
                bgColor: Colors.black,
                opacity: 0.5,
                loaderColor: Theme.of(context).primaryColor,
              )
            : Container()
      ],
    );
  }

  Widget deliveryTypeWidget() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "Select Delivery Type",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      deliveryType = Enum.DeliveryType.pickup;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: deliveryType == Enum.DeliveryType.pickup
                            ? Theme.of(context).primaryColor
                            : Colors.white,
                        border: Border.all(
                            color: deliveryType == Enum.DeliveryType.pickup
                                ? Theme.of(context).primaryColor
                                : Colors.grey)),
                    height: 40,
                    child: Center(
                        child: Text(
                      "Pick Up",
                      style: TextStyle(
                          color: deliveryType == Enum.DeliveryType.pickup
                              ? Colors.white
                              : Colors.grey),
                    )),
                  ),
                ),
                SizedBox(
                  height: 20,
                  width: 20,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      deliveryType = Enum.DeliveryType.delivery;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: deliveryType == Enum.DeliveryType.delivery
                            ? Theme.of(context).primaryColor
                            : Colors.white,
                        border: Border.all(
                            color: deliveryType == Enum.DeliveryType.delivery
                                ? Theme.of(context).primaryColor
                                : Colors.grey)),
                    height: 40,
                    child: Center(
                        child: Text(
                      "Delivery At Home",
                      style: TextStyle(
                          color: deliveryType == Enum.DeliveryType.delivery
                              ? Colors.white
                              : Colors.grey),
                    )),
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  Widget tipTile() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Row(
                  children: [
                    Text(
                      "Select Tip",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    Text(
                      '\$ ${tip.toStringAsFixed(2)}',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Support your valet and make their day !",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          tipController.clear();
                          showCustomTip = false;
                          tip = 0;
                        });
                      },
                      child: Text(
                        "Clear",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 5,
        ),
        showCustomTip
            ? Container(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                height: 40,
                child: Row(
                  children: [
                    tipCard(
                        title: "Custom",
                        icon: Icons.card_giftcard,
                        onTap: () {}),
                    Expanded(
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: tipController,
                            onChanged: (value) {
                              setState(() {
                                tipText = value;
                              });
                            },
                            keyboardType: TextInputType.number,
                          )),
                    ),
                    tipText.isEmpty
                        ? InkWell(
                            onTap: () {
                              setState(() {
                                showCustomTip = false;
                              });
                            },
                            child: Text("Close"),
                          )
                        : tipCard(
                            title: "Add",
                            icon: Icons.done,
                            onTap: () {
                              setState(() {
                                tip = double.parse(tipText);
                              });
                            }),
                  ],
                ),
              )
            : Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                height: 35,
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    tipCard(
                        title: "\$ 5",
                        icon: Icons.coffee,
                        onTap: () {
                          setState(() {
                            tip = 5;
                          });
                        }),
                    SizedBox(
                      width: 10,
                    ),
                    tipCard(
                        title: "\$ 10",
                        icon: Icons.lunch_dining_outlined,
                        onTap: () {
                          setState(() {
                            tip = 10;
                          });
                        }),
                    SizedBox(
                      width: 10,
                    ),
                    tipCard(
                        title: "\$ 20",
                        icon: Icons.local_bar_outlined,
                        onTap: () {
                          setState(() {
                            tip = 20;
                          });
                        }),
                    SizedBox(
                      width: 10,
                    ),
                    tipCard(
                        title: "Custom",
                        icon: Icons.card_giftcard,
                        onTap: () {
                          setState(() {
                            showCustomTip = true;
                          });
                        })
                  ],
                ),
              ),
      ],
    );
  }

  Widget tipCard(
      {required String title, IconData? icon, required Function onTap}) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Card(
        margin: EdgeInsets.all(0),
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        child: Container(
          // margin: EdgeInsets.symmetric(horizontal: 15),
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.grey.withOpacity(0.2))
              // color: Theme.of(context).primaryColor.withOpacity(0.5)
              ),
          child: Row(
            children: [
              icon == null
                  ? Container()
                  : Icon(
                      icon,
                      size: 18,
                      color: Theme.of(context).primaryColor,
                    ),
              SizedBox(
                width: 5,
              ),
              Text(
                "${title}",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget instruction() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Other Instruction",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            controller: notesController,
            textAlignVertical: TextAlignVertical.center,
            autocorrect: true,
            style: TextStyle(fontSize: 16),
            maxLines: 1,
            decoration: InputDecoration(
              hintText: 'Extra notes !',
              hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide.none),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide.none),
            ),
          ),
        ],
      ),
    );
  }

  Widget delivery() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Delivery Address",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            controller: addressController,
            textAlignVertical: TextAlignVertical.center,
            autocorrect: true,
            style: TextStyle(fontSize: 16),
            maxLines: 2,
            decoration: InputDecoration(
              hintText: 'Entre Delivery Address !',
              hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide.none),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide.none),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Divider(
            color: Colors.grey,
          )
        ],
      ),
    );
  }

  TimeOfDay stringToTimeOfDay(String tod) {
    final format = DateFormat.jm(); //"6:00 AM"
    return TimeOfDay.fromDateTime(format.parse(tod));
  }

  double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;

  Widget placeOrderButton({required double total}) {
    var locationData = Provider.of<LocationProvider>(context);
    grandTotal = total + salesTax + deliveryFee + tip;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GestureDetector(
        onTap: () async {
          setState(() {
            isLoading = true;
          });

          DocumentSnapshot snapshot = await FirebaseFirestore.instance
              .collection("restaurants")
              .doc(restaurant!.restaurantId)
              .get();
          Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

          if (data['restaurant_open']) {
            {
              //order model
              OrderModel order = OrderModel(
                  userId: user!.userId!,
                  restaurantId: locationData.nearestRestaurant!.restaurantId!,
                  deliveryType:
                      deliveryType == Enum.DeliveryType.pickup ? 0 : 1,
                  paymentMethod:
                      paymentMethod == Enum.PaymentMethod.payLater ? 0 : 1,
                  orderPrice: grandTotal,
                  orderNotes: notesController.text,
                  hole: deliveryType == Enum.DeliveryType.pickup
                      ? null
                      : holeNumber,
                  tip: tip,
                  deliveryAddress: addressController.text,
                  salesTax: salesTax,
                  deliveryCharge: deliveryType == Enum.DeliveryType.pickup
                      ? 0.00
                      : deliveryFee,
                  orderStatus: 0);

              //order service
              if (true) {
                // if (paymentMethod == Enum.PaymentMethod.payLater) {
                OrderServices.createOrder(
                        order: order, items: itemList, user: user!)
                    .then((value) {
                  setState(() {
                    isLoading = false;
                  });
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ThankYouScreen()));
                });
              } else {
                setState(() {
                  isLoading = false;
                });
                //await makePayment(amount: grandTotal, order: order);
              }
              print("Open");
            }
          } else {
            setState(() {
              isLoading = false;
            });
            final snackBar = SnackBar(
              duration: Duration(seconds: 2),
              content: Text(
                'Restaurant is closed !',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              backgroundColor: UniversalColors.red,
            );

            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        child: Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Theme.of(context).primaryColor),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 30),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "\$ ${grandTotal.toStringAsFixed(2)}",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    Text(
                      "Total",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "place order",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 20),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 20,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> makePayment(
      {required double amount, required OrderModel order}) async {
    setState(() {
      isLoading = true;
    });

    OrderServices.createOrder(order: order, items: itemList, user: user!)
        .then((value) {
      setState(() {
        isLoading = false;
      });
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => ThankYouScreen()));
    });
  }

  Widget totalBill({required total}) {
    grandTotal = total + salesTax + deliveryFee + tip;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      color: Theme.of(context).accentColor,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "Item Total",
                  style: TextStyle(fontSize: 15),
                ),
              ),
              Text("\$ ${total.toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 15))
            ],
          ),
          SizedBox(
            height: 12,
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  "Sales Tax",
                  style: TextStyle(fontSize: 15),
                ),
              ),
              Text("\$ ${salesTax.toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 15))
            ],
          ),
          SizedBox(
            height: 12,
          ),
          deliveryType == Enum.DeliveryType.pickup
              ? Container()
              : Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Delivery Fees",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    Text("\$ ${deliveryFee.toStringAsFixed(2)}",
                        style: TextStyle(fontSize: 15))
                  ],
                ),
          deliveryType == Enum.DeliveryType.pickup
              ? Container()
              : SizedBox(
                  height: 12,
                ),
          Row(
            children: [
              Expanded(
                child: Text(
                  "Tip",
                  style: TextStyle(fontSize: 15),
                ),
              ),
              Text("\$ ${tip.toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 15))
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  "Total",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor),
                ),
              ),
              Text("\$ ${grandTotal.toStringAsFixed(2)}",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor))
            ],
          ),
        ],
      ),
    );
  }

  itemTile({required Item item}) => GestureDetector(
        onTap: () {
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (context) => ItemDetail(item: item)));
        },
        child: Container(
          width: double.infinity,
          color: Colors.transparent,
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 22,
                    child: Container(
                      height: 75,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CustomImage(
                              fit: BoxFit.cover, imgURL: item.itemImage ?? "")),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    flex: 60,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // item.itemType == 0 ? veg() : nonVeg(),
                            // SizedBox(
                            //   width: 6,
                            // ),
                            Expanded(
                              child: Text(
                                item.itemName!,
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          item.itemDescription!,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                              height: 1.7),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      flex: 20,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "\$ ${item.itemPrice!.toStringAsFixed(2)}",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          FittedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CardCounter(item: item, user: user!),
                              ],
                            ),
                          )
                        ],
                      )),
                ],
              ),
              SizedBox(
                height: 6,
              ),
              Divider(
                color: Colors.grey,
              )
            ],
          ),
        ),
      );
}
