import 'set.dart';

class Exercise {
  final String name;
  final List<Set> sets;
  bool isCompleted;

  Exercise({
    required this.name,
    required this.sets,
    this.isCompleted = false,
  });

  // add a set
  void addSet(double weight, int reps) {
    sets.add(Set(
        weight: weight,
        reps: reps,
        index: sets.length + 1
    ));
  }

  // get number of sets in an exercise
  int numberOfSets() {
    return sets.length;
  }

  Map<String, dynamic> toJson() {
    return {"name": name, "sets": sets.map((set) => set.toJson()).toList()};
  }
}