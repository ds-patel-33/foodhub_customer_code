import 'package:flutter/material.dart';

import '../variables/images.dart';

Widget customBottomNavigationBar(
    {required BuildContext context,
    required int selectedScreen,
    required ValueChanged<int> onTap}) {
  return BottomNavigationBar(
      onTap: onTap,
      elevation: 100,
      currentIndex: selectedScreen,
      selectedFontSize: 11,
      selectedItemColor: Theme.of(context).primaryColor,
      selectedIconTheme: IconThemeData(color: Theme.of(context).primaryColor),
      unselectedItemColor: Colors.black,
      items: [
        BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 6),
              child: Icon(
                Icons.home_outlined,
                size: 28,
              ),
            ),
            label: "Home"),
        BottomNavigationBarItem(
            icon: Padding(
                padding: const EdgeInsets.only(top: 2.0, bottom: 6),
                child: ImageIcon(
                  AssetImage(Images.BOTTOM_ORDER),
                )),
            label: "Order"),
        BottomNavigationBarItem(
            icon: Padding(
                padding: const EdgeInsets.only(top: 2.0, bottom: 6),
                child: ImageIcon(
                  AssetImage(Images.BOTTOM_NOTIFICATION),
                )),
            label: "Notifications"),
      ]);
}
