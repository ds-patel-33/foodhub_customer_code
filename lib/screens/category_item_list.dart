import 'package:flutter/material.dart';
import 'package:foodhub/models/item.dart';
import 'package:foodhub/models/restaurant.dart';
import 'package:foodhub/models/user_model.dart';
import 'package:foodhub/providers/user_provider.dart';
import 'package:foodhub/services/restaurant_services.dart';
import 'package:foodhub/widgets/cart/card_counter.dart';
import 'package:foodhub/widgets/cart/cart_icon.dart';
import 'package:foodhub/widgets/custom_appbar.dart';
import 'package:foodhub/widgets/custom_image.dart';
import 'package:foodhub/widgets/loders/small_loader.dart';
import 'package:provider/provider.dart';

class CategoryItemListScreen extends StatefulWidget {
  final String categoryId;
  final Restaurant restaurant;
  final bool active;

  CategoryItemListScreen(
      {required this.categoryId,
      required this.active,
      required this.restaurant});
  @override
  _CategoryItemListScreenState createState() => _CategoryItemListScreenState();
}

class _CategoryItemListScreenState extends State<CategoryItemListScreen> {
  String categoryName = "";
  int? numberOfItems = 0;
  String keyword = "";
  TextEditingController searchController = TextEditingController();

  List<Item> itemList = [];

  UserModel? user;

  @override
  void initState() {
    super.initState();
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    print(widget.categoryId);
    categoryName = RestaurantServices.getCategoryName(
        categoryId: widget.categoryId, context: context);
    user = Provider.of<UserProvider>(context, listen: false).getUser;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: customAppbar(
            title: Text(
              categoryName,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            centerTitle: true,
            context: context,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios)),
            actions: [cartIcon(context: context)]),
      ),
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
                  future: RestaurantServices.fetchItemsByCategory(
                      categoryId: widget.categoryId,
                      restaurant: widget.restaurant,
                      active: true),
                  builder: (context, AsyncSnapshot<List<Item>> snapshot) {
                    if (snapshot.hasData) {
                      itemList = snapshot.data!;

                      print('itemList:- ${itemList.length}');

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

                      print('suggestionList:- ${suggestionList.length}');

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
                              print(index);
                              return itemTile(
                                item: suggestionList[index],
                              );
                            });
                      }
                    } else {
                      return smallLoader(context: context);
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
          hintText: 'Enter your favourite dish',
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
                  Expanded(
                      flex: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
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
