import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gymbros/screens/workoutTracker/workout.dart';

class Post {
  final String description;
  final String uid;
  final String username;
  final likes;
  final String postId;
  final DateTime datePublished;
  final String postUrl;
  final String profImage;
  final Workout workout;
  final List<String> taggedUsers;

  const Post(
      {required this.description,
        required this.uid,
        required this.username,
        required this.likes,
        required this.postId,
        required this.datePublished,
        required this.postUrl,
        required this.profImage,
        required this.workout,
        required this.taggedUsers
      });

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
        description: snapshot["description"],
        uid: snapshot["uid"],
        likes: snapshot["likes"],
        postId: snapshot["postId"],
        datePublished: snapshot["datePublished"],
        username: snapshot["username"],
        postUrl: snapshot['postUrl'],
        profImage: snapshot['profImage'],
        workout: snapshot['workout'],
        taggedUsers: snapshot['taggedUsers']
    );
  }

  Map<String, dynamic> toJson() => {
    "description": description,
    "uid": uid,
    "likes": likes,
    "username": username,
    "postId": postId,
    "datePublished": datePublished,
    'postUrl': postUrl,
    'profImage': profImage,
    'workout': workout.toJson(),
    'taggedUser':taggedUsers
  };
}