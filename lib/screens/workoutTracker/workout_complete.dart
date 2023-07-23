import 'package:flutter/material.dart';
import 'package:gymbros/screens/socialmedia/new_post.dart';
import 'package:gymbros/screens/workoutTracker/workout.dart';
import 'package:gymbros/screens/workoutTracker/workout_data.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../services/database_service.dart';
import '../../shared/constants.dart';
import '../components/workout_tile.dart';
import 'history_log.dart';
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
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Workout Completed!",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32.0),
                  textAlign: TextAlign.center,
                ),
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
                  }),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 120,
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      decoration: BoxDecoration(
                        color: greyColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        "Skip",
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10,),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      goToNewPost(widget.workout);
                    },
                    child: Container(
                      width: 120,
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      decoration: BoxDecoration(
                        color: appBarColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        "Share Workout",
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        ConfettiWidget(
          confettiController: controller,
          shouldLoop: false,
          blastDirectionality: BlastDirectionality.explosive,
        )
      ]),
    );
  }
}
