import 'package:cloud_firestore/cloud_firestore.dart';
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
  bool loggedIn = await FirebaseAuth.instance.currentUser() != null;
  print(loggedIn);
  firstRoute = loggedIn ? MainFeed.id : LoginPage.id;

  //uncomment the line below if location data needs to be updated
  //getListingsLocation();
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

void getListingsLocation() async {
  Firestore store = Firestore.instance;
  for (String category in categories) {
    print(category);
    QuerySnapshot listingsStream =
        await store.collection(category).getDocuments();

    List<DocumentSnapshot> listings = listingsStream.documents;
    for (DocumentSnapshot listing in listings) {
      DocumentReference business = listing.reference;
      String name = listing.data['Business'];
      String address = listing.data['Address'];
      if (address != null && address != "") {
        try {
          Coordinates location = (await Geocoder.local
                  .findAddressesFromQuery(listing.data['Address']))
              .first
              .coordinates;
          business.setData(
              {'latitude': location.latitude, 'longitude': location.longitude},
              merge: true);
        } on Exception catch (e) {
          print("ERROR: $name --- ${e.toString()}");
        }
      }
    }
  }
}
