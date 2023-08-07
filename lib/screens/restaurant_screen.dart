import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodhub/models/item.dart';
import 'package:foodhub/models/item_category.dart';
import 'package:foodhub/models/operational_hours.dart';
import 'package:foodhub/models/restaurant.dart';
import 'package:foodhub/models/user_model.dart';
import 'package:foodhub/providers/location_provider.dart';
import 'package:foodhub/providers/user_provider.dart';
import 'package:foodhub/services/restaurant_services.dart';
import 'package:foodhub/variables/text_config.dart';
import 'package:foodhub/variables/universal_colors.dart';
import 'package:foodhub/widgets/cart/card_counter.dart';
import 'package:foodhub/widgets/custom_image.dart';
import 'package:foodhub/widgets/loders/small_loader.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class RestaurantScreen extends StatefulWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  @override
  _RestaurantScreenState createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  Restaurant? restaurant;
  UserModel? user;

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context, listen: false).getUser;
    restaurant =
        Provider.of<LocationProvider>(context, listen: true).getRestaurant;
    return Scaffold(
      body: SingleChildScrollView(
        //physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(children: [
              Container(
                height: MediaQuery.of(context).size.height / 3.2,
                child: Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Center(
                    child: Stack(children: [
                      ClipRRect(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30)),
                          child: CustomImage(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height / 3.2,
                            imgURL: restaurant!.restaurantImage!,
                            fit: BoxFit.cover,
                          )),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30)),
                            gradient: LinearGradient(
                                colors: [
                                  Colors.black.withOpacity(0.1),
                                  Colors.black.withOpacity(0.3),
                                  Colors.black.withOpacity(0.5),
                                  Colors.black.withOpacity(0.7),
                                ],
                                begin: AlignmentDirectional.topCenter,
                                end: AlignmentDirectional.bottomCenter)),
                      )
                    ]),
                  ),
                ),
              ),
              Positioned(
                  top: MediaQuery.of(context).viewPadding.top + 15,
                  left: 5,
                  right: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                      )
                    ],
                  )),
              Positioned(
                bottom: 15,
                left: 10,
                right: 10,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                      child: Text(
                        restaurant!.restaurantName ?? "",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    FittedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 2),
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border:
                                    Border.all(color: Colors.white, width: 2)),
                            child: Text(
                              "Kitchen",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 2),
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border:
                                    Border.all(color: Colors.white, width: 2)),
                            child: Text(
                              "Bar",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 2),
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border:
                                    Border.all(color: Colors.white, width: 2)),
                            child: Text(
                              "Drinks",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 2),
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border:
                                    Border.all(color: Colors.white, width: 2)),
                            child: Text(
                              "Snacks",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 2),
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border:
                                    Border.all(color: Colors.white, width: 2)),
                            child: Text(
                              "Pro Shop",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ]),
            FutureBuilder<List<ItemCategory>>(
                future: RestaurantServices.getCategories(),
                builder: (context, AsyncSnapshot<List<ItemCategory>> snapshot) {
                  if (snapshot.hasData) {
                    List<ItemCategory> categories = snapshot.data!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              restaurantInfo(),
                              SizedBox(
                                height: 24,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Menu",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  ListView.builder(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.all(0),
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: categories.length,
                                      itemBuilder: (context, index) {
                                        return FutureBuilder<List<Item>>(
                                            future: RestaurantServices
                                                .fetchItemsByCategory(
                                                    categoryId:
                                                        categories[index]
                                                            .categoryId!,
                                                    restaurant: restaurant!,
                                                    active: true),
                                            builder: (context,
                                                AsyncSnapshot<List<Item>>
                                                    snapshot) {
                                              if (snapshot.hasData) {
                                                List<Item> itemList =
                                                    snapshot.data!;

                                                print(
                                                    'itemList:- ${itemList.length}');
                                                return Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height: 16,
                                                    ),
                                                    Text(
                                                        categories[index]
                                                            .categoryName!,
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700)),
                                                    SizedBox(
                                                      height: 12,
                                                    ),
                                                    itemList.length == 0
                                                        ? Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Container(
                                                              child: Text(
                                                                  "No Items"),
                                                            ),
                                                          )
                                                        : ListView.builder(
                                                            physics:
                                                                NeverScrollableScrollPhysics(),
                                                            padding:
                                                                EdgeInsets.all(
                                                                    0),
                                                            itemCount:
                                                                itemList.length,
                                                            shrinkWrap: true,
                                                            itemBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    index) {
                                                              print(index);
                                                              return itemTile(
                                                                item: itemList[
                                                                    index],
                                                              );
                                                            })
                                                  ],
                                                );
                                              } else {
                                                return Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      2,
                                                  child: Center(
                                                      child: smallLoader(
                                                          context: context,
                                                          height: 50)),
                                                );
                                              }
                                            });
                                      })
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    );
                  } else {
                    return Container(
                      height: MediaQuery.of(context).size.height -
                          (MediaQuery.of(context).size.height / 3.2),
                      child: Center(
                          child: smallLoader(context: context, height: 50)),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }

  Widget restaurantInfo() {
    return restaurant!.restaurantOpen!
        ? StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection(TextConfig.RESTAURANTS_COLLECTION)
                .doc(restaurant!.restaurantId!)
                .collection(TextConfig.OPERATIONAL_HOURS_COLLECTION)
                .doc(DateFormat('EEEE').format(DateTime.now()))
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasData) {
                Map<String, dynamic> timeData =
                    snapshot.data!.data() as Map<String, dynamic>;
                OperationalHours operationalHours =
                    OperationalHours.fromJson(timeData);
                return Row(
                  children: [
                    Expanded(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Card(
                              elevation: 2,
                              margin: EdgeInsets.all(0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6)),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6)),
                                padding: EdgeInsets.all(5),
                                child: Icon(
                                  Icons.watch_later_outlined,
                                  color: operationalHours.isClose
                                      ? UniversalColors.red
                                      : Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            operationalHours.isClose
                                ? Text("Close",
                                    style: TextStyle(
                                        color: UniversalColors.red,
                                        fontWeight: FontWeight.w600))
                                : Text(
                                    'Open',
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w600),
                                  ),
                            SizedBox(
                              height: 5,
                            ),
                            operationalHours.isClose
                                ? Container()
                                : (operationalHours.isOpen24
                                    ? Text("Open x 24")
                                    : Text(
                                        "${operationalHours.openingTime} - ${operationalHours.closingTime}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ))
                          ],
                        )
                      ],
                    )),
                    Expanded(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Card(
                              elevation: 2,
                              margin: EdgeInsets.all(0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6)),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6)),
                                padding: EdgeInsets.all(5),
                                child: Icon(
                                  Icons.call_outlined,
                                  color: UniversalColors.orange,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Call us",
                              style: TextStyle(
                                  color: UniversalColors.orange,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            FittedBox(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                      "+1 ${restaurant!.restaurantPhoneNumber!}"),
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    )),
                  ],
                );
              } else {
                return Container(
                  child: Text("Loading ..."),
                );
              }
            })
        : Row(
            children: [
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.watch_later_outlined),
                    ],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Close'),
                      SizedBox(
                        height: 5,
                      ),
                      // FittedBox(
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       Text("8:00 AM - 9:00 PM"),
                      //     ],
                      //   ),
                      // )
                    ],
                  )
                ],
              )),
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.call_outlined,
                        color: UniversalColors.orange,
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Call us",
                        style: TextStyle(color: UniversalColors.orange),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      FittedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("+1 ${restaurant!.restaurantPhoneNumber!}"),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              )),
            ],
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
                    width: 10,
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
                height: 5,
              ),
              Divider(
                color: Colors.grey,
              )
            ],
          ),
        ),
      );
}
