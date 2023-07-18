import 'gymExerciseList.dart';

class ExerciseData {
  List<Map<String, dynamic>> exerciseList =
  gymExercises.map((e) => {"name": e, "history": []}).toList();

}

