import 'package:flutter/material.dart';
import 'package:gymbros/screens/workoutTracker/exercise.dart';
import 'package:gymbros/screens/workoutTracker/set.dart';
import 'package:gymbros/screens/workoutTracker/workout.dart';
import 'package:gymbros/screens/workoutTracker/workout_complete.dart';
import 'package:gymbros/screens/workoutTracker/workout_data.dart';
import 'package:gymbros/shared/constants.dart';
import 'package:provider/provider.dart';
import 'package:gymbros/services/auth_service.dart';
import 'package:gymbros/services/database_service.dart';
import '../../shared/exercise_search.dart';
import '../../shared/set_tiles.dart';

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

  // clear controller
  void clearExercise() {
    exerciseNameController.clear();
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

  // Redirect to Completed workout page
  void goToWorkoutComplete(Workout workout) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WorkoutComplete(
                  workout: workout,
                )));
  }


  // display exercise search
  void exerciseSearchDialog() {
    showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return ExerciseSearch(addExercise: saveExercise);
            }));
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
            backgroundColor: backgroundColor,
            elevation: 0.0,
            automaticallyImplyLeading: false,
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  // update workout in DB
                  widget.db.updateWorkoutInDb(widget.workout);

                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 12.0),
                  decoration: BoxDecoration(
                    color: Colors.lightBlue.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "Edit",
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
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
                  widget.workout.formatWorkoutDuration(),
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
                                      "1RM (kg)",
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
            ],
          ),
        ),
      ),
    );
  }
}
