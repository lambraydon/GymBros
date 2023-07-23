import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/workoutTracker/exercise.dart';
import '../screens/workoutTracker/gymExerciseList.dart';
import '../screens/workoutTracker/workoutData.dart';

class ExerciseSearch extends StatefulWidget {
  final void Function(String)? addExercise;

  const ExerciseSearch({Key? key, required this.addExercise}) : super(key: key);

  @override
  State<ExerciseSearch> createState() => _ExerciseSearchState();
}

class _ExerciseSearchState extends State<ExerciseSearch> {
  // This list holds the data for the list view
  List<Map<String, List<Exercise>>> exerciseList = [];
  List<Map<String, List<Exercise>>> _foundExercises = [];

  @override
  initState() {
    // at the beginning, all exercises are shown
    try {
      exerciseList = ExerciseData.initialiseExerciseList(
          Provider.of<WorkoutData>(context, listen: false).workoutList);
      _foundExercises = exerciseList;
    } catch (e) {
      log(e.toString());
    }
    super.initState();
  }

  // This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    List<Map<String, List<Exercise>>> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = exerciseList;
    } else {
      results = exerciseList
          .where((exercise) => exercise["name"]![0].name
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      _foundExercises = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            TextField(
              onChanged: (value) => _runFilter(value),
              decoration: const InputDecoration(
                  labelText: 'Search', suffixIcon: Icon(Icons.search)),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: _foundExercises.isNotEmpty
                  ? ListView.builder(
                      itemCount: _foundExercises.length,
                      itemBuilder: (context, index) => InkWell(
                        onTap: () {
                          widget
                              .addExercise!(_foundExercises[index]['name']![0].name);
                        },
                        child: ListTile(
                          title: Text(_foundExercises[index]['name']![0].name),
                          subtitle: Text(_foundExercises[index]['history']!
                              .length
                              .toString()),
                        ),
                      ),
                    )
                  : const Text(
                      'No results found',
                      style: TextStyle(fontSize: 24),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
