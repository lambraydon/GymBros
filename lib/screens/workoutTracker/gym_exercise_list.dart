import 'package:gymbros/screens/workoutTracker/exercise.dart';
import 'package:gymbros/screens/workoutTracker/workout.dart';

class ExerciseData {
  static final List<String> gymExercises = [
    'Barbell Squats',
    'Dumbbell Bench Press',
    'Barbell Deadlifts',
    'Dumbbell Shoulder Press',
    'Barbell Bent-Over Rows',
    'Dumbbell Lunges',
    'Barbell Overhead Press',
    'Dumbbell Bicep Curls',
    'Barbell Bench Press',
    'Dumbbell Deadlifts',
    'Barbell Romanian Deadlifts',
    'Dumbbell Bent-Over Rows',
    'Barbell Shoulder Press',
    'Dumbbell Squats',
    'Barbell Bicep Curls',
    'Dumbbell Overhead Press',
    'Barbell Lunges',
    'Dumbbell Chest Flyes',
    'Barbell Upright Rows',
    'Dumbbell Skull Crushers',
    'Barbell Hip Thrusts',
    'Dumbbell Step-ups',
    'Barbell Incline Bench Press',
    'Dumbbell Hammer Curls',
    'Barbell Calf Raises',
    'Dumbbell Reverse Lunges',
    'Barbell Rows',
    'Dumbbell Tricep Kickbacks',
    'Barbell Front Squats',
    'Dumbbell Shoulder Raises',
    'Barbell Shrugs',
    'Dumbbell Goblet Squats',
    'Barbell Preacher Curls',
    'Dumbbell Arnold Press',
    'Barbell Curls',
    'Dumbbell Lateral Raises',
    'Barbell Skull Crushers',
    'Dumbbell Bulgarian Split Squats (Dumbbells)',
    'Dumbbell Bulgarian Split Squats (Barbell)',
    'Barbell Hip Abductions',
    'Dumbbell Concentration Curls',
    'Barbell Good Mornings',
    'Dumbbell Bench Rows',
    'Barbell Calf Raises',
    'Dumbbell Reverse Flyes',
    'Barbell High Pulls',
    'Dumbbell Incline Bench Press',
    'Barbell Hack Squats',
    'Dumbbell Drag Curls',
    'Barbell Decline Bench Press',
    'Dumbbell Front Raises',
    'Smith Machine Squats',
    'Cable Chest Press',
    'Smith Machine Lunges',
    'Cable Lat Pulldowns',
    'Smith Machine Shoulder Press',
    'Cable Bicep Curls',
    'Smith Machine Bent-Over Rows',
    'Cable Tricep Pushdowns',
    'Smith Machine Deadlifts',
    'Cable Shoulder Press',
    'Smith Machine Incline Bench Press',
    'Cable Reverse Flyes',
    'Smith Machine Calf Raises',
    'Cable Lunges',
    'Smith Machine Shrugs',
    'Cable Hamstring Curls',
    'Smith Machine Reverse Lunges',
    'Cable Lateral Raises',
    'Smith Machine Bicep Curls',
    'Cable Glute Kickbacks',
    'Smith Machine Upright Rows',
    'Cable Crunches',
    'Smith Machine Hip Thrusts',
    'Cable Rope Tricep Extensions',
    'Smith Machine Step-ups',
    'Cable Woodchoppers',
    'Smith Machine Bent-Over Reverse Flyes',
    'Cable Seated Rows',
    'Smith Machine Front Squats',
    'Cable Hammer Curls',
    'Smith Machine Calf Raises',
    'Cable Single-Leg Deadlifts',
    'Smith Machine Shoulder Raises',
    'Cable Rope Hammer Curls',
    'Smith Machine Hip Abductions',
    'Cable Squats',
    'Smith Machine Preacher Curls',
    'Cable Chest Flyes',
    'Smith Machine Reverse Grip Rows',
    'Cable Tricep Pushdowns',
    'Smith Machine Romanian Deadlifts',
    'Cable Shoulder Press',
    'Smith Machine Incline Bench Rows',
    'Cable Bicep Curls',
    'Smith Machine Calf Raises',
    'Cable Lateral Lunges',
    'Smith Machine Shrugs',
    'Cable Reverse Crunches',
    'Smith Machine Glute Bridges',
    'Cable Rope Face Pulls',
  ];
  static List<Exercise> dummy() {
    return [];
  }
  static List<Map<String, List<Exercise>>> initialiseExerciseList(
      List<Workout> workoutList) {
    // Initialise list with pre-defined exercises
    List<Map<String, List<Exercise>>> exerciseList = gymExercises
        .map((e) => {
              "name": [Exercise(name: e, sets: [])],
              "history": dummy()
            })
        .toList();

    // Add exercises from all workouts to exerciseList
    for (var workout in workoutList) {
      for (var exercise in workout.exercises) {
        if (!exercise.isEmpty() &&
            exerciseList.any((map) => map["name"]?[0].name == exercise.name)) {
          var elementContainingExercise = exerciseList
              .firstWhere((element) => element["name"]?[0].name == exercise.name);
          elementContainingExercise["history"]?.add(exercise);
        } else if (!exercise.isEmpty()) {
          exerciseList.add({
            "name": [Exercise(name: exercise.name, sets: [])],
            "history": [exercise]
          });
        }
      }
    }

    // Sort exerciseList by the length of "history" in descending order
    exerciseList.sort((a, b) =>
        (b["history"]?.length ?? 0).compareTo(a["history"]?.length ?? 0));

    return exerciseList;
  }
}

