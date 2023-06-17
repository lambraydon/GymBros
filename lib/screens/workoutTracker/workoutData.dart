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

  // Initialise workoutlist by reading from db
  void initialiseWorkoutList() {
    workoutList = db.getWorkoutListFromDb();
  }

  // get the list of workouts
  List<Workout> getWorkoutList() {
    return workoutList;
  }

  // get length of given workout
  int numberOfExercises(String workoutName) {
    return getRelevantWorkout(workoutName).exercises.length;
  }

  // get number of sets in an exercise
  int numberOfSets(String workoutName, String exerciseName) {
    return getRelevantExercise(workoutName, exerciseName).sets.length;
  }

  // add a workout
  void addWorkout(String name) {
    // add a new workout with a blank list of exercises
    workoutList.add(Workout(name: name, exercises: []));

    notifyListeners();
  }

  // add an exercise
  void addExercise(String workoutName, String exerciseName) {
    getRelevantWorkout(workoutName).exercises
        .add(Exercise(
        name: exerciseName,
        sets: []
       )
    );

    notifyListeners();
  }

  // add a set
  void addSet(String workoutName, String exerciseName, double weight, int reps) {
    getRelevantExercise(workoutName, exerciseName).sets.add(Set(
      weight: weight,
      reps: reps,
      index: numberOfSets(workoutName, exerciseName) + 1
    ));
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