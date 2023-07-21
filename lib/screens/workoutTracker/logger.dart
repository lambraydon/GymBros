import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gymbros/screens/workoutTracker/exercise.dart';
import 'package:gymbros/screens/workoutTracker/set.dart';
import 'package:gymbros/screens/workoutTracker/workout.dart';
import 'package:gymbros/screens/workoutTracker/workoutComplete.dart';
import 'package:gymbros/screens/workoutTracker/workoutData.dart';
import 'package:gymbros/shared/exerciseSearch.dart';
import 'package:gymbros/shared/restTimer.dart';
import 'package:gymbros/shared/restTimerDialog.dart';
import 'package:provider/provider.dart';
import 'package:gymbros/services/authservice.dart';
import 'package:gymbros/services/databaseservice.dart';
import '../../shared/constants.dart';
import '../../shared/setTiles.dart';

class Logger extends StatefulWidget {
  final Workout workout;
  final DatabaseService db = DatabaseService(uid: AuthService().getUid());

  Logger({super.key, required this.workout});

  @override
  State<Logger> createState() => _LoggerState();
}

class _LoggerState extends State<Logger> {
  @override
  void initState() {
    startWorkoutTimer();
    super.initState();
  }

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
                  onPressed: () {},
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
  void saveExercise(String newExerciseName) {
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
    // add set to set list
    exercise.addSet(0, 0);

    int exerciseIndex = widget.workout.exercises.indexOf(exercise);
    int numSet = exercise.sets.length;

    // animation
    _listKeys[exerciseIndex]
        .currentState!
        .insertItem(numSet - 1, duration: const Duration(milliseconds: 500));
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

  void exerciseSearchDialog() {
    showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return ExerciseSearch(addExercise: saveExercise);
            }));
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

  int workoutTimeInSec = 0;

  void startWorkoutTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        workoutTimeInSec++;
      });
    });
  }

  String workoutTimeString() {
    int sec = workoutTimeInSec % 60;
    int min = workoutTimeInSec ~/ 60 % 60;
    int hour = workoutTimeInSec ~/ 3600;

    String secString = sec < 10 ? "0${sec.toString()}" : sec.toString();
    String minString = min < 10 ? "0${min.toString()}" : min.toString();
    String hourString = hour < 10 ? "0${hour.toString()}" : hour.toString();

    if (hour == 0) {
      if (min < 10) {
        minString = min.toString();
      }
      return "$minString:$secString";
    }

    return "$hourString:$minString:$secString";
  }

  void unfocusTextField() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        unfocusTextField();
      },
      child: Consumer<WorkoutData>(
        builder: (context, value, child) => Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            flexibleSpace: gradientColor,
            elevation: 0.0,
            automaticallyImplyLeading: false,
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  // Store workoutTimeInSec in workout object
                  widget.workout.workoutDurationInSec = workoutTimeInSec;

                  // Save workout to DB
                  widget.db.saveWorkoutToDb(widget.workout);

                  // Add workout to local list
                  Provider.of<WorkoutData>(context, listen: false)
                      .addWorkout(widget.workout);

                  Navigator.pop(context);

                  goToWorkoutComplete(widget.workout);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 12.0),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "Finish",
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(0.0),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  widget.workout.name,
                  style: const TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  workoutTimeString(),
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              ListView.builder(
                  key: _key1,
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: widget.workout.numberOfExercises(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.zero,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    icon:
                                        const Icon(Icons.access_time_outlined)),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 16.0,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: 24,
                                  width: 44,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Set",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 80,
                                  height: 24,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Best Set",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 80,
                                  height: 24,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Weight (kg)",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 80,
                                  height: 24,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Reps",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                    width: 32,
                                    height: 24,
                                    child: Icon(Icons.check_box_rounded))
                              ],
                            ),
                          ),
                          AnimatedList(
                              key: _listKeys[index],
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              initialItemCount:
                                  widget.workout.exercises[index].sets.length,
                              itemBuilder: (context, int num, animation) {
                                return SizeTransition(
                                  sizeFactor: animation,
                                  child: SetTile(
                                    set: widget
                                        .workout.exercises[index].sets[num],
                                    onCheckBoxChanged: (val) {
                                      if (val == true &&
                                          widget.workout.exercises[index]
                                              .isRestTimer) {
                                        restTimerViewer(
                                            widget.workout.exercises[index]);
                                      }
                                      return onCheckBoxChanged(widget
                                          .workout.exercises[index].sets[num]);
                                    },
                                  ),
                                );
                              }),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16.0),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 6),
                              child: InkWell(
                                onTap: () {
                                  saveSet(widget.workout.exercises[index]);
                                },
                                child: Container(
                                  height: 24,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: Colors.white),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add,
                                        color: Colors.black,
                                      ),
                                      Text(
                                        "Add Set",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color: Colors.black),
                                        textAlign: TextAlign.center,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              const SizedBox(
                height: 64,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16.0),
                child: InkWell(
                  onTap: () {
                    exerciseSearchDialog();
                  },
                  child: Container(
                    height: 32,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.lightBlue.shade100),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        "Add Exercise",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade900),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16.0),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 32,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.redAccent.shade100),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        "Cancel Workout",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade900),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
