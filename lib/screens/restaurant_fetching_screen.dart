import 'dart:async';

import 'package:flutter/material.dart';
import 'package:foodhub/models/restaurant.dart';
import 'package:foodhub/providers/location_provider.dart';
import 'package:foodhub/variables/images.dart';
import 'package:foodhub/widgets/loders/small_loader.dart';
import 'package:provider/provider.dart';

class RestaurantFetchingScreen extends StatefulWidget {
  const RestaurantFetchingScreen({Key? key}) : super(key: key);

  @override
  _RestaurantFetchingScreenState createState() =>
      _RestaurantFetchingScreenState();
}

class _RestaurantFetchingScreenState extends State<RestaurantFetchingScreen> {
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
    allRestaurants =
        Provider.of<LocationProvider>(context, listen: true).allRestaurant;
    isLoading = Provider.of<LocationProvider>(context, listen: true).loading;

    return isLoading
        ? smallLoader(context: context)
        : Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                      child: Image.asset(
                    Images.FINDING_RESTAURANT,
                    width: MediaQuery.of(context).size.width / 1.5,
                  )),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: LinearProgressIndicator(),
                ),
                SizedBox(height: 40),
                Center(child: Container(child: Text("Finding Restaurant ..")))
              ],
            ),
          );
  }
}
