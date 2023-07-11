import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProfileStreamProvider extends ChangeNotifier {
  Stream<DocumentSnapshot<Map<String, dynamic>>> getDataStream(String uid) {
    return FirebaseFirestore.instance.collection('userProfiles').doc(uid).snapshots();
  }
}