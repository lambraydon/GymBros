import 'package:flutter/material.dart';

class Mins extends StatelessWidget {
  final int mins;

  const Mins({super.key, required this.mins});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        child: Center(
          child: Text(
            mins % 60 < 10
                ? "${mins ~/ 60}:0${mins % 60}"
                : "${mins ~/ 60}:${mins % 60}",
            style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
        ),
      ),
    );
  }
}
