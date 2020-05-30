import 'package:austinwhileblack/buttons/round_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:austinwhileblack/containers/white_rounded_box.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_core/firebase_core.dart';

class LandingPage extends StatefulWidget {
  LandingPage({Key key, this.title}) : super(key: key);

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

class _MyHomePageState extends State<LandingPage> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              //title text
              Padding(
                padding: const EdgeInsets.only(top: 22.0),
                child: Text(
                  'Austin While Black',
                  style: GoogleFonts.lobster(
                    textStyle: TextStyle(
                      fontSize: 45,
                      color: Colors.white,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              //landing page image
              Expanded(
                child: Image(
                  image: AssetImage('images/coffee_shop.png'),
                ),
              ),
              //card with sign in form
              Expanded(
                flex: 2,
                child: WhiteRoundedCard(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: EdgeInsets.only(left: 30, right: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SignInField(
                              type: 'Email',
                            ),
                            SignInField(
                              type: 'Password',
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 70, bottom: 70),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Sign In',
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  RoundIconButton(
                                    icon: Icons.arrow_forward,
                                    size: 60,
                                    tap: () {
                                      if (_formKey.currentState.validate()) {}
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Sign Up!',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    'Forgot password',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                      fontSize: 15,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}

class SignInField extends StatelessWidget {
  final String type;

  const SignInField({@required this.type});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: type,
          focusColor: Colors.deepOrange,
        ),
        obscureText: type == 'Password',
        validator: (value) {
          if (type == 'Email') {
            if (!EmailValidator.validate(value)) {
              return 'Please enter a valid email.';
            } else {
              return null;
            }
          } else if (type == 'Password') {
            if (value.length < 6) {
              return 'Please enter a valid password.';
            } else
              return null;
          } else
            return null;
        },
      ),
    );
  }
}
