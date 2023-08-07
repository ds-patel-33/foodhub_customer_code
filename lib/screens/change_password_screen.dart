import 'package:flutter/material.dart';
import 'package:foodhub/variables/images.dart';
import 'package:foodhub/variables/universal_colors.dart';
import 'package:foodhub/widgets/loders/loader.dart';

class ChangePasswordScreen extends StatefulWidget {
  // final Restaurant restaurantDetail;
  const ChangePasswordScreen(
      {
      //required this.restaurantDetail,
      Key? key})
      : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController currentPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // bool isLoading =
    //     Provider.of<RestaurantSetupProvider>(context, listen: true).isLoading;

    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          header(),
                          userForm(),
                          SizedBox(
                            height: 40,
                          ),
                          updateButton()
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).viewPadding.top + 20,
            left: 16,
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios)),
          ),
          isLoading
              ? Loader(
                  bgColor: UniversalColors.black,
                  loaderColor: Theme.of(context).primaryColor,
                )
              : Container()
        ],
      ),
    );
  }

  Widget header() {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40)),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    gradient: LinearGradient(
                        colors: [
                          Color(0xff80ED20),
                          Color(0xffA2EA62),
                          Color(0xff84DE35),
                          Color(0xff75D024),
                          Color(0xff67C117),
                        ],
                        end: Alignment.centerRight,
                        begin: Alignment.centerLeft)),
                child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 40,
                    child: Image.asset(
                      Images.CONFIRM_PASSWORD_LOGO,
                      width: 45,
                      height: 45,
                    )),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: Text(
              "Change Password",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget userForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(
            height: 22,
          ),
          Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Current Password",
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.w400),
              )),
          TextFormField(
            obscureText: true,
            validator: (value) {
              if (value?.length == 0) {
                return 'Current Password is empty !';
              }
            },
            controller: currentPasswordController,
            style: TextStyle(fontSize: 16),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 6.0),
              isDense: true,
              prefixIconConstraints:
                  BoxConstraints(minWidth: 30, maxHeight: 20),
              prefixIcon: Icon(
                Icons.lock_outline,
                size: 16,
              ),
            ),
          ),
          SizedBox(
            height: 22,
          ),
          Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "New Password",
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.w400),
              )),
          TextFormField(
            obscureText: true,
            validator: (value) {
              if (value?.length == 0) {
                return 'New Password is empty !';
              } else if (value != null && value.length < 7) {
                return 'Password must contain at least 7 characters !';
              }
            },
            controller: newPasswordController,
            style: TextStyle(fontSize: 16),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 6.0),
              isDense: true,
              prefixIconConstraints:
                  BoxConstraints(minWidth: 30, maxHeight: 20),
              prefixIcon: Icon(
                Icons.lock_outline,
                size: 16,
              ),
            ),
          ),
          SizedBox(
            height: 22,
          ),
          Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Confirm New Password",
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.w400),
              )),
          TextFormField(
            obscureText: true,
            validator: (value) {
              if (value?.length == 0) {
                return 'Confirm Password is empty !';
              } else if (value != newPasswordController.text.trim()) {
                return 'New Password and Confirm Password are not same !';
              }
            },
            textCapitalization: TextCapitalization.words,
            controller: confirmPasswordController,
            style: TextStyle(fontSize: 16),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 6.0),
              isDense: true,
              prefixIconConstraints:
                  BoxConstraints(minWidth: 30, maxHeight: 20),
              prefixIcon: Icon(
                Icons.lock_outline,
                size: 16,
              ),
            ),
          ),
          SizedBox(
            height: 22,
          ),
        ],
      ),
    );
  }

  Widget updateButton() {
    return InkWell(
      onTap: () async {
        if (_formKey.currentState?.validate() == false) {
          print('Error');
        } else {
          //   Restaurant restaurant = widget.restaurantDetail;
          //   restaurant.restaurantPassword = newPasswordController.text.trim();
          //   await Provider.of<ProfileProvider>(context, listen: false)
          //       .updateProfile(context: context, restaurant: restaurant);
          //   final snackBar = SnackBar(
          //     content: Text(
          //       'Password Successfully Updated !',
          //       textAlign: TextAlign.center,
          //       style: TextStyle(
          //         color: Colors.white,
          //       ),
          //     ),
          //     backgroundColor: Theme.of(context).primaryColor,
          //   );
          //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      child: Row(
        children: [
          Expanded(
              child: Container(
            height: 45,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(30)),
            child: Center(
                child: Text(
              "NEXT",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            )),
          )),
        ],
      ),
    );
  }
}
