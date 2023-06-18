import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gymbros/screens/workoutTracker/workoutData.dart';
import 'package:gymbros/shared/setsTile.dart';
import 'package:provider/provider.dart';
import 'package:gymbros/services/authservice.dart';
import 'package:gymbros/services/databaseservice.dart';

class Logger extends StatefulWidget {
  final String workoutName;
  final DatabaseService db = DatabaseService(uid: AuthService().getUid());

  Logger({super.key, required this.workoutName});

  @override
  State<Logger> createState() => _LoggerState();
}

class _LoggerState extends State<Logger> {
  //Global key for animated list
  final GlobalKey<AnimatedListState> _key1 = GlobalKey();
  final List<GlobalKey<AnimatedListState>> _listKeys = List.generate(100, (index) => GlobalKey());

  // Checkbox was tapped
  void onCheckBoxChanged(String workoutName, String exerciseName, int index) {
    Provider.of<WorkoutData>(context, listen: false)
        .checkOffSet(workoutName, exerciseName, index);
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
                  )
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
    // add exercise to exercise list
    Provider.of<WorkoutData>(context, listen: false)
        .addExercise(widget.workoutName, newExerciseName);

    // pop dialog box
    Navigator.pop(context);
    clearExercise();

    int numExercise = Provider.of<WorkoutData>(context, listen: false)
        .getRelevantWorkout(widget.workoutName)
        .exercises
        .length;

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
  void createNewSet(String exerciseName) {
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
                      ]),
                  // reps
                  TextField(
                      controller: repsController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ])
                ],
              ),
              actions: [
                // save button
                MaterialButton(
                  onPressed: () {
                    saveSet(exerciseName);
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
  void saveSet(String exerciseName) {
    double newWeight = double.parse(weightController.text);
    int newReps = int.parse(repsController.text);
    // add set to set list
    Provider.of<WorkoutData>(context, listen: false)
        .addSet(widget.workoutName, exerciseName, newWeight, newReps);

    // pop dialog box
    Navigator.pop(context);
    clearSet();

    int exerciseIndex = Provider.of<WorkoutData>(context, listen: false)
        .getRelevantWorkout(widget.workoutName)
        .exercises
        .indexOf(Provider.of<WorkoutData>(context, listen: false)
            .getRelevantExercise(widget.workoutName, exerciseName));

    int numSet = Provider.of<WorkoutData>(context, listen: false)
        .getRelevantExercise(widget.workoutName, exerciseName)
        .sets
        .length;

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
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          actions: <Widget>[
            TextButton.icon(
              icon: const Icon(Icons.save_alt_outlined),
              label: const Text('Finish'),
              onPressed: () {
                widget.db.saveWorkoutToDb(
                    value.getRelevantWorkout(widget.workoutName));
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: <Widget>[
            Text(widget.workoutName),
            const SizedBox(
              height: 64.0,
            ),
            AnimatedList(
                key: _key1,
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                initialItemCount: value.numberOfExercises(widget.workoutName),
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
                              value
                                  .getRelevantWorkout(widget.workoutName)
                                  .exercises[index]
                                  .name,
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
                                initialItemCount: value
                                    .getRelevantWorkout(widget.workoutName)
                                    .exercises[index]
                                    .sets
                                    .length,
                                itemBuilder: (context, int num, animation) {
                                  return SizeTransition(
                                      key: UniqueKey(),
                                      sizeFactor: animation,
                                      child: setsTile(
                                        weight: value
                                            .getRelevantWorkout(
                                                widget.workoutName)
                                            .exercises[index]
                                            .sets[num]
                                            .weight,
                                        reps: value
                                            .getRelevantWorkout(
                                                widget.workoutName)
                                            .exercises[index]
                                            .sets[num]
                                            .reps,
                                        index: value
                                            .getRelevantWorkout(
                                                widget.workoutName)
                                            .exercises[index]
                                            .sets[num]
                                            .index,
                                        isCompleted: value
                                            .getRelevantWorkout(
                                                widget.workoutName)
                                            .exercises[index]
                                            .sets[num]
                                            .isCompleted,
                                        onCheckBoxChanged: (val) =>
                                            onCheckBoxChanged(
                                          widget.workoutName,
                                          value
                                              .getRelevantWorkout(
                                                  widget.workoutName)
                                              .exercises[index]
                                              .name,
                                          value
                                              .getRelevantWorkout(
                                                  widget.workoutName)
                                              .exercises[index]
                                              .sets[num]
                                              .index,
                                        ),
                                      ));
                                }),
                            ElevatedButton.icon(
                                onPressed: () {
                                  createNewSet(
                                    value
                                        .getRelevantWorkout(widget.workoutName)
                                        .exercises[index]
                                        .name,
                                  );
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
            OutlinedButton(
                onPressed: createNewExercise, child: const Text("Add Exercise"))
          ],
        ),
      ),
    );
  }
}
