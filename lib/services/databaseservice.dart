import "dart:typed_data";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:gymbros/screens/workoutTracker/workout.dart";
import "package:gymbros/services/databaseStorageService.dart";
import "package:uuid/uuid.dart";
import "../models/post.dart";
import "../screens/workoutTracker/exercise.dart";
import "../screens/workoutTracker/set.dart";
import "package:gymbros/models/gbprofile.dart";

class DatabaseService {
  final String uid;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DatabaseService({required this.uid});

  //collection reference
  final CollectionReference userProfiles =
      FirebaseFirestore.instance.collection("userProfiles");

  Future<void> updateUserProfile(String name) async {
    return await userProfiles.doc(uid).set({"Name": name}).catchError(
        (error) => print("Failed to create user: $error"));
  }

  //get profile Stream
  Stream<List<GbProfile?>> get profiles {
    return userProfiles.snapshots().map(_gbProfileListFromSnapshot);
  }

  List<GbProfile?> _gbProfileListFromSnapshot(QuerySnapshot profileSnap) {
    return profileSnap.docs.map((doc) {
      return GbProfile(name: doc.get("name"));
    }).toList();
  }

  //get user profile details
  Future<GbProfile> getUserDetails() async{
    final userData = await userProfiles.doc(uid).get() ;
    return GbProfile.fromSnap(userData);
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

      exercisesData.forEach((exerciseData) {
        Exercise exercise = Exercise(
            name: exerciseData['name'],
            // sets list
            sets: []);

        exerciseData['sets'].forEach((setData) {
          Set set = Set(
              index: setData['index'],
              weight: setData['weight'],
              reps: setData['reps']);
          // write sets into exercises list
          exercise.sets.add(set);
        });
        // write exercises into exercises list
        workout.exercises.add(exercise);
      });

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
      String username /*String profImage*/) async {
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
        //profImage: profImage,
      );
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
      print("Post Uploaded!");
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
