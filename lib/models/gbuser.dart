import "package:firebase_auth/firebase_auth.dart";

class GbUser {
  final String userID;

  GbUser({required this.userID});

  Map<String, dynamic> toJson() => {
    "UID": userID
  };
}