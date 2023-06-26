import 'package:flutter/material.dart';
import 'package:gymbros/screens/workoutTracker/historyLog.dart';
import 'package:gymbros/screens/workoutTracker/logger.dart';
import 'package:gymbros/screens/workoutTracker/workout.dart';
import 'package:gymbros/screens/workoutTracker/workoutData.dart';
import 'package:provider/provider.dart';
import 'package:gymbros/screens/components/workoutTile.dart';
import '../../shared/constants.dart';
import '../../services/authservice.dart';
import '../../services/databaseservice.dart';

class WorkoutHistory extends StatefulWidget {
  const WorkoutHistory({super.key});

  @override
  State<WorkoutHistory> createState() => _WorkoutHistoryState();
}

class _WorkoutHistoryState extends State<WorkoutHistory> {
  // text controller
  final newWorkoutNameController = TextEditingController();
  final DatabaseService db = DatabaseService(uid: AuthService().getUid());

  // create new workout
  void createNewWorkout() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Create new workout"),
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
            ));
  }

  // Redirect to Logger
  void goToLogger(Workout workout) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Logger(
                  workout: workout,
                )));
  }

  // Redirect to HistoryLog
  void goToHistoryLog(Workout workout) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HistoryLog(
                  workout: workout,
                )));
  }

  // save workout name
  void save() {
    String newWorkoutName = newWorkoutNameController.text;
    // create new empty workout
    Workout workout = Workout(name: newWorkoutName, exercises: []);

    // pop dialog box
    Navigator.pop(context);
    clear();

    // go to Logger
    goToLogger(workout);
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
          backgroundColor: appBarColor,
          title: const Text('Workout History'),
        ),
        backgroundColor: backgroundColor,
        floatingActionButton: FloatingActionButton(
            backgroundColor: appBarColor,
            onPressed: createNewWorkout,
            child: const Icon(Icons.not_started_outlined)),
        body: ListView.builder(
            itemCount: value.getWorkoutList().length,
            itemBuilder: (context, index) {
              return WorkoutTile(
                  workoutName: value.getWorkoutList()[index].name,
                  editTapped: (context) =>
                      goToHistoryLog(value.getWorkoutList()[index]),
                  deleteTapped: (context) {
                    // delete workout from DB
                    db.deleteWorkoutFromDb(value.getWorkoutList()[index]);
                    // delete workout from local list
                    setState(() {
                      value.removeWorkoutFromList(index);
                    });
                  });
            }),
      ),
    );
  }
}
