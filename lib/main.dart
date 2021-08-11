import 'dart:io';

import 'package:car_driver/data_provider.dart';
import 'package:car_driver/global_variabels.dart';
import 'package:car_driver/screens/login_screen.dart';
import 'package:car_driver/screens/main_screen.dart';
import 'package:car_driver/screens/registration_screen.dart';
import 'package:car_driver/screens/vehicleInfo_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'style/brand_color.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseApp app;
  try {
    //https://pub.dev/packages/firebase_database/example
    // app = await Firebase.initializeApp(
    //   name: 'db2',
    //   options: Platform.isIOS
    //       ? FirebaseOptions(
    //         appId: '1:297855924061:ios:c6de2b69b03a5be8',
    //         apiKey: 'AIzaSyD_shO5mfO9lhy2TVWhfo1VUmARKlG4suk',
    //         projectId: 'flutter-firebase-plugins',
    //         messagingSenderId: '297855924061',
    //         databaseURL: 'https://flutterfire-cd2f7.firebaseio.com',
    //       )
    //     : FirebaseOptions(
    //         appId: '1:297855924061:android:669871c998cc21bd',
    //         apiKey: 'AIzaSyD_shO5mfO9lhy2TVWhfo1VUmARKlG4suk',
    //         messagingSenderId: '297855924061',
    //         projectId: 'flutter-firebase-plugins',
    //         databaseURL: 'https://flutterfire-cd2f7.firebaseio.com',
    //       ),
    // );
  } catch (error) {
    print("FIREBASE initializeApp Error is : $error");
    app = Firebase.app('db2');
  }
  userFirebase = FirebaseAuth.instance.currentUser;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Car driver',
        theme: ThemeData(
          fontFamily: 'Comfortaa',
          visualDensity: VisualDensity.adaptivePlatformDensity,
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      BrandColor.colorPrimary))),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(primary: Colors.black),
          ),
          primaryColor: BrandColor.colorPrimary,
        ),
        initialRoute: (userFirebase == null) ? LoginScreen.id : MainScreen.id,
        routes: {
          MainScreen.id: (context) => MainScreen(),
          RegistrationScreen.id: (context) => RegistrationScreen(),
          VehicleInfoScreen.id: (context) => VehicleInfoScreen(),
          LoginScreen.id: (context) => LoginScreen(),
        },
      ),
    );
  }
}
