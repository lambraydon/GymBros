class Set {
  final int index;
  final double weight;
  final int reps;
  bool isCompleted;

  Set({
    required this.index,
    required this.weight,
    required this.reps,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() {
    return {"index": index, "weight": weight, "reps": reps};
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
