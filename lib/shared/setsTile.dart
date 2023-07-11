import 'package:flutter/material.dart';
import 'package:gymbros/screens/workoutTracker/set.dart';

class SetsTile extends StatelessWidget {
  final Set set;
  void Function(bool?)? onCheckBoxChanged;

  SetsTile(
      {super.key,
      required this.set,
      required this.onCheckBoxChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[20],
      padding: EdgeInsets.zero,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Chip(
              label: Text(
                set.index.toString(),
              ),
            ),
            const Chip(
              label: Text("-"),
            ),
            Chip(
                label: Text(
              set.weight.toString(),
            )),
            Chip(
              label: Text(set.reps.toString()),
            )
          ],
        ),
        trailing: Checkbox(
          value: set.isCompleted,
          onChanged: (value) {
            onCheckBoxChanged!(value);
          },
        ),
      ),
    );
  }
}
