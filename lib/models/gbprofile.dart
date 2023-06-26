import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class GbProfile {


  final String name;

  GbProfile({required this.name});

  String getName() {
    return name;
  }

  static GbProfile fromSnap(DocumentSnapshot snapshot){
    var snap = snapshot.data() as Map<String, dynamic>;
    return GbProfile(name: snap["name"]);
  }

}