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

  Map<String, dynamic> toJson() {
    return {"name": name, "sets": sets.map((set) => set.toJson()).toList()};
  }
}