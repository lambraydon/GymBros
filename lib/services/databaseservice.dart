import "dart:typed_data";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:gymbros/models/gbprofile.dart";
import "package:gymbros/screens/workoutTracker/workout.dart";
import "package:gymbros/services/databaseStorageService.dart";
import "package:uuid/uuid.dart";
import "../models/post.dart";
import "../screens/workoutTracker/exercise.dart";
import "../screens/workoutTracker/set.dart";

class DatabaseService {
  final String uid;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DatabaseService({required this.uid});

  //collection reference
  final CollectionReference userProfiles =
      FirebaseFirestore.instance.collection("userProfiles");

  Future<void> createUserProfile(String name, String email) async {
    return await userProfiles.doc(uid).set({
      "Name": name,
      "Uid": uid,
      "Email": email,
      "Bio": "Edit Bio",
      "Followers": [],
      "Following": [],
      "profilephotoURL":
          'https://firebasestorage.googleapis.com/v0/b/gymbros-1d655.appspot.com/o/profilepics%2Fdefault_profile_pic.jpg?alt=media&token=419518ee-0ddc-4590-943d-62b87bd9c611'
    }).catchError((error) => print("Failed to create user: $error"));
  }

  Future<void> editUserProfile(
      String name, String email, String bio, String photoURL) async {
    return await userProfiles.doc(uid).set({
      "Name": name,
      "uid": uid,
      "email": email,
      "bio": bio,
      "Followers": [],
      "Following": [],
      "profilephotoURL": photoURL
    }).catchError((error) => print("Failed to create user: $error"));
  }

  //get GbProfile Details
  Future<GbProfile> getUserDetails() async {
    DocumentSnapshot documentSnapshot =
        await _firestore.collection('userProfiles').doc(uid).get();

    return GbProfile.fromSnap(documentSnapshot);
  }

  // write workout data into workouts sub collection
  void saveWorkoutToDb(Workout workout) async {
    DocumentReference workoutRef =
        userProfiles.doc(uid).collection("workouts").doc();

    // initialise workout id in workout object
    workout.setWorkoutId(workoutRef.id);
    await workoutRef.set(workout.toJson());
  }

  void deleteWorkoutFromDb(Workout workout) async {
    await userProfiles
        .doc(uid)
        .collection("workouts")
        .doc(workout.workoutId)
        .delete();
  }

  // read workout data from db and convert it from json to workout object
  Future<Workout?> getWorkoutFromDb(String workoutId) async {
    DocumentSnapshot workoutSnapshot =
        await userProfiles.doc(uid).collection("workouts").doc(workoutId).get();

    if (workoutSnapshot.exists) {
      Workout workout = Workout(
        name: workoutSnapshot['name'],
        // exercise list
        exercises: [],
      );

      // update workoutDurationInSec
      workout.workoutDurationInSec = workoutSnapshot['workoutDurationInSec'];

      // update DateTime
      workout.setDateTime(workoutSnapshot['start'].toDate());

      List<dynamic> exercisesData = workoutSnapshot['exercises'];

      for (var exerciseData in exercisesData) {
        Exercise exercise = Exercise(
            name: exerciseData['name'],
            // sets list
            sets: []);

        exerciseData['sets'].forEach((setData) {
          Set set = Set(
              index: setData['index'],
              weight: setData['weight'],
              reps: setData['reps'],
              isCompleted: setData['isCompleted']);
          // write sets into exercises list
          exercise.sets.add(set);
        });
        // write exercises into exercises list
        workout.exercises.add(exercise);
      }

      return workout;
    } else {
      return null;
    }
  }

  // convert workouts collection into a list of workout objects
  List<Workout> getWorkoutListFromDb() {
    List<Workout> workoutList = [];
    userProfiles
        .doc(uid)
        .collection("workouts")
        .get()
        .then((querySnapshot) async {
      for (var docSnapshot in querySnapshot.docs) {
        Workout? workout = await getWorkoutFromDb(docSnapshot.id);
        if (workout != null) {
          workoutList.add(workout);
        }
      }
    });
    return workoutList;
  }

  Future<String> uploadPost(String description, Uint8List file, String uid,
      String username, String profImage, Workout workout ) async {
    // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state management
    String res = "Some error occurred";
    try {
      String photoUrl =
          await dbStorageMethods().uploadImageToStorage('posts', file, true);
      String postId = const Uuid().v1(); // creates unique id based on time
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        likes: [],
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
        workout: workout
      );
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
      print("Post Uploaded!");
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> likePost(String postId, String uid, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> postComment(String postId, String text, String uid,
      String name, String profilePic) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String commentId = const Uuid().v1();
        _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //delete post
  Future<String> deletePost(String postId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('posts').doc(postId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
      await _firestore.collection('userProfiles').doc(uid).get();
      List following = (snap.data()! as dynamic)['Following'];

      if (following.contains(followId)) {
        await _firestore.collection('userProfiles').doc(followId).update({
          'Followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('userProfiles').doc(uid).update({
          'Following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('userProfiles').doc(followId).update({
          'Followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('userProfiles').doc(uid).update({
          'Following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
