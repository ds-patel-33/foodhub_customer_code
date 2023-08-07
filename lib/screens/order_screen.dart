import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodhub/helper/functions.dart';
import 'package:foodhub/models/item.dart';
import 'package:foodhub/models/order.dart';
import 'package:foodhub/models/restaurant.dart';
import 'package:foodhub/models/user_model.dart';
import 'package:foodhub/providers/location_provider.dart';
import 'package:foodhub/providers/user_provider.dart';
import 'package:foodhub/screens/order_status_screen.dart';
import 'package:foodhub/services/order_services.dart';
import 'package:foodhub/services/restaurant_services.dart';
import 'package:foodhub/variables/enums.dart';
import 'package:foodhub/widgets/custom_appbar.dart';
import 'package:foodhub/widgets/custom_image.dart';
import 'package:foodhub/widgets/loders/small_loader.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatefulWidget {
  bool showBackIcon;
  OrderScreen({required this.showBackIcon});
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen>
    with SingleTickerProviderStateMixin {
  UserModel? user;
  int tabIndex = 0;

  final template = DateFormat('dd, MMMM yyyy - hh:mm a');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context, listen: false).getUser;
    return DefaultTabController(
        length: 2,
        child: Builder(builder: (context) {
          final TabController tabController = DefaultTabController.of(context)!;
          tabController.addListener(() {
            if (!tabController.indexIsChanging) {
              setState(() {
                tabIndex = tabController.index;
              });
            }
          });
          return Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(112),
                child: customAppbar(
                    leading: widget.showBackIcon
                        ? IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.arrow_back_ios))
                        : Container(),
                    elevation: 5,
                    context: context,
                    title: Text(
                      "Order History",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    centerTitle: true,
                    bottom: TabBar(
                        indicator: UnderlineTabIndicator(
                          borderSide: BorderSide(
                            width: 4.0,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        unselectedLabelColor: Colors.grey,
                        unselectedLabelStyle: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                        labelStyle: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                        tabs: [Tab(text: "Ongoing"), Tab(text: "Completed")])),
              ),
              body: Padding(
                padding: EdgeInsets.all(16),
                child: TabBarView(
                  children: [onGoingOrdersTab(), previousOrdersTab()],
                ),
              ));
        }));
  }

  onGoingOrdersTab() {
    return Container(
        child: StreamBuilder<QuerySnapshot>(
      stream: OrderServices.fetchOrders(userId: user!.userId!),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          List? docList = snapshot.data!.docs;
          List<OrderModel> ongoingOrders = [];
          for (int i = 0; i < docList.length; i++) {
            OrderModel order = OrderModel.fromJson(docList[i].data());
            if (order.orderStatus != 5 && order.orderStatus != 2) {
              ongoingOrders.add(order);
            }
          }
          print(ongoingOrders.length);
          if (ongoingOrders.length != 0) {
            return ListView.builder(
                itemCount: ongoingOrders.length,
                itemBuilder: (context, index) {
                  return orderCard(order: ongoingOrders[index]);
                });
          } else {
            return Center(child: Text("No Orders"));
          }
        } else {
          return smallLoader(context: context);
        }
      },
    ));
  }

  previousOrdersTab() {
    return Container(
        child: StreamBuilder<QuerySnapshot>(
      stream: OrderServices.fetchOrders(userId: user!.userId!),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          List? docList = snapshot.data!.docs;
          List<OrderModel> previousOrders = [];
          for (int i = 0; i < docList.length; i++) {
            OrderModel order = OrderModel.fromJson(docList[i].data());
            if (order.orderStatus == 5 || order.orderStatus == 2) {
              previousOrders.add(order);
            }
          }
          print(previousOrders.length);
          if (previousOrders.length != 0) {
            return ListView.builder(
                itemCount: previousOrders.length,
                itemBuilder: (context, index) {
                  return orderCard(order: previousOrders[index]);
                });
          } else {
            return Center(child: Text("No Orders"));
          }
        } else {
          return smallLoader(context: context);
        }
      },
    ));
  }

  Widget orderCard({required OrderModel order}) {
    var locationData = Provider.of<LocationProvider>(context);

    var date = template.format(
        DateTime.fromMillisecondsSinceEpoch(int.tryParse(order.addedOn!)!));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(
            color: Color(0xffFBFBFB),
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(16)),
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            FutureBuilder(
                future: RestaurantServices.getRestaurantById(
                    restaurantId: order.restaurantId),
                builder: (context, AsyncSnapshot<Restaurant> snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    Restaurant restaurant = snapshot.data!;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 24,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CustomImage(
                                height: 60,
                                fit: BoxFit.fill,
                                imgURL: restaurant.restaurantImage!),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                            flex: 62,
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    restaurant.restaurantName!,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Order Id -${order.orderId}',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey),
                                  )
                                ],
                              ),
                            )),
                        Expanded(
                            flex: 26,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "\$ ${order.orderPrice!.toStringAsFixed(2)}",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  Functions.getPaymentMethod(
                                              method: order.paymentMethod!) ==
                                          PaymentMethod.payLater
                                      ? "Cash"
                                      : "Card",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context).primaryColor),
                                )
                              ],
                            ))
                      ],
                    );
                  } else {
                    return Center(
                        child: smallLoader(context: context, height: 50));
                  }
                }),
            Divider(
              color: Colors.grey.shade300,
            ),
            Text(
              "Items",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey),
            ),
            SizedBox(
              height: 8,
            ),
            FutureBuilder(
                future: OrderServices.getOrderItems(order: order),
                builder:
                    (BuildContext context, AsyncSnapshot<List<Item>> snapshot) {
                  if (snapshot.hasData) {
                    List<Item> itemList = snapshot.data!;
                    print(itemList.length);
                    if (itemList.length != 0) {
                      String items = "";
                      for (int i = 0; i < itemList.length; i++) {
                        Item item = itemList[i];
                        items = (i == itemList.length - 1)
                            ? items +
                                item.itemQuantity.toString() +
                                " x " +
                                item.itemName.toString()
                            : items +
                                item.itemQuantity.toString() +
                                " x " +
                                item.itemName.toString() +
                                " , ";
                      }
                      print(items);
                      return Text(items,
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.5,
                            fontWeight: FontWeight.w600,
                          ));
                    }

                    return Container();
                  } else {
                    return Text("loading ..");
                  }
                }),

            // Text(
            //     "1 x veg salami pizza, 2 x heniken beer, 2 x greek green salad ",
            //     style: TextStyle(
            //       fontSize: 13,
            //       fontWeight: FontWeight.w600,
            //     )),
            SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Expanded(
                    flex: 60,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Ordered on ",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey)),
                        SizedBox(
                          height: 8,
                        ),
                        Text(date,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ))
                      ],
                    )),
                Expanded(
                  flex: 20,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OrderStatusScreen(
                                    order: order,
                                  )));
                    },
                    child: Container(
                      height: 25,
                      width: 60,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(30)),
                      child: Center(
                          child: Text(
                        "Details",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      )),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
