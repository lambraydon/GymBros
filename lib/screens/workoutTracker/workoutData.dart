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
              Set(index: 1, weight: 10, reps: 10, isCompleted: true),
              Set(index: 2, weight: 10, reps: 10, isCompleted: true)
            ]
        ),
        Exercise(
            name: "Bench Press",
            sets: [
              Set(index: 1, weight: 10, reps: 10, isCompleted: true),
              Set(index: 2, weight: 10, reps: 10, isCompleted: true)
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
                Set(index: 1, weight: 10, reps: 10, isCompleted: true),
                Set(index: 2, weight: 10, reps: 10, isCompleted: true)
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

    notifyListeners();
  }

  // check off set
  void checkOffSet(Set set) {
    set.isCompleted = !set.isCompleted;

    notifyListeners();
  }

  // check off set
  void checkOffTimer(Exercise exercise) {
    exercise.isRestTimer = !exercise.isRestTimer;

    notifyListeners();
  }
}