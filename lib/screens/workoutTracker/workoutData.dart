import 'package:flutter/cupertino.dart';
import 'package:gymbros/screens/workoutTracker/exercise.dart';
import 'package:gymbros/screens/workoutTracker/workout.dart';
import 'package:gymbros/screens/workoutTracker/set.dart';
import 'package:gymbros/services/authservice.dart';
import 'package:gymbros/services/databaseservice.dart';

class WorkoutData extends ChangeNotifier {
  final DatabaseService db = DatabaseService(uid: AuthService().getUid());
  /*

   WORKOUT DATA STRUCTURE

   - List of different workouts
   - Each workout has a name and list of exercises

   */
  List<Workout> workoutList = [
    Workout(
      name: "Morning Workout",
      exercises: [
        Exercise(
            name: "Lateral Raise",
            sets: [
              Set(index: 1, weight: 10, reps: 10),
              Set(index: 2, weight: 10, reps: 10)
            ]
        )
      ]
    ),
    Workout(
        name: "Afternoon Workout",
        exercises: [
          Exercise(
              name: "Lateral Raise",
              sets: [
                Set(index: 1, weight: 10, reps: 10),
                Set(index: 2, weight: 10, reps: 10)
              ]
          )
        ]
    )
  ];


  // Initialise workout list by reading from db
  void initialiseWorkoutList() {
    workoutList = db.getWorkoutListFromDb();
  }

  // get the list of workouts
  List<Workout> getWorkoutList() {
    return workoutList;
  }

  // add a workout to workout list
  void addWorkout(Workout workout) {
    // add a new workout with a blank list of exercises
    workoutList.add(workout);

    notifyListeners();
  }

  // delete workout from workout list
  void removeWorkoutFromList(int index) {
    workoutList.removeAt(index);
  }

  // check off set
  void checkOffSet(String workoutName, String exerciseName, int index) {
    Set relevantSet = getRelevantSet(workoutName, exerciseName, index);
    relevantSet.isCompleted = !relevantSet.isCompleted;

    notifyListeners();
  }

  // return relevant workout object given workout name
  Workout getRelevantWorkout(String workoutName) {
    Workout relevantWorkout =
      workoutList.firstWhere((workout) => workout.name == workoutName);

    return relevantWorkout;
  }

  // return relevant exercise object given workout name and exercise name
  Exercise getRelevantExercise(String workoutName, String exerciseName) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    Exercise relevantExercise =
        relevantWorkout.exercises.firstWhere((exercise) => exercise.name == exerciseName);

    return relevantExercise;
  }

  Set getRelevantSet(String workoutName, String exerciseName, int index) {
    Exercise relevantExercise = getRelevantExercise(workoutName, exerciseName);

    Set relevantSet =
        relevantExercise.sets.firstWhere((set) => set.index == index);

    return relevantSet;
  }
}