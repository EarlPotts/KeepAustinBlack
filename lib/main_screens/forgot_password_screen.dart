import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../buttons/round_icon_button.dart';

class ForgotPassword extends StatefulWidget {
  static String id = 'forgotPassword';

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String email = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Text(
                        'Keep Austin Black',
                        style: GoogleFonts.lobster(
                          textStyle: TextStyle(
                            fontSize: 30,
                            color: Colors.deepOrange,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 100.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              'Forgot your password?',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 25),
                            ),
                          ),
                          Text(
                            'Enter your email to reset your password',
                            textAlign: TextAlign.left,
                          ),
                          Form(
                            key: formKey,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  TextFormField(
                                    decoration: InputDecoration(
                                      hintText: 'Email',
                                      focusColor: Colors.deepOrange,
                                    ),
                                    onChanged: (value) {
                                      email = value;
                                    },
                                    validator: (value) {
                                      if (!EmailValidator.validate(value)) {
                                        return 'Please enter a valid email.';
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: Text(
                                            'Reset',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Builder(
                                          builder: (context) => RoundIconButton(
                                              icon: Icons.arrow_forward,
                                              size: 60,
                                              tap: () async {
                                                if (formKey.currentState
                                                    .validate()) {
                                                  final auth =
                                                      FirebaseAuth.instance;
                                                  String result = "";
                                                  auth
                                                      .sendPasswordResetEmail(
                                                          email: email)
                                                      .then((value) {
                                                    SnackBar snack = SnackBar(
                                                      content: Text(
                                                        'Password reset email successfully sent!',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    );
                                                    Scaffold.of(context)
                                                        .showSnackBar(snack);
                                                  }).catchError((e) {
                                                    SnackBar snack = SnackBar(
                                                      content: Text(
                                                        e.message,
                                                      ),
                                                    );
                                                    Scaffold.of(context)
                                                        .showSnackBar(snack);
                                                  });
                                                }
                                              }),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ]),
            ),
          ),
        ));
  }
}
