import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:foodhub/models/user_model.dart';
import 'package:foodhub/providers/profile_provider.dart';
import 'package:foodhub/widgets/custom_appbar.dart';
import 'package:foodhub/widgets/custom_image.dart';
import 'package:foodhub/widgets/loders/loader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel user;
  const EditProfileScreen({required this.user, Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController memberIdController = TextEditingController();

  bool isLoading = false;
  bool imageChanged = false;
  File? image;
  ImagePicker picker = ImagePicker();
  String? imageUrl;

  @override
  void initState() {
    initValue();
    super.initState();
  }

  initValue() {
    setState(() {
      imageUrl = widget.user.userImage ?? "";
      nameController.text = widget.user.userName!;
      memberIdController.text = widget.user.userMemberId!;
    });
  }

  @override
  Widget build(BuildContext context) {
    isLoading = Provider.of<ProfileProvider>(context, listen: true).isLoading;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: customAppbar(
          title: Text(
            "Edit Profile",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          centerTitle: true,
          context: context,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios)),
        ),
      ),
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                child: Column(
                  children: [userImage(), restaurantForm(), updateButton()],
                ),
              ),
            ),
          ),
          isLoading
              ? Loader(
                  bgColor: Colors.black,
                  opacity: 0.5,
                  loaderColor: Theme.of(context).primaryColor,
                )
              : Container()
        ],
      ),
    );
  }

  // Future<File> cropImage(File image) async {
  //   File? croppedFile = await ImageCropper.cropImage(
  //       sourcePath: image.path,
  //       cropStyle: CropStyle.rectangle,
  //       aspectRatioPresets: [CropAspectRatioPreset.square],
  //       androidUiSettings: AndroidUiSettings(
  //           toolbarTitle: 'Cropper',
  //           toolbarColor: Theme.of(context).primaryColor,
  //           toolbarWidgetColor: Colors.white,
  //           initAspectRatio: CropAspectRatioPreset.square,
  //           lockAspectRatio: false),
  //       iosUiSettings: IOSUiSettings(
  //         minimumAspectRatio: 1.0,
  //       ));
  //
  //   return croppedFile!;
  // }

  Future getImage() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 50);
    final File croppedFile = await File(pickedFile!.path);

    setState(() {
      if (croppedFile != null) {
        image = File(croppedFile.path);
        imageChanged = true;
      } else {
        print('No image selected.');
      }
    });
  }

  Widget userImage() {
    return imageChanged
        ? Container(
            child: Stack(
              children: [
                DottedBorder(
                  dashPattern: [10, 7],
                  color: Colors.grey,
                  borderType: BorderType.RRect,
                  strokeCap: StrokeCap.round,
                  strokeWidth: 1,
                  padding: EdgeInsets.all(6),
                  radius: Radius.circular(12),
                  child: Container(
                      height: MediaQuery.of(context).size.height / 4,
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          image!,
                          width: double.infinity,
                          fit: BoxFit.fill,
                        ),
                      )),
                ),
                Positioned(
                  left: 80,
                  right: 80,
                  bottom: 20,
                  child: GestureDetector(
                    onTap: () async {
                      await getImage();
                    },
                    child: Container(
                      height: 30,
                      width: 100,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(30)),
                      child: Center(
                          child: Text(
                        "Change",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w500),
                      )),
                    ),
                  ),
                ),
              ],
            ),
          )
        : Container(
            child: Stack(
              children: [
                DottedBorder(
                  dashPattern: [10, 7],
                  color: Colors.black54,
                  borderType: BorderType.RRect,
                  strokeCap: StrokeCap.round,
                  strokeWidth: 1,
                  padding: EdgeInsets.all(2),
                  radius: Radius.circular(12),
                  child: Container(
                      height: MediaQuery.of(context).size.height / 4,
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CustomImage(
                          imgURL: imageUrl!,
                          width: double.infinity,
                          fit: BoxFit.fill,
                        ),
                      )),
                ),
                Positioned(
                  left: 80,
                  right: 80,
                  bottom: 20,
                  child: GestureDetector(
                    onTap: () async {
                      await getImage();
                    },
                    child: Container(
                      height: 30,
                      width: 100,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(30)),
                      child: Center(
                          child: Text(
                        "Change",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w500),
                      )),
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  Widget restaurantForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(
            height: 42,
          ),
          Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Name",
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.w400),
              )),
          TextFormField(
            validator: (value) {
              if (value?.length == 0) {
                return 'Name is empty !';
              }
            },
            textCapitalization: TextCapitalization.words,
            controller: nameController,
            style: TextStyle(fontSize: 16),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                vertical: 6.0,
              ),
              isDense: true,
              prefixIconConstraints:
                  BoxConstraints(minWidth: 30, maxHeight: 20),
              prefixIcon: Icon(
                Icons.person_outline,
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
                "Member Id",
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.w400),
              )),
          TextFormField(
            // validator: (value) {
            //   if (value?.length == 0) {
            //     return 'Member Id !';
            //   }
            // },
            textCapitalization: TextCapitalization.words,
            controller: memberIdController,
            style: TextStyle(fontSize: 16),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                vertical: 6.0,
              ),
              isDense: true,
              prefixIconConstraints:
                  BoxConstraints(minWidth: 30, maxHeight: 20),
              prefixIcon: Icon(
                Icons.person_add_alt_1_outlined,
                size: 16,
              ),
            ),
          ),
          SizedBox(
            height: 22,
          ),
          SizedBox(
            height: 42,
          ),
        ],
      ),
    );
  }

  Widget updateButton() {
    return InkWell(
      onTap: () async {
        FocusScope.of(context).unfocus();
        if (_formKey.currentState?.validate() == false) {
          print('Error');
        } else {
          UserModel user = widget.user;
          user.userName = nameController.text;
          user.userMemberId = memberIdController.text;
          imageChanged
              ? await Provider.of<ProfileProvider>(context, listen: false)
                  .updateProfile(context: context, image: image, user: user)
              : await Provider.of<ProfileProvider>(context, listen: false)
                  .updateProfile(context: context, user: user);
          final snackBar = SnackBar(
            content: Text(
              'Profile Updated !',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            backgroundColor: Theme.of(context).primaryColor,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
              "UPDATE",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            )),
          )),
        ],
      ),
    );
  }
}
