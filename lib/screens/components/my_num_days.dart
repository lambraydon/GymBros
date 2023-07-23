import 'package:flutter/material.dart';

class MyNumDays extends StatelessWidget {
  final int days;
  const MyNumDays ({super.key, required this.days});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Center(
        child: Text(days.toString(),
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black,
          fontWeight: FontWeight.bold
        ),
        )
      ),
    );
  }
}
