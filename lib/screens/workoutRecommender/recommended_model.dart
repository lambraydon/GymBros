import 'package:gymbros/screens/workoutTracker/exercise.dart';
import '../workoutTracker/workout.dart';

class RecommenderModel {
  final Workout workout;
  final String description;

  RecommenderModel({required this.workout, required this.description});

  factory RecommenderModel.fromJson(Map<dynamic, dynamic> json) {
    Workout recommendedWorkout =
        Workout(name: json["name"].toString(), exercises: []);

    for (int index = 0; index < json["exercises"].length; index++) {
      Exercise exercise =
          Exercise(name: json["exercises"][index]["name"].toString(), sets: []);
      for (int i = 0; i < json["exercises"][index]["sets"]; i++) {
        double weight = json["exercises"][index]["weight"].toDouble() > 0
            ? json["exercises"][index]["weight"].toDouble()
            : 60.0;

        exercise.addSet(weight, json["exercises"][index]["reps"]);
      }
      recommendedWorkout.addExercise(exercise);
    }

    return RecommenderModel(
        workout: recommendedWorkout, description: json["description"]);
  }
}
