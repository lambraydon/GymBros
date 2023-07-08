import 'package:flutter/material.dart';
import 'package:gymbros/shared/constants.dart';
import 'package:gymbros/shared/customTextButton.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:async';

class RestTimer extends StatefulWidget {
  final int totalTime;

  const RestTimer({super.key, required this.totalTime});

  @override
  State<RestTimer> createState() => _RestTimerState();
}

class _RestTimerState extends State<RestTimer> {
  double percent = 0;
  int totalTime = 90;
  int init = 90;

  int min = 0;
  int sec = 0;
  int initMin = 0;
  int initSec = 0;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    totalTime = widget.totalTime * 100;
    sec = totalTime % 6000;
    min = totalTime ~/ 6000;

    init = totalTime;
    initSec = init % 6000;
    initMin = init ~/ 6000;

    Timer.periodic(const Duration(milliseconds: 10), (timer) {
      setState(() {
        if (totalTime > 0) {
          totalTime--;
          sec = totalTime % 6000;
          min = totalTime ~/ 6000;
          initSec = init % 6000;
          initMin = init ~/ 6000;
          percent += 1 / init;
        } else {
          timer.cancel();
          Navigator.pop(context);
        }
      });
    });
  }

  void modifyTime(int modification) {
    totalTime += modification * 100;
    init += modification * 100;
    if (totalTime < 100) {
      percent = 0;
      totalTime = 0;
    } else {
      percent = 1 - totalTime / init;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
        child: SizedBox(
            height: 400,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    height: 0,
                  ),
                  const Text("Auto Rest Timer"),
                  CircularPercentIndicator(
                    lineWidth: 7,
                    percent: percent,
                    radius: 130,
                    animateFromLastPercent: true,
                    backgroundColor: Colors.grey,
                    progressColor: appBarColor,
                    circularStrokeCap: CircularStrokeCap.round,
                    center: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          sec / 100 < 10
                              ? "$min:0${sec ~/ 100}"
                              : "$min:${sec ~/ 100}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 48.0),
                        ),
                        Text(
                          initSec / 100 < 10
                              ? "$initMin:0${initSec ~/ 100}"
                              : "$initMin:${initSec ~/ 100}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24.0,
                              color: Colors.black12),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomTextButton(
                          onPressed: () {
                            modifyTime(-10);
                          },
                          buttonText: "-10s",
                          color: Colors.grey),
                      CustomTextButton(
                          onPressed: () {
                            modifyTime(10);
                          },
                          buttonText: "+10s",
                          color: Colors.grey),
                      CustomTextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          buttonText: "Skip",
                          color: appBarColor),
                    ],
                  )
                ],
              ),
            )));
  }
}
