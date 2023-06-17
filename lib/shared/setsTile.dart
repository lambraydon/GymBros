import 'package:flutter/material.dart';

class setsTile extends StatelessWidget {
  final int index;
  final double weight;
  final int reps;
  final bool isCompleted;
  void Function(bool?)? onCheckBoxChanged;

  setsTile(
      {super.key,
      required this.weight,
      required this.reps,
      required this.index,
      required this.isCompleted,
      required this.onCheckBoxChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[20],
      child: ListTile(
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Chip(
              label: Text(
                index.toString(),
              ),
            ),
            const Chip(
              label: Text("-"),
            ),
            Chip(
                label: Text(
              weight.toString(),
            )),
            Chip(
              label: Text(reps.toString()),
            )
          ],
        ), trailing: Checkbox(
        value: isCompleted,
        onChanged: (value) => onCheckBoxChanged!(value),
      ),
      ),
    );
  }
}
