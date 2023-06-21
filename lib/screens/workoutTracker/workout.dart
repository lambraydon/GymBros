import 'exercise.dart';

class Workout {
  final String name;
  final List<Exercise> exercises;

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

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "exercises": exercises.map((exercise) => exercise.toJson()).toList()
    };
  }
}
