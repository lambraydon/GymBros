class Set {
  final int index;
  double weight;
  int reps;
  bool isCompleted = false;

  Set({
    required this.index,
    required this.weight,
    required this.reps,
    required this.isCompleted,
  });

  Map<String, dynamic> toJson() {
    return {
      "index": index,
      "weight": weight,
      "reps": reps,
      "isCompleted": isCompleted
    };
  }

  // Total volume of set in kg
  double volume() {
    return weight * reps;
  }

  @override
  String toString() {
    return "$weight kg × $reps";
  }
}
