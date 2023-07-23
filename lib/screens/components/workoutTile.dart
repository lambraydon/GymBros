import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../workoutTracker/workout.dart';
import 'package:auto_size_text/auto_size_text.dart';

class WorkoutTile extends StatelessWidget {
  final Workout workout;
  final Function(BuildContext)? editTapped;
  final Function(BuildContext)? deleteTapped;

  const WorkoutTile({
    super.key,
    required this.workout,
    required this.editTapped,
    required this.deleteTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            // settings option
            SlidableAction(
              onPressed: editTapped,
              backgroundColor: Colors.grey.shade800,
              icon: Icons.edit,
              borderRadius: BorderRadius.circular(12),
            ),

            // delete option
            SlidableAction(
              onPressed: deleteTapped,
              backgroundColor: Colors.red.shade400,
              icon: Icons.delete,
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // workout name
              AutoSizeText(
                workout.name,
                style: const TextStyle(
                    fontWeight: FontWeight.w800, fontSize: 16.0),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
              ),
              AutoSizeText(workout.formatDate()),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 2),
              ),
              Row(
                children: [
                  Row(
                    children: [
                      Icon(Icons.bar_chart, color: Colors.grey.shade600,),
                      AutoSizeText("${workout.volume().toString()} kg"),
                    ],
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Row(
                    children: [
                      Transform.scale(
                        scale: 0.8,
                        child: Icon(
                          Icons.access_time_filled,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      AutoSizeText(" ${workout.formatWorkoutDuration()}")
                    ],
                  )
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 3),
              ),
              const Row(
                children: [
                  AutoSizeText(
                    "Exercise",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    width: 120,
                  ),
                  AutoSizeText(
                    "Best Set",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 3),
              ),
              ListView.builder(
                itemCount: workout.workoutSummary().length,
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      SizedBox(
                        width: 173,
                        child: AutoSizeText(workout.workoutSummary()[index]),
                      ),
                      AutoSizeText(
                          workout.exercises[index].bestSet().toString()),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
