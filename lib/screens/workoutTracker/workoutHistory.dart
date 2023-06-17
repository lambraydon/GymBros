import 'package:flutter/material.dart';
import 'package:gymbros/screens/workoutTracker/logger.dart';
import 'package:gymbros/screens/workoutTracker/workoutData.dart';
import 'package:provider/provider.dart';

class WorkoutHistory extends StatefulWidget {
  @override
  State<WorkoutHistory> createState() => _WorkoutHistoryState();
}

class _WorkoutHistoryState extends State<WorkoutHistory> {
  // text controller
  final newWorkoutNameController = TextEditingController();

  // create new workout
  void createNewWorkout() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Create new workout"),
          content: TextField(
            controller: newWorkoutNameController,
        ),
        actions: [
          // save button
          MaterialButton(
            onPressed: save,
            child: const Text("save"),
          ),
          // cancel button
          MaterialButton(
            onPressed: cancel,
            child: const Text("cancel"),
          )
        ],
        )
    );
  }

  // Redirect to Logger
  void goToLogger(String workoutName) {
    Navigator.push(
        context, 
        MaterialPageRoute(
            builder: (context) => Logger(
              workoutName: workoutName,
            )
        ));
  }

  // save workout name
  void save() {
    String newWorkoutName = newWorkoutNameController.text;
    // add workout to workout list
    Provider.of<WorkoutData>(context, listen: false).addWorkout(newWorkoutName);

    // pop dialog box
    Navigator.pop(context);
    clear();
  }

  // cancel workout
  void cancel() {
    // pop dialog box
    Navigator.pop(context);
    clear();
  }

  // clear controller
  void clear() {
    newWorkoutNameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: const Text('Workout History'),
        ),
        backgroundColor: Colors.purple[50],
        floatingActionButton: FloatingActionButton(
          onPressed: createNewWorkout,
          child: const Icon(Icons.not_started_outlined)
        ),
        body: ListView.builder(
            itemCount: value.getWorkoutList().length,
            itemBuilder: (context, index) => ListTile(
              title: Text(value.getWorkoutList()[index].name),
              trailing: IconButton(
                icon: const Icon(Icons.arrow_forward_ios_rounded),
                onPressed: () =>
                    goToLogger(value.getWorkoutList()[index].name),
              ),
            )
        ),
      ),
    );
  }
}

