import "package:cloud_firestore/cloud_firestore.dart";

class DatabaseService {

  final String uid;
  DatabaseService({required this.uid});

  //collection reference
  final CollectionReference userProfiles = FirebaseFirestore.instance.collection("userProfiles");

  Future<void> updateUserProfile(String name) async{
    return await userProfiles.doc(uid).set({
     "Name": name
    })
    .catchError((error) => print("Failed to create user: $error"));
  }
}
