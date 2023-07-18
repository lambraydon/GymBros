import 'package:flutter/material.dart';
import '../screens/workoutTracker/gymExerciseList.dart';

class ExerciseSearch extends StatefulWidget {
  final void Function(String)? addExercise;
  const ExerciseSearch({Key? key, required this.addExercise}) : super(key: key);

  @override
  State<ExerciseSearch> createState() => _ExerciseSearchState();
}

class _ExerciseSearchState extends State<ExerciseSearch> {
  // This list holds the data for the list view
  List<Map<String, dynamic>> exerciseList =
      gymExercises.map((e) => {"name": e, "history": []}).toList();
  List<Map<String, dynamic>> _foundExercises = [];

  @override
  initState() {
    // at the beginning, all users are shown
    _foundExercises = exerciseList;
    super.initState();
  }

  // This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = exerciseList;
    } else {
      results = exerciseList
          .where((exercise) => exercise["name"]
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
                          widget.addExercise!(_foundExercises[index]['name']);
                        },
                        child: ListTile(
                          title: Text(_foundExercises[index]['name']),
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
