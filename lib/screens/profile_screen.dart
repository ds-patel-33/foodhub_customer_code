import 'package:flutter/material.dart';
import 'package:foodhub/models/user_model.dart';
import 'package:foodhub/providers/user_provider.dart';
import 'package:foodhub/screens/edit_profile_screen.dart';
import 'package:foodhub/screens/order_screen.dart';
import 'package:foodhub/services/profile_services.dart';
import 'package:foodhub/widgets/custom_appbar.dart';
import 'package:foodhub/widgets/custom_image.dart';
import 'package:foodhub/widgets/exit_app_dialog.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? user = UserModel();

  ProfileServices profileServices = ProfileServices();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context, listen: true).getUser;
    print(user!.userImage);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: customAppbar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios)),
            title: Text(
              "My Profile",
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
            ),
            centerTitle: true,
            context: context,
            actions: [
              IconButton(
                  onPressed: () {
                    exitAppDialog(context);
                  },
                  icon: Icon(
                    Icons.power_settings_new_outlined,
                    color: Theme.of(context).primaryColor,
                    size: 24,
                  ))
            ]),
      ),
      body: body(user: user!),
    );
  }

  Widget body({required UserModel user}) {
    return SingleChildScrollView(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        uerInfo(user: user),
        SizedBox(
          height: 30,
        ),
        tileList(),
      ],
    ));
  }

  Widget uerInfo({required UserModel user}) {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          userImage(user: user),
          SizedBox(
            height: 10,
          ),
          Text(
            user.userName!,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            user.userPhoneNumber ?? "No Number",
            //restaurantDetail!.restaurantEmail!,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Colors.grey[800]),
          ),
          SizedBox(
            height: 25,
          ),
          editProfileButton()
        ],
      ),
    );
  }

  Widget userImage({required UserModel user}) {
    //print(restaurantDetail!.restaurantImage);
    return Container(
      height: 70,
      width: 70,
      decoration: BoxDecoration(shape: BoxShape.circle),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(35),
        child: CustomImage(fit: BoxFit.fill, imgURL: user.userImage ?? ""),
      ),
    );
  }

  Widget editProfileButton() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditProfileScreen(user: user!)))
            .then((value) {
          setState(() {});
        });
      },
      child: Container(
        height: 28,
        width: 130,
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(20)),
        child: Center(
            child: Text(
          "Edit Profile",
          style: TextStyle(
              fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white),
        )),
      ),
    );
  }

  Widget tileList() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // menuTile(
          //     leading: Icons.lock_outline,
          //     title: "Change Password",
          //     trailling: IconButton(
          //         onPressed: () {
          //           Navigator.push(
          //               context,
          //               MaterialPageRoute(
          //                   builder: (context) => ChangePasswordScreen(
          //                       // restaurantDetail: restaurantDetail!
          //                       ))).then((value) {
          //             setState(() {});
          //           });
          //         },
          //         icon: Icon(
          //           Icons.arrow_forward_ios,
          //           color: Colors.black,
          //         ))),
          menuTile(
              leading: Icons.watch_later_outlined,
              title: "About Us",
              trailling: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black,
                  ))),
          menuTile(
              leading: Icons.contact_support_outlined,
              title: "Contact help",
              trailling: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black,
                  ))),
          menuTile(
              leading: Icons.golf_course_outlined,
              title: "Order History",
              trailling: IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OrderScreen(
                                  showBackIcon: true,
                                  // restaurantDetail: restaurantDetail!
                                ))).then((value) {
                      setState(() {});
                    });
                  },
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black,
                  ))),
          menuTile(
              leading: Icons.lock_outline,
              title: "Privecy Policy",
              trailling: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black,
                  ))),
        ],
      ),
    );
  }

  Widget menuTile(
          {required IconData leading,
          required String title,
          required Widget trailling}) =>
      Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.15),
              child: Icon(
                leading,
                color: Colors.black,
                size: 20,
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            ),
            Spacer(),
            trailling
          ],
        ),
      );
}
