import 'package:flutter/material.dart';
import '../workoutTracker/workout.dart';
import 'package:auto_size_text/auto_size_text.dart';

class WorkoutTileStatic extends StatelessWidget {
  final Workout workout;

  const WorkoutTileStatic({
    super.key,
    required this.workout,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
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
              style:
                  const TextStyle(fontWeight: FontWeight.w800, fontSize: 16.0),
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
                    Icon(
                      Icons.bar_chart,
                      color: Colors.grey.shade600,
                    ),
                    const AutoSizeText(" 30 kg"),
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
                    AutoSizeText(workout.exercises[index].bestSet().toString()),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
