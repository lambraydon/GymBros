import 'package:flutter/material.dart';
import 'package:gymbros/screens/workoutTracker/logger.dart';
import '../workoutTracker/workout.dart';
import 'package:auto_size_text/auto_size_text.dart';

class RecommendedWorkoutTile extends StatelessWidget {
  final Workout workout;

  const RecommendedWorkoutTile({
    super.key,
    required this.workout,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Logger(
                    workout: workout,
                  )));
        },
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
                    "Sets",
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
                        child: AutoSizeText(workout.workoutRecommendSummary()[index]),
                      ),
                      AutoSizeText(workout.exercises[index].bestRecommendedSet().toString()),
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
