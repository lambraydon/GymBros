import 'package:flutter/material.dart';
import '../screens/components/mins.dart';
import '../screens/workoutTracker/exercise.dart';

class RestTimerDialog extends StatelessWidget {
  final Exercise exercise;
  void Function(bool?)? onSwitchChange;

  RestTimerDialog(
      {super.key, required this.exercise, required this.onSwitchChange});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.grey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
      child: SizedBox(
        height: 300,
        width: 100,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Text(
                "Auto Rest Timer",
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16.0,
                    color: Colors.white),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    "Enabled",
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16.0,
                        color: Colors.white),
                  ),
                  Switch(
                      value: exercise.isRestTimer,
                      onChanged: (value) {
                        onSwitchChange!(value);
                      }),
                ],
              ),
              Expanded(
                child: Stack(alignment: AlignmentDirectional.center, children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 200,
                        child: ListWheelScrollView.useDelegate(
                            onSelectedItemChanged: (value) {
                              exercise.restTime = value * 5;
                            },
                            controller: FixedExtentScrollController(initialItem: exercise.restTime ~/ 5),
                            itemExtent: 50,
                            perspective: 0.005,
                            diameterRatio: 1.2,
                            useMagnifier: true,
                            magnification: 1.1,
                            physics: const FixedExtentScrollPhysics(),
                            childDelegate: ListWheelChildBuilderDelegate(
                                childCount: 120,
                                builder: (context, index) {
                                  return Mins(mins: index * 5);
                                })),
                      ),
                    ],
                  ),
                  Positioned(
                      child: Container(
                    height: 40,
                    width: 250,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ))
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
