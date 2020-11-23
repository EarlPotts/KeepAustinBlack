import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class Authentication {
  //metyhod to create a new account
  static Future<Exception> signUp(String email, String password,
      String firstName, String lastName, BuildContext context) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final firestore = Firestore.instance;
    PlatformException result;
    //try to register the new user
    try {
      final user = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (user != null) {
        String uid = auth.currentUser.uid;
        //add the user's name to the database
        DocumentReference userInfo = firestore.document('users/$uid');
        userInfo.setData(
            {'uid': uid, 'firstName': firstName, 'lastName': lastName});
      }
    } catch (e) {
      result = e;
    }
    final SnackBar snack = SnackBar(
      content:
          Text(result == null ? 'Registration Successful!' : result.message),
    );
    Scaffold.of(context).showSnackBar(snack);
    return result;
  }

  //sign into account
  static Future<Exception> signIn(
      String email, String password, BuildContext context) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    PlatformException result;
    //try to register the new user
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      result = e;
    }
    final SnackBar snack = SnackBar(
      content: Text(result == null ? 'Sign In Successful!' : result.message),
    );
    Scaffold.of(context).showSnackBar(snack);
    return result;
  }
}
