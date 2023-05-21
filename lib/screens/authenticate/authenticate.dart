import 'package:flutter/material.dart';
import 'package:gymbros/screens/authenticate/log_in.dart';
import 'package:gymbros/screens/authenticate/sign_in.dart';
import 'package:gymbros/screens/authenticate/direct_login.dart';

class Authenticate extends StatefulWidget {

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool showSignIn = true;
  void toggleView(){
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return Container(
        child: SignIn(toggleView:  toggleView),
      );
    } else {
      return Container(
        child: DirectLogIn(toggleView:  toggleView),
      );
    }

  }
}
