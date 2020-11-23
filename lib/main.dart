import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geocoder/geocoder.dart';
import 'package:keepaustinblack/main_screens/forgot_password_screen.dart';
import 'package:keepaustinblack/main_screens/main_feed.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'main_screens/login_page.dart';

String firstRoute;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  bool loggedIn = FirebaseAuth.instance.currentUser != null;
  firstRoute = loggedIn ? MainFeed.id : LoginPage.id;

  runApp(KeepAustinBlack());
}

class KeepAustinBlack extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Keep Austin Black',
      theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          scaffoldBackgroundColor: Color(0xFFE64A19),
          fontFamily: 'Montserrat',
          highlightColor: Colors.grey[100]),
      initialRoute: firstRoute,
      routes: {
        LoginPage.id: (context) => LoginPage(),
        MainFeed.id: (context) => MainFeed(),
        ForgotPassword.id: (context) => ForgotPassword(),
      },
    );
  }
}
