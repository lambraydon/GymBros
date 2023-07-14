import 'package:cloud_firestore/cloud_firestore.dart';

class GbProfile {

  final String name;
  final String uid;
  final String email;
  final String bio;
  final List<String> followers;
  final List<String> following;
  final String profilephotoURL;

  const GbProfile(
      {
        required this.name,
        required this.uid,
        required this.email,
        required this.bio,
        required this.followers,
        required this.following,
        required this.profilephotoURL,
      }
      );


  static GbProfile fromSnap(DocumentSnapshot snapshot){
    var snap = snapshot.data() as Map<String, dynamic>;
    return GbProfile(
      name: snap['Name'],
      uid: snap['Uid'],
      email: snap["Email"],
      bio: snap['Bio'],
      followers: snap['Followers'],
      following: snap['Following'],
      profilephotoURL: snap['profilephotoURL']
    );
  }

  Map<String, dynamic> toJson() => {
    "Name": name,
    "uid": uid,
    "email": email,
    "bio": bio,
    "followers": followers,
    "following": following,
    "profilephotoURL": profilephotoURL,
  };

}