import "package:cloud_firestore/cloud_firestore.dart";

class DatabaseService {

  final String uid;
  DatabaseService({required this.uid});

  //collection reference
  final CollectionReference userProfiles = FirebaseFirestore.instance.collection("userProfiles");

  Future updateUserProfile(String name) {
    return await userProfiles.add(uid) .setData()
  }
}

