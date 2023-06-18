import 'package:gymbros/models/gbprofile.dart';
import 'package:flutter/material.dart';

class UserView extends StatelessWidget {

  final GbProfile? profile;
  UserView({ required this.profile });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.green[50],
          ),
          title: Text(profile!.name),
        ),
      ),
    );
  }
}
