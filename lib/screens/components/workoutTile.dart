import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class WorkoutTile extends StatelessWidget {
  final String workoutName;
  final Function(BuildContext)? editTapped;
  final Function(BuildContext)? deleteTapped;

  const WorkoutTile({
    super.key,
    required this.workoutName,
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
          child: Row(
            children: [
              // workout name
              Text(workoutName),
            ],
          ),
        ),
      ),
    );
  }
}