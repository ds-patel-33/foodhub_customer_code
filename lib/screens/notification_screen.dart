import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodhub/models/user_model.dart';
import 'package:foodhub/models/user_notification.dart';
import 'package:foodhub/providers/user_provider.dart';
import 'package:foodhub/services/notification_services.dart';
import 'package:foodhub/variables/images.dart';
import 'package:foodhub/widgets/custom_appbar.dart';
import 'package:foodhub/widgets/loders/small_loader.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool isEmpty = true;
  UserModel? user;
  final template = DateFormat('dd, MMMM yyyy - hh:mm a');
  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    Timer(Duration(seconds: 1), () {
      isEmpty = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context, listen: true).getUser!;
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: customAppbar(
            title: Text(
              "Menu Item",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            centerTitle: true,
            context: context,
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: notificationServices.getNotifications(userId: user!.userId!),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              List? docList = snapshot.data!.docs;
              print("length ${docList.length}");

              if (docList.length != 0) {
                return ListView.builder(
                    itemCount: docList.length,
                    itemBuilder: (context, index) {
                      UserNotification notification =
                          UserNotification.fromJson(docList[index].data());
                      var date = Jiffy(DateTime.fromMillisecondsSinceEpoch(
                              int.tryParse(notification.addedOn.toString())!))
                          .fromNow();
                      return Column(
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                                radius: 22,
                                backgroundColor: Color(0xffEBFFDA),
                                child: notification.orderId != null
                                    ? Image.asset(
                                        Images.BOTTOM_ORDER,
                                        width: 25,
                                        height: 25,
                                      )
                                    : Container()),
                            title: Text(
                              notification.notificationMessage!,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // SizedBox(
                                //   height: 5,
                                // ),
                                // Text(
                                //   "Order Id - ${notification.orderId!}",
                                //   style: TextStyle(
                                //       color: Colors.green,
                                //       fontSize: 13,
                                //       fontWeight: FontWeight.w400),
                                // ),
                                Text(
                                  date,
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ),
                          // Divider()
                        ],
                      );
                    });
              } else {
                return Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(Images.EMPTY_NOTIFICATION_IMAGE,
                          width: MediaQuery.of(context).size.width / 2,
                          height: MediaQuery.of(context).size.height / 6),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "It seems like you don’t have any\nnotifications yet. Check back later.",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                            height: 1.5),
                      )
                    ],
                  ),
                );
              }
            } else {
              return smallLoader(context: context);
            }
          },
        ));

    ;
  }
}
