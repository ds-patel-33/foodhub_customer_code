import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodhub/screens/home_screen.dart';
import 'package:foodhub/screens/notification_screen.dart';
import 'package:foodhub/screens/order_screen.dart';
import 'package:foodhub/widgets/custom_bottom_bar.dart';

class ScreenContainer extends StatefulWidget {
  int selectedIndex = 0;
  ScreenContainer({this.selectedIndex = 0});

  @override
  _ScreenContainerState createState() => _ScreenContainerState();
}

class _ScreenContainerState extends State<ScreenContainer> {
  List<Widget> _body = [
    HomeScreen(),
    OrderScreen(
      showBackIcon: false,
    ),
    NotificationScreen(),
  ];
  int _selectedScreen = 0;

  @override
  void initState() {
    _selectedScreen = widget.selectedIndex;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        body: _body[_selectedScreen],
        bottomNavigationBar: customBottomNavigationBar(
            context: context,
            selectedScreen: _selectedScreen,
            onTap: (value) {
              setState(() {
                _selectedScreen = value;
              });
            }),
      ),
    );
  }
}
