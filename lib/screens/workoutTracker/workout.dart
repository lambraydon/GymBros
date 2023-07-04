import 'exercise.dart';

class Workout {
  final String name;
  final List<Exercise> exercises;
  String workoutId = 'not set';

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

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "exercises": exercises.map((exercise) => exercise.toJson()).toList()
    };
  }

  List<String> workoutSummary() {
    return exercises.map((exercise) => exercise.toString()).toList();
  }
}
