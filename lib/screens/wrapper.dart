import 'package:flutter/material.dart';
import 'package:gymbros/screens/authenticate/log_in.dart';
import 'package:gymbros/models/gbuser.dart';
import 'package:gymbros/screens/home/page_toggler.dart';
import "package:provider/provider.dart";

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<GbUser?>(context);

    //return home or authenticate widget
    if (user == null) {
      return LogIn();
    } else {
      return const PageToggler();
    }
  }
}
