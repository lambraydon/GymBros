import 'set.dart';

class Exercise {
  final String name;
  final List<Set> sets;
  bool isCompleted;
  bool isRestTimer;
  int restTime = 90;

  Exercise(
      {required this.name,
      required this.sets,
      this.isCompleted = false,
      this.isRestTimer = false});

  // add a set
  void addSet(double weight, int reps) {
    sets.add(Set(
        weight: weight,
        reps: reps,
        index: sets.length + 1,
        isCompleted: false));
  }

  // get number of sets in an exercise
  int numberOfSets() {
    return sets.length;
  }

  // Find best set by iterating over whole list of sets
  Set bestSet() {
    Set best = sets[0];
    for (int i = 0; i < sets.length; i++) {
      if (sets[i].volume() > best.volume()) {
        best = sets[i];
      }
    }
    return best;
  }

  Map<String, dynamic> toJson() {
    return {"name": name, "sets": sets.map((set) => set.toJson()).toList()};
  }

  @override
  String toString() {
    String exerciseName = "${sets.length} × $name";
    String newExerciseName = "";
    int lenExercise = exerciseName.length;
    int maxLength = 24;

    if (lenExercise > maxLength) {
      for (int i = 0; i < maxLength - 3; i++) {
        newExerciseName += exerciseName[i];
      }
      newExerciseName += "...";
    } else {
      newExerciseName = exerciseName;
    }

    return newExerciseName;
  }
}
