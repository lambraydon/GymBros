import 'set.dart';

class Exercise {
  final String name;
  final List<Set> sets;
  DateTime start = DateTime.now();
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
    Set best = Set(weight: 0, reps: 0, index: 0, isCompleted: false);
    for (int i = 0; i < sets.length; i++) {
      if (sets[i].volume() > best.volume() && sets[i].isCompleted) {
        best = sets[i];
      }
    }
    return best;
  }

  // best 1RM
  double bestOneRM() {
    double bestOneRM = 0;
    for (var set in sets) {
      if (set.oneRM() > bestOneRM && set.isCompleted) {
        bestOneRM = set.oneRM();
      }
    }
    return bestOneRM;
  }

  // Find total volume of exercise
  double volume() {
    double volume = 0;
    for (var set in sets) {
      if (set.isCompleted) {
        volume += set.volume();
      }
    }
    return volume;
  }

  // get number of completed sets
  int completedSets() {
    int numCompletedSets = sets.length;

    for (var set in sets) {
      if (!set.isCompleted) {
        numCompletedSets--;
      }
    }

    return numCompletedSets;
  }

  // check if exercise has zero sets completed
  bool isEmpty() {
    return completedSets() == 0 ? true : false;
  }

  Map<String, dynamic> toJson() {
    return {"name": name, "sets": sets.map((set) => set.toJson()).toList()};
  }

  @override
  String toString() {
    String exerciseName = "${completedSets()} × $name";
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

  // Convert recommended workout to String
  String toRecommendString() {
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

  // Find best recommended set by iterating over whole list of sets
  Set bestRecommendedSet() {
    Set best = sets[0];
    for (int i = 0; i < sets.length; i++) {
      if (sets[i].volume() > best.volume()) {
        best = sets[i];
      }
    }
    return best;
  }
}
