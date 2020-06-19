import 'package:keepaustinblack/classes/Authentication.dart';
import 'package:keepaustinblack/buttons/round_icon_button.dart';
import 'package:keepaustinblack/main_screens/main_feed.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:keepaustinblack/containers/white_rounded_box.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:email_validator/email_validator.dart';

import 'forgot_password_screen.dart';

bool register;

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);
  static String id = 'loginPage';

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  FirebaseAuth auth;

  @override
  void initState() {
    super.initState();
    register = false;
    auth = FirebaseAuth.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              //title text
              Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: Text(
                  'Keep Austin Black',
                  style: GoogleFonts.lobster(
                    textStyle: TextStyle(
                      fontSize: 45,
                      color: Colors.deepOrange,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              //landing page image
              Flexible(
                child: Image(
                  image: AssetImage('icons/icon_no_bg.png'),
                ),
              ),
              //card with sign in form
              SignInForm(
                formKey: _formKey,
                flexVal: register ? 3 : 2,
              ),
            ]),
      ),
    );
  }
}

class SignInForm extends StatefulWidget {
  SignInForm({Key key, this.formKey, this.flexVal}) : super(key: key);
  final GlobalKey<FormState> formKey;
  final int flexVal;

  @override
  _SignInState createState() =>
      _SignInState(formKey: formKey, flexVal: flexVal);
}

class _SignInState extends State<SignInForm> {
  _SignInState({this.formKey, @required this.flexVal});

  final GlobalKey<FormState> formKey;
  int flexVal;
  String switchText = 'Sign Up';
  String email, password, firstName, lastName;
  bool obscurePW = true;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: flexVal,
      child: SingleChildScrollView(
        child: WhiteRoundedCard(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SignInField(
                      type: 'Email',
                      onChanged: (value) {
                        email = value;
                      },
                      obscure: false,
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        SignInField(
                          type: 'Password',
                          onChanged: (value) {
                            password = value;
                          },
                          obscure: obscurePW,
                        ),
                        Positioned(
                          child: FlatButton(
                            child: Text(obscurePW ? 'Show' : 'Hide'),
                            onPressed: () {
                              setState(() {
                                obscurePW = !obscurePW;
                              });
                            },
                          ),
                          right: 0,
                        )
                      ],
                    ),
                    if (register)
                      SignInField(
                        type: 'First Name',
                        onChanged: (value) {
                          firstName = value;
                        },
                        obscure: false,
                      ),
                    if (register)
                      SignInField(
                        type: 'Last Name',
                        onChanged: (value) {
                          lastName = value;
                        },
                        obscure: false,
                      ),
                    Padding(
                      padding: const EdgeInsets.only(top: 70, bottom: 70),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            register ? 'Sign Up' : 'Sign In',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          RoundIconButton(
                            icon: Icons.arrow_forward,
                            size: 60,
                            tap: () async {
                              if (formKey.currentState.validate()) {
                                if (register) {
                                  Exception e = await Authentication.signUp(
                                      email,
                                      password,
                                      firstName,
                                      lastName,
                                      context);
                                  if (e == null) {
                                    Navigator.pushReplacementNamed(
                                        context, MainFeed.id);
                                  }
                                } else {
                                  Exception e = await Authentication.signIn(
                                      email, password, context);
                                  if (e == null) {
                                    Navigator.pushReplacementNamed(
                                        context, MainFeed.id);
                                  }
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          FlatButton(
                            onPressed: () {
                              setState(() {
                                if (!register) {
                                  register = true;
                                  switchText = 'Sign In!';
                                  flexVal = 4;
                                } else {
                                  register = false;
                                  switchText = 'Sign Up!';
                                  flexVal = 2;
                                }
                              });
                            },
                            child: Text(
                              switchText,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          FlatButton(
                            child: Text(
                              'Forgot password',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                fontSize: 15,
                                color: Colors.grey,
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, ForgotPassword.id);
                            },
                          ),
                        ],
                      ),
                    ),
                    FlatButton(
                      child: Text(
                        'Continue as guest',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          fontSize: 15,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, MainFeed.id);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SignInField extends StatefulWidget {
  final String type;
  final Function onChanged;
  bool obscure;

  SignInField({@required this.type, this.onChanged, this.obscure});

  @override
  _SignInFieldState createState() => _SignInFieldState();
}

class _SignInFieldState extends State<SignInField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: widget.type,
          focusColor: Colors.deepOrange,
        ),
        onChanged: widget.onChanged,
        obscureText: widget.obscure && widget.type == 'Password',
        validator: (value) {
          if (widget.type == 'Email') {
            if (!EmailValidator.validate(value)) {
              return 'Please enter a valid email.';
            } else {
              return null;
            }
          } else if (widget.type == 'Password') {
            if (value.length < 6) {
              return 'Please enter a valid password.';
            } else
              return null;
          } else if (widget.type == 'First Name' ||
              widget.type == 'Last Name') {
            if (value.length <= 0) {
              return 'Please enter your ${widget.type}';
            } else {
              return null;
            }
          } else
            return null;
        },
      ),
    );
  }
}
