import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foodhub/providers/email_sign_in_provider.dart';
import 'package:foodhub/providers/location_provider.dart';
import 'package:foodhub/providers/profile_provider.dart';
import 'package:foodhub/providers/user_provider.dart';
import 'package:foodhub/screens/splash_screen.dart';
import 'package:foodhub/widgets/create_material_color.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => EmailSignInProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => ProfileProvider()),
        ChangeNotifierProvider(create: (context) => LocationProvider()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Club Grub",
          themeMode: ThemeMode.light,
          theme: ThemeData(
              primaryColor: Color(0xff67C117),
              primarySwatch: createMaterialColor(Color(0xff67C117)),
              accentColor: Color(0xffF4FDEC),
              canvasColor: Color(0xffFDFDFD),
              focusColor: Color(0xff67C117),
              textSelectionTheme: TextSelectionThemeData(
                cursorColor: Color(0xff67C117), //thereby
              ),
              inputDecorationTheme: InputDecorationTheme(
                  focusColor: Color(0xff67C117),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                    color: Color(0xff67C117),
                  ))),
              fontFamily: 'SFUIText'),
          home: SplashScreen()),
    );
  }
}
