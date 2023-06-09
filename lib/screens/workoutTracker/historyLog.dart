import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gymbros/screens/workoutTracker/exercise.dart';
import 'package:gymbros/screens/workoutTracker/set.dart';
import 'package:gymbros/screens/workoutTracker/workout.dart';
import 'package:gymbros/screens/workoutTracker/workoutData.dart';
import 'package:gymbros/shared/constants.dart';
import 'package:gymbros/shared/setsTile.dart';
import 'package:provider/provider.dart';
import 'package:gymbros/services/authservice.dart';
import 'package:gymbros/services/databaseservice.dart';

class HistoryLog extends StatefulWidget {
  final Workout workout;
  final DatabaseService db = DatabaseService(uid: AuthService().getUid());

  HistoryLog({super.key, required this.workout});

  @override
  State<HistoryLog> createState() => _HistoryLog();
}

class _HistoryLog extends State<HistoryLog> {
  //Global key for animated list
  final GlobalKey<AnimatedListState> _key1 = GlobalKey();
  final List<GlobalKey<AnimatedListState>> _listKeys =
      List.generate(100, (index) => GlobalKey());

  // Checkbox was tapped
  void onCheckBoxChanged(Set set) {
    Provider.of<WorkoutData>(context, listen: false)
        .checkOffSet(set);
  }

  // text controllers
  final exerciseNameController = TextEditingController();
  final weightController = TextEditingController();
  final repsController = TextEditingController();

  // Create a new exercise
  void createNewExercise() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Add a new exercise"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // exercise name
              TextField(
                  controller: exerciseNameController,
                  decoration: textInputDecoration2("Exercise Name"))
            ],
          ),
          actions: [
            // save button
            MaterialButton(
              onPressed: saveExercise,
              child: const Text("save"),
            ),
            // cancel button
            MaterialButton(
              onPressed: cancelExercise,
              child: const Text("cancel"),
            )
          ],
        ));
  }

  // save exercise name
  void saveExercise() {
    String newExerciseName = exerciseNameController.text;
    // create new exercise object with empty sets
    Exercise exercise = Exercise(name: newExerciseName, sets: []);

    // add exercise to exercise list
    widget.workout.addExercise(exercise);

    // pop dialog box
    Navigator.pop(context);
    clearExercise();

    int numExercise = widget.workout.exercises.length;

    // animation
    _key1.currentState!
        .insertItem(numExercise - 1, duration: const Duration(seconds: 1));
  }

  // cancel workout
  void cancelExercise() {
    // pop dialog box
    Navigator.pop(context);
    clearExercise();
  }

  // clear controller
  void clearExercise() {
    exerciseNameController.clear();
  }

  // Create a new set
  void createNewSet(Exercise exercise) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Add Set"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // weight
              TextField(
                controller: weightController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: textInputDecoration2("Weight"),
              ),
              const SizedBox(
                height: 16,
              ),
              // reps
              TextField(
                  controller: repsController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: textInputDecoration2("Reps"))
            ],
          ),
          actions: [
            // save button
            MaterialButton(
              onPressed: () {
                saveSet(exercise);
              },
              child: const Text("save"),
            ),
            // cancel button
            MaterialButton(
              onPressed: cancelSet,
              child: const Text("cancel"),
            )
          ],
        ));
  }

  // save set
  void saveSet(Exercise exercise) {
    double newWeight = double.parse(weightController.text);
    int newReps = int.parse(repsController.text);

    // add set to set list
    exercise.addSet(newWeight, newReps);

    // pop dialog box
    Navigator.pop(context);
    clearSet();

    int exerciseIndex = widget.workout.exercises.indexOf(exercise);

    int numSet = exercise.sets.length;

    // animation
    _listKeys[exerciseIndex]
        .currentState!
        .insertItem(numSet - 1, duration: const Duration(seconds: 1));
  }

  // cancel set
  void cancelSet() {
    // pop dialog box
    Navigator.pop(context);
    clearSet();
  }

  // clear weight and reps controller
  void clearSet() {
    weightController.clear();
    repsController.clear();
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.cancel_presentation_outlined),
              color: appBarColor
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: <Widget>[
            Text(
              widget.workout.name,
              style: const TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 64.0,
            ),
            AnimatedList(
                key: _key1,
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                initialItemCount: widget.workout.numberOfExercises(),
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                itemBuilder: (context, index, animation) {
                  return SizeTransition(
                      key: UniqueKey(),
                      sizeFactor: animation,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget.workout.exercises[index].name,
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(
                              height: 16.0,
                            ),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Set",
                                  style: TextStyle(fontWeight: FontWeight.w800),
                                ),
                                Text("Best Set",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w800)),
                                Text("Weight (kg)",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w800)),
                                Text("Reps",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w800)),
                                Icon(Icons.check)
                              ],
                            ),
                            AnimatedList(
                                key: _listKeys[index],
                                shrinkWrap: true,
                                physics: const ClampingScrollPhysics(),
                                initialItemCount:
                                    widget.workout.exercises[index].sets.length,
                                itemBuilder: (context, int num, animation) {
                                  return SizeTransition(
                                      key: UniqueKey(),
                                      sizeFactor: animation,
                                      child: SetsTile(
                                        set: widget.workout.exercises[index].sets[num],
                                        onCheckBoxChanged: (val) {
                                          return onCheckBoxChanged(widget.workout
                                              .exercises[index].sets[num]);},
                                      ));
                                }),
                            ElevatedButton.icon(
                                onPressed: () {
                                  createNewSet(widget.workout.exercises[index]);
                                },
                                icon: const Icon(
                                  Icons.add,
                                ),
                                label: const Text(
                                  "Add Set",
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.grey),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                          side: const BorderSide(
                                              color: Colors.grey))),
                                  elevation:
                                      MaterialStateProperty.all<double>(0),
                                  minimumSize: MaterialStateProperty.all<Size>(
                                      const Size(400, 28)),
                                )),
                          ],
                        ),
                      ));
                }),
          ],
        ),
      ),
    );
  }
}
