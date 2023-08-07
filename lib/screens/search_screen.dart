import 'package:flutter/material.dart';
import 'package:foodhub/models/item.dart';
import 'package:foodhub/providers/location_provider.dart';
import 'package:foodhub/providers/user_provider.dart';
import 'package:foodhub/services/restaurant_services.dart';
import 'package:foodhub/widgets/cart/buttons.dart';
import 'package:foodhub/widgets/cart/card_counter.dart';
import 'package:foodhub/widgets/cart/cart_icon.dart';
import 'package:foodhub/widgets/custom_appbar.dart';
import 'package:foodhub/widgets/custom_image.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String keyword = "";
  TextEditingController searchController = TextEditingController();
  UserModel? user;
  List<Item> itemList = [];
  int quantity = 0;
  String? imageUrl;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var locationData = Provider.of<LocationProvider>(context);
    user = Provider.of<UserProvider>(context, listen: false).getUser;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: customAppbar(
              leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.arrow_back_ios)),
              context: context,
              title: Text(
                "Search Items",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              centerTitle: true,
              actions: [cartIcon(context: context)])),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            searchBar(),
            SizedBox(
              height: 16,
            ),
            Expanded(
              child: FutureBuilder<List<Item>>(
                  future: RestaurantServices.fetchAllItems(
                    restaurant: locationData.nearestRestaurant!,
                  ),
                  builder: (context, AsyncSnapshot<List<Item>> snapshot) {
                    if (snapshot.hasData) {
                      itemList = snapshot.data!;

                      print(itemList.length);

                      List<Item> suggestionList = keyword.isEmpty
                          ? itemList
                          : itemList.where((Item item) {
                              String _getName = item.itemName!.toLowerCase();
                              String _getDescription =
                                  item.itemDescription!.toLowerCase();
                              String _query = keyword.toLowerCase();
                              bool matchesName = _getName.contains(_query);
                              bool matchesDescription =
                                  _getDescription.contains(_query);
                              return (matchesName || matchesDescription);
                            }).toList();

                      if (itemList.length == 0) {
                        return Center(
                          child: Container(
                            child: Text("No Items"),
                          ),
                        );
                      } else {
                        return ListView.builder(
                            padding: EdgeInsets.all(0),
                            itemCount: suggestionList.length,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, index) {
                              return itemTile(
                                item: suggestionList[index],
                              );
                            });
                      }
                    } else {
                      return Center(
                        child: Container(
                          height: 65,
                          child: LoadingIndicator(
                              indicatorType: Indicator.values[12],
                              color: Theme.of(context).primaryColor),
                        ),
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget searchBar() {
    return Container(
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        textAlignVertical: TextAlignVertical.center,
        autocorrect: true,
        style: TextStyle(fontSize: 16),
        onChanged: (value) {
          setState(() {
            keyword = value;
          });
        },
        decoration: InputDecoration(
          isDense: true,
          prefixIcon: Padding(
            padding: EdgeInsets.only(
              top: 0,
            ), // add padding to adjust icon
            child: Icon(
              Icons.search_outlined,
              size: 26,
            ),
          ),
          isCollapsed: true,
          hintText: 'Enter your favourite item',
          hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
          filled: true,
          fillColor: Colors.grey[100],
          contentPadding: EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 0),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              borderSide: BorderSide.none),
        ),
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
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      flex: 20,
                      child: Column(
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
                          ),
                        ],
                      ))
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

  addQuantity() {
    setState(() {
      quantity = quantity + 1;
    });
  }

  minusQuantity() {
    setState(() {
      if (quantity != 0) {
        quantity = quantity - 1;
      }
    });
  }

  Widget priceAndQuantityField() {
    return Row(
      children: [
        Expanded(
            child: Column(
          children: [
            SizedBox(
              height: 7,
            ),
            Row(
              children: [
                InkWell(onTap: minusQuantity, child: remove(context: context)),
                SizedBox(
                  width: 5,
                ),
                Text(
                  '$quantity',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  width: 5,
                ),
                InkWell(onTap: addQuantity, child: add(context: context)),
              ],
            ),
          ],
        )),
      ],
    );
  }
}
