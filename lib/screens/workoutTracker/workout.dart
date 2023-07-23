import 'exercise.dart';
import 'set.dart';
import 'package:intl/intl.dart';

class Workout {
  final String name;
  final List<Exercise> exercises;
  int workoutDurationInSec = 0;
  String workoutId = 'not set';
  DateTime start = DateTime.now();


  Workout({
    required this.name,
    required this.exercises,
  });

  // add empty exercise
  void addExercise(Exercise exercise) {
    exercises.add(exercise);
  }

  // get length of given workout
  int numberOfExercises() {
    return exercises.length;
  }

  // update workout ID
  void setWorkoutId(String workoutId) {
    this.workoutId = workoutId;
  }

  // update workout date
  void setDateTime(DateTime day) {
    start = day;
  }

  // get total volume of workout
  double volume() {
    double volume = 0;

    for (var exercise in exercises) {
      volume += exercise.volume();
    }

    return volume;
  }

  // filter out empty exercises
  void filter() {
    for (var exercise in exercises) {
      if (exercise.isEmpty()) {
        exercises.remove(exercise);
      }
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "start": start,
      "workoutDurationInSec": workoutDurationInSec,
      "exercises": exercises.map((exercise) => exercise.toJson()).toList()
    };
  }

  List<String> workoutSummary() {
    return exercises.map((exercise) => exercise.toString()).toList();
  }

  List<String> workoutRecommendSummary() {
    return exercises.map((exercise) => exercise.toRecommendString()).toList();
  }

  String formatDate() {
    final formatter = DateFormat('dd MMM yyyy');
    return formatter.format(start);
  }

  String formatWorkoutDuration() {
    int min = workoutDurationInSec ~/ 60 % 60;
    int hour = workoutDurationInSec ~/ 3600;
    String format = "${hour}h $min";

    if (hour == 0) {
      format = "${min}m";
    }

    return format;
  }

  static Workout fromJson(Map<String, dynamic> jsonformat) {
    Workout newWorkout = Workout(
        name: jsonformat['name'],
        exercises: []
    );
    newWorkout.workoutDurationInSec = jsonformat['workoutDurationInSec'];
    List<dynamic> exercisesData = jsonformat['exercises'];
    for (var exerciseData in exercisesData) {
      Exercise exercise = Exercise(
          name: exerciseData['name'],
          sets: []);
      exerciseData['sets'].forEach((setData) {
        Set set = Set(
            index: setData['index'],
            weight: setData['weight'],
            reps: setData['reps'],
            isCompleted: setData['isCompleted']);
        exercise.sets.add(set);
      });
      newWorkout.exercises.add(exercise);
    }

    return newWorkout;
  }
}
