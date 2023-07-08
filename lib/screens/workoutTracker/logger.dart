import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gymbros/screens/workoutTracker/exercise.dart';
import 'package:gymbros/screens/workoutTracker/set.dart';
import 'package:gymbros/screens/workoutTracker/workout.dart';
import 'package:gymbros/screens/workoutTracker/workoutComplete.dart';
import 'package:gymbros/screens/workoutTracker/workoutData.dart';
import 'package:gymbros/shared/restTimer.dart';
import 'package:gymbros/shared/restTimerDialog.dart';
import 'package:gymbros/shared/setsTile.dart';
import 'package:provider/provider.dart';
import 'package:gymbros/services/authservice.dart';
import 'package:gymbros/services/databaseservice.dart';
import '../../shared/constants.dart';

class Logger extends StatefulWidget {
  final Workout workout;
  final DatabaseService db = DatabaseService(uid: AuthService().getUid());

  Logger({super.key, required this.workout});

  @override
  State<Logger> createState() => _LoggerState();
}

class _LoggerState extends State<Logger> {
  //Global key for animated list
  final GlobalKey<AnimatedListState> _key1 = GlobalKey();
  final List<GlobalKey<AnimatedListState>> _listKeys =
      List.generate(100, (index) => GlobalKey());

  // Checkbox was tapped
  void onCheckBoxChanged(Set set) {
    Provider.of<WorkoutData>(context, listen: false).checkOffSet(set);
  }

  // Timer was enabled
  void onSwitchChanged(Exercise exercise) {
    Provider.of<WorkoutData>(context, listen: false).checkOffTimer(exercise);
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

  // Redirect to Completed workout page
  void goToWorkoutComplete(Workout workout) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WorkoutComplete(
                  workout: workout,
                )));
  }

  void timerDialog(Exercise exercise) {
    showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return RestTimerDialog(
                  exercise: exercise,
                  onSwitchChange: (val) => setState(() {
                        exercise.isRestTimer = !exercise.isRestTimer;
                      }));
            }));
  }

  void restTimerViewer(Exercise exercise) {
    showDialog(
        context: context,
        builder: (context) {
          return RestTimer(totalTime: exercise.restTime);
        });
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
            TextButton.icon(
              icon: const Icon(Icons.save_alt_outlined),
              label: const Text('Finish'),
              onPressed: () {
                // Save workout to DB
                widget.db.saveWorkoutToDb(widget.workout);

                // Add workout to local list
                Provider.of<WorkoutData>(context, listen: false)
                    .addWorkout(widget.workout);

                Navigator.pop(context);

                goToWorkoutComplete(widget.workout);
              },
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
                itemBuilder: (context, index, animation) {
                  return Container(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: SizeTransition(
                        key: UniqueKey(),
                        sizeFactor: animation,
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    widget.workout.exercises[index].name,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w500,
                                        color: appBarColor),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        timerDialog(
                                            widget.workout.exercises[index]);
                                      },
                                      icon: const Icon(
                                          Icons.access_time_outlined)),
                                ],
                              ),
                              const SizedBox(
                                height: 16.0,
                              ),
                              const Padding(
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Set",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800),
                                    ),
                                    Text("Best Set",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w800)),
                                    Text("Weight (kg)",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w800)),
                                    Text("Reps",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w800)),
                                    Icon(Icons.check)
                                  ],
                                ),
                              ),
                              AnimatedList(
                                  key: _listKeys[index],
                                  shrinkWrap: true,
                                  physics: const ClampingScrollPhysics(),
                                  initialItemCount: widget
                                      .workout.exercises[index].sets.length,
                                  itemBuilder: (context, int num, animation) {
                                    return SizeTransition(
                                        key: UniqueKey(),
                                        sizeFactor: animation,
                                        child: SetsTile(
                                          set: widget.workout.exercises[index]
                                              .sets[num],
                                          onCheckBoxChanged: (val) {
                                            if (val == true &&
                                                widget.workout.exercises[index]
                                                    .isRestTimer) {
                                              restTimerViewer(widget
                                                  .workout.exercises[index]);
                                            }
                                            return onCheckBoxChanged(widget
                                                .workout
                                                .exercises[index]
                                                .sets[num]);
                                          },
                                        ));
                                  }),
                              ElevatedButton.icon(
                                  onPressed: () {
                                    createNewSet(
                                        widget.workout.exercises[index]);
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
                                    minimumSize:
                                        MaterialStateProperty.all<Size>(
                                            const Size(400, 28)),
                                  )),
                            ],
                          ),
                        )),
                  );
                }),
            const SizedBox(
              height: 64,
            ),
            OutlinedButton(
                onPressed: createNewExercise,
                child: const Text("Add Exercise")),
            const SizedBox(
              height: 32,
            ),
            OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel Workout"))
          ],
        ),
      ),
    );
  }
}
