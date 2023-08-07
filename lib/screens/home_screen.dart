import 'dart:async';

import 'package:flutter/material.dart';
import 'package:foodhub/models/item_category.dart';
import 'package:foodhub/models/restaurant.dart';
import 'package:foodhub/models/user_model.dart';
import 'package:foodhub/providers/location_provider.dart';
import 'package:foodhub/providers/user_provider.dart';
import 'package:foodhub/screens/category_item_list.dart';
import 'package:foodhub/screens/profile_screen.dart';
import 'package:foodhub/screens/restaurant_screen.dart';
import 'package:foodhub/screens/screen_container.dart';
import 'package:foodhub/screens/search_screen.dart';
import 'package:foodhub/services/restaurant_services.dart';
import 'package:foodhub/widgets/custom_image.dart';
import 'package:foodhub/widgets/loders/small_loader.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserModel? user;
  int quantity = 0;
  Restaurant? restaurant;
  List<Restaurant> allRestaurants = [];
  bool isLoading = true;

  @override
  void initState() {
    Timer(Duration(milliseconds: 1), () async {
      await Provider.of<LocationProvider>(context, listen: false)
          .getAllRestaurants(context: context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context, listen: true).getUser;
    // restaurant =
    //     Provider.of<LocationProvider>(context, listen: true).getRestaurant;
    allRestaurants =
        Provider.of<LocationProvider>(context, listen: true).allRestaurant;
    isLoading = Provider.of<LocationProvider>(context, listen: true).loading;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Card(
          margin: EdgeInsets.all(0),
          elevation: 1,
          child: Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
            child: appBar(),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              headingText(),
              SizedBox(
                height: 20,
              ),
              // searchBar(context),
              allRes()
            ],
          ),
        ),
      ),
    );
  }

  Widget appBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 5),
          child: GestureDetector(
            onTap: () {
              Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()))
                  .then((value) {
                setState(() {});
              });
            },
            child: CircleAvatar(
              backgroundColor: Colors.grey[300],
              backgroundImage: NetworkImage(
                user!.userImage ??
                    "https://www.biiainsurance.com/wp-content/uploads/2015/05/no-image.jpg",
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RestaurantScreen()))
                .then((value) {
              setState(() {});
            });
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [Text("Food Hub")],
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                (user!.userName ?? "").toUpperCase(),
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColor),
              )
            ],
          ),
        ),
        SizedBox(
          width: 50,
        )
        //cartIcon(context: context)
      ],
    );
  }

  Widget headingText() {
    return Container(
      child: RichText(
          text: TextSpan(
              text: "What can we ",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
              children: [
            TextSpan(
                text: "serve",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                )),
            TextSpan(
                text: " you today ?",
                style: TextStyle(
                  color: Colors.black,
                ))
          ])),
    );
  }

  Widget searchBar(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => ScreenContainer(
                      selectedIndex: 0,
                    )),
            (route) => false);
      },
      child: TextField(
        enabled: false,
        textAlignVertical: TextAlignVertical.center,
        autocorrect: true,
        style: TextStyle(fontSize: 16),
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: EdgeInsets.only(top: 0), // add padding to adjust icon
            child: Icon(
              Icons.search_outlined,
              size: 26,
              color: Theme.of(context).primaryColor,
            ),
          ),
          isCollapsed: true,
          hintText: 'Enter your favourite item',
          hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
          filled: true,
          fillColor: Colors.grey[100],
          contentPadding: EdgeInsets.only(top: 0),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              borderSide: BorderSide.none),
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

  // print("start");
  // final uri = Uri.parse(
  //     "https://us-central1-foodhub-e04f0.cloudfunctions.net/emailSender");
  // final response =
  //     await http.post(uri, body: {'email': 'rvn.dhaval@gmail.com'});
  // print("done ${response.statusCode}");
  Widget bannerImage({required image}) {
    return Container(
        width: MediaQuery.of(context).size.width,
        child: Image.asset(
          image,
          fit: BoxFit.fill,
        ));
  }

  Widget allRes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   "Popular Items",
        //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        // ),
        // SizedBox(
        //   height: 16,
        // ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: allRestaurants.length,
          itemBuilder: (context, index) {
            Restaurant restaurant = allRestaurants[index];
            return GestureDetector(
              onTap: () {
                Provider.of<LocationProvider>(context, listen: false)
                    .setRestaurant(restaurant);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SearchScreen()));
              },
              child: Container(
                  height: 290, child: popularItemCard(restaurant: restaurant)),
            );
          },
        )
      ],
    );
  }

  Widget popularItemCard({required Restaurant restaurant}) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          // width: MediaQuery.of(context).size.width / 1.45,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              Container(
                height: 160,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(24)),
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: CustomImage(
                      fit: BoxFit.fill,
                      imgURL: restaurant.restaurantImage ?? ""),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 112,
                padding:
                    EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  child: Text(
                                restaurant.restaurantName ?? "",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 22),
                              )),
                            ],
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Text(
                                (restaurant.restaurantAddress ?? "") +
                                    ' , ' +
                                    (restaurant.restaurantCity ?? "") +
                                    ' , ' +
                                    (restaurant.restaurantState ?? "") +
                                    '.',
                                style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ))
                            ],
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Row(
                            children: [
                              Text(
                                restaurant.restaurantPhoneNumber ?? '',
                                style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          height: 40,
                          child: CircleAvatar(
                            backgroundColor: Theme.of(context).primaryColor,
                            child: Icon(
                              Icons.pin_drop,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 40,
                          child: CircleAvatar(
                            backgroundColor: Theme.of(context).primaryColor,
                            child: Icon(
                              Icons.call,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}

class Categories {
  String? image;
  String? categoryName;
  int? availability;

  Categories(
      {@required this.categoryName,
      @required this.availability,
      @required this.image});
}

class CategoryList extends StatefulWidget {
  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  int selectedIndex = 9;
  RestaurantServices restaurantServices = RestaurantServices();

  @override
  Widget build(BuildContext context) {
    var locationData = Provider.of<LocationProvider>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Categories",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        SizedBox(
          height: 16,
        ),
        Container(
          height: 105,
          color: Colors.white,
          child: FutureBuilder<List<ItemCategory>>(
              future: RestaurantServices.getCategories(),
              builder: (context, AsyncSnapshot<List<ItemCategory>> snapshot) {
                if (snapshot.hasData) {
                  List<ItemCategory> categories = snapshot.data!;

                  return ListView.builder(
                    itemCount: categories.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });

                          print(categories[index].categoryId);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CategoryItemListScreen(
                                        categoryId:
                                            categories[index].categoryId!,
                                        restaurant:
                                            locationData.nearestRestaurant!,
                                        active: true,
                                      )));
                        },
                        child: CategoryListItem(
                            image: categories[index].categoryImage!,
                            categoryName: categories[index].categoryName!,
                            selected: selectedIndex == index ? true : false),
                      );
                    },
                  );
                } else {
                  return Center(
                      child: smallLoader(context: context, height: 50));
                }
              }),
        ),
      ],
    );
  }
}

class CategoryListItem extends StatelessWidget {
  final String? image;
  final String? categoryName;

  final bool? selected;

  CategoryListItem(
      {@required this.image,
      @required this.categoryName,
      @required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      padding: EdgeInsets.fromLTRB(5, 5, 5, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: selected == true ? Theme.of(context).primaryColor : Colors.white,
        border: Border.all(
            color: selected == true ? Colors.transparent : Colors.grey[200]!,
            width: 1.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
              ),
              child: CustomImage(
                imgURL: image!,
                height: 26,
                width: 26,
              )),
          Text(
            categoryName!,
            maxLines: 1,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: selected == true ? Colors.white : Colors.black),
          ),
          SizedBox(
            height: 1,
          )
        ],
      ),
    );
  }
}
