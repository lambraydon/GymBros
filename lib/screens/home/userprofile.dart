import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gymbros/models/gbprofile.dart';
import 'package:provider/provider.dart';
import 'package:gymbros/screens/home/userview.dart';

class UserProfile extends StatefulWidget {
  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    final profiles = Provider.of<List<GbProfile?>>(context);
    //print(brews.documents);
    //for (var doc in profiles) {
    //print(doc.data);
    //}
    return ListView.builder(
        itemCount: profiles.length,
        itemBuilder: (context,index){
          return UserView(profile: profiles[index]!);
        },
    );
  }
}
