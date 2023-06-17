import "package:cloud_firestore/cloud_firestore.dart";
import "package:gymbros/screens/workoutTracker/workout.dart";
import "../screens/workoutTracker/exercise.dart";
import "../screens/workoutTracker/set.dart";

class DatabaseService {
  final String uid;

  DatabaseService({required this.uid});

  //collection reference
  final CollectionReference userProfiles =
      FirebaseFirestore.instance.collection("userProfiles");

  Future<void> updateUserProfile(String name) async {
    return await userProfiles.doc(uid).set({"Name": name}).catchError(
        (error) => print("Failed to create user: $error"));
  }

  // write workout data into workouts sub collection
  void saveWorkoutToDb(Workout workout) async {
    DocumentReference workoutRef =
        userProfiles.doc(uid).collection("workouts").doc();
    await workoutRef.set(workout.toJson());
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

      List<dynamic> exercisesData = workoutSnapshot['exercises'];

      exercisesData.forEach((exerciseData) {
        Exercise exercise = Exercise(
          name: exerciseData['name'],
          // sets list
          sets: []
        );

        exerciseData['sets'].forEach((setData) {
          Set set = Set(
            index: setData['index'],
            weight: setData['weight'],
            reps: setData['reps']
          );
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
    userProfiles.doc(uid).collection("workouts").get().then((querySnapshot) async {
      for (var docSnapshot in querySnapshot.docs) {
        Workout? workout = await getWorkoutFromDb(docSnapshot.id);
        if (workout != null) {
          workoutList.add(workout);
        }
      }
    });
    return workoutList;
  }
}
