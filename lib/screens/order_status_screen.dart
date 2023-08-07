import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodhub/helper/functions.dart';
import 'package:foodhub/models/order.dart';
import 'package:foodhub/models/restaurant.dart';
import 'package:foodhub/services/restaurant_services.dart';
import 'package:foodhub/variables/enums.dart';
import 'package:foodhub/variables/images.dart';
import 'package:foodhub/variables/universal_colors.dart';
import 'package:foodhub/widgets/loders/small_loader.dart';
import 'package:timeline_tile/timeline_tile.dart';

class OrderStatusScreen extends StatefulWidget {
  final OrderModel order;
  OrderStatusScreen({required this.order});
  @override
  _OrderStatusScreenState createState() => _OrderStatusScreenState();
}

class _OrderStatusScreenState extends State<OrderStatusScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('orders')
                .doc(widget.order.orderId)
                .snapshots(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasData) {
                Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;
                OrderModel order = OrderModel.fromJson(data);
                print(order.orderId);
                return Container(
                  height: MediaQuery.of(context).size.height,
                  child: SingleChildScrollView(
                    child: SafeArea(
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Stack(
                              children: [
                                Container(color: Colors.blue),
                                Image.asset(
                                  Images.ORDER_STATUS,
                                  fit: BoxFit.cover,
                                  height:
                                      MediaQuery.of(context).size.height / 3.5,
                                  width: MediaQuery.of(context).size.width,
                                ),
                                Image.asset(
                                  Images.STARS,
                                  fit: BoxFit.contain,
                                  height:
                                      MediaQuery.of(context).size.height / 4.9,
                                  width: MediaQuery.of(context).size.width,
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 5),
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white),
                                  child: IconButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      icon: Icon(Icons.arrow_back_ios)),
                                )
                              ],
                            ),
                            Text(
                              "Preparing Your Order",
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w700),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text("Order Id - ${order.orderId}"),
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.only(left: 30.0, top: 10),
                              //color: Colors.grey[100],
                              child: Column(
                                children: [
                                  TimelineTile(
                                    isFirst: true,
                                    hasIndicator: true,
                                    indicatorStyle: IndicatorStyle(
                                      width: 30,
                                      color: Theme.of(context).primaryColor,
                                      indicatorXY: 0.25,
                                      iconStyle: IconStyle(
                                        color: Colors.white,
                                        iconData: Icons.done,
                                      ),
                                    ),
                                    endChild: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, bottom: 30),
                                      child: Column(
                                        //mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Order Placed",
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Text(
                                            "Your order has been placed",
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                    axis: TimelineAxis.vertical,
                                  ),
                                  order.orderStatus == 2
                                      ? TimelineTile(
                                          //isLast: true,
                                          hasIndicator: true,
                                          indicatorStyle: IndicatorStyle(
                                            width: 30,
                                            color: UniversalColors.red,
                                            indicatorXY: 0.25,
                                            iconStyle: IconStyle(
                                              color: Colors.white,
                                              iconData: Icons.clear,
                                            ),
                                          ),
                                          endChild: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20, bottom: 30),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Order Cancelled",
                                                  style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 2,
                                                ),
                                                Text(
                                                  order.orderCancelledReason ??
                                                      "No reason",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                          ),
                                          axis: TimelineAxis.vertical,
                                        )
                                      : TimelineTile(
                                          hasIndicator: true,
                                          indicatorStyle:
                                              order.orderStatus == 1 ||
                                                      order.orderStatus == 3 ||
                                                      order.orderStatus == 4 ||
                                                      order.orderStatus == 5
                                                  ? IndicatorStyle(
                                                      width: 30,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      indicatorXY: 0.25,
                                                      iconStyle: IconStyle(
                                                        color: Colors.white,
                                                        iconData: Icons.done,
                                                      ),
                                                    )
                                                  : IndicatorStyle(
                                                      width: 30,
                                                      color: Colors.grey,
                                                      indicatorXY: 0.25,
                                                    ),
                                          endChild: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20, bottom: 30),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Order Confirm",
                                                  style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 2,
                                                ),
                                                Text(
                                                  "Your order is being prepared",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                          ),
                                          axis: TimelineAxis.vertical,
                                        ),
                                  TimelineTile(
                                    hasIndicator: true,
                                    indicatorStyle: order.orderStatus == 3 ||
                                            order.orderStatus == 4 ||
                                            order.orderStatus == 5
                                        ? IndicatorStyle(
                                            width: 30,
                                            color:
                                                Theme.of(context).primaryColor,
                                            indicatorXY: 0.25,
                                            iconStyle: IconStyle(
                                              color: Colors.white,
                                              iconData: Icons.done,
                                            ),
                                          )
                                        : IndicatorStyle(
                                            width: 30,
                                            color: Colors.grey,
                                            indicatorXY: 0.25,
                                          ),
                                    endChild: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, bottom: 30),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            Functions.getDeliveryType(
                                                        type: order
                                                            .deliveryType!) ==
                                                    DeliveryType.pickup
                                                ? "Ready To Pick Up"
                                                : "Order En Route",
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          Text(
                                            Functions.getDeliveryType(
                                                        type: order
                                                            .deliveryType!) ==
                                                    DeliveryType.pickup
                                                ? "Please pickup your order"
                                                : "Your order will delivered soon",
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                    axis: TimelineAxis.vertical,
                                  ),
                                  TimelineTile(
                                    isLast: true,
                                    hasIndicator: true,
                                    indicatorStyle: order.orderStatus == 5
                                        ? IndicatorStyle(
                                            width: 30,
                                            color:
                                                Theme.of(context).primaryColor,
                                            indicatorXY: 0.25,
                                            iconStyle: IconStyle(
                                              color: Colors.white,
                                              iconData: Icons.done,
                                            ),
                                          )
                                        : IndicatorStyle(
                                            width: 30,
                                            color: Colors.grey,
                                            indicatorXY: 0.25,
                                          ),
                                    endChild: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, bottom: 30),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Delivered",
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          Text(
                                            "Enjoy you food",
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                    axis: TimelineAxis.vertical,
                                  )
                                ],
                              ),
                            ),
                            FutureBuilder(
                                future: RestaurantServices.getRestaurantById(
                                    restaurantId: order.restaurantId),
                                builder: (context,
                                    AsyncSnapshot<Restaurant> snapshot) {
                                  if (snapshot.hasData &&
                                      snapshot.data != null) {
                                    Restaurant restaurant = snapshot.data!;
                                    return ListTile(
                                      //tileColor: Theme.of(context).primaryColor,
                                      leading: CircleAvatar(
                                        radius: 26,
                                        backgroundColor:
                                            Theme.of(context).accentColor,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(26),
                                          child: CachedNetworkImage(
                                              height: 52,
                                              width: 52,
                                              fit: BoxFit.fill,
                                              placeholder: (context, url) =>
                                                  Image.asset(Images.NO_IMAGE),
                                              imageUrl:
                                                  restaurant.restaurantImage!),
                                        ),
                                      ),
                                      title: Text(
                                        "Woodbridge Restaurant",
                                        style: TextStyle(
                                            fontSize: 14,
                                            // color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      subtitle: Text("id-${order.orderId}",
                                          style: TextStyle(
                                              fontSize: 12,
                                              // color: Colors.white,
                                              fontWeight: FontWeight.w400)),
                                      trailing: CircleAvatar(
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        child: Icon(
                                          Icons.call,
                                          color: Colors.white,
                                          size: 26,
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                            child: smallLoader(
                                                context: context, height: 40)),
                                      ],
                                    );
                                  }
                                }),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return smallLoader(context: context);
              }
            }));
  }
}
