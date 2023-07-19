import 'package:flutter/material.dart';
import 'package:gymbros/screens/socialmedia/newpost.dart';
import 'package:gymbros/screens/workoutTracker/workout.dart';
import 'package:gymbros/screens/workoutTracker/workoutData.dart';
import 'package:provider/provider.dart';
import '../../services/authservice.dart';
import '../../services/databaseservice.dart';
import '../../shared/constants.dart';
import '../components/workoutTile.dart';
import 'historyLog.dart';
import 'package:confetti/confetti.dart';

class WorkoutComplete extends StatefulWidget {
  final Workout workout;

  const WorkoutComplete({super.key, required this.workout});

  @override
  State<WorkoutComplete> createState() => _WorkoutCompleteState();
}

class _WorkoutCompleteState extends State<WorkoutComplete> {
  final DatabaseService db = DatabaseService(uid: AuthService().getUid());
  final controller = ConfettiController();

  @override
  void initState() {
    super.initState();
    controller.play();
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

  void goToNewPost(Workout workout) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NewPost(
              workout: workout,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Stack(children: [
        Scaffold(
          backgroundColor: backgroundColor,
          body: ListView(
            children: [
              const SizedBox(
                height: 64.0,
              ),
              TextButton(onPressed: () {Navigator.pop(context);}, child: const Text("Done")),
              TextButton(onPressed: () {goToNewPost(widget.workout);}, child: const Text("Share your workout!")),
              const SizedBox(
                height: 128.0,
              ),
              const Text(
                "Congratulations on Completing your Workout!",
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 24.0),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 32.0,
              ),
              WorkoutTile(
                  workout: widget.workout,
                  editTapped: (context) => goToHistoryLog(widget.workout),
                  deleteTapped: (context) {
                    // delete workout from DB
                    db.deleteWorkoutFromDb(widget.workout);
                    // delete workout from local list
                  })
            ],
          ),
        ),
        ConfettiWidget(confettiController: controller,
        shouldLoop: false,
        blastDirectionality: BlastDirectionality.explosive, )
      ]),
    );
  }
}
