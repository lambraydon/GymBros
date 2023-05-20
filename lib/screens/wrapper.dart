import 'package:flutter/material.dart';
import 'package:gymbros/screens/authenticate/authenticate.dart';
import 'package:gymbros/screens/authenticate/log_in.dart';
import 'package:gymbros/screens/authenticate/sign_in.dart';
import 'package:gymbros/screens/authenticate/direct_login.dart';
import 'package:gymbros/screens/home/home.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    //return home or authenticate widget
    return DirectLogIn();
  }
}
