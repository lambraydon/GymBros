import "package:cloud_firestore/cloud_firestore.dart";
import  "package:gymbros/models/gbprofile.dart";

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

  //get profile Stream
  Stream<List<GbProfile?>> get profiles{
    return userProfiles.snapshots()
    .map(_gbProfileListFromSnapshot);
  }

  List<GbProfile?> _gbProfileListFromSnapshot(QuerySnapshot profileSnap) {
    return profileSnap.docs.map((doc){
      return GbProfile(name: doc.get("name"));
    }).toList();
  }
}

