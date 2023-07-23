import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gymbros/screens/home/analytics/goalsetpage.dart';
import 'package:gymbros/screens/home/analytics/lineChart.dart';
import 'package:gymbros/screens/workoutTracker/exercise.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import '../../../shared/constants.dart';
import '../../calendar/calendar.dart';
import '../../workoutTracker/gymExerciseList.dart';
import '../../workoutTracker/workoutData.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalyticsView extends StatefulWidget {
  const AnalyticsView(
      {super.key,
      required this.actualFrequency,
      required this.workoutFrequency,
      required this.workoutLen,
      required this.actualLen});

  final int workoutFrequency;
  final int workoutLen;
  final int actualFrequency;
  final int actualLen;

  @override
  State<AnalyticsView> createState() => _AnalyticsViewState();
}

class _AnalyticsViewState extends State<AnalyticsView> {
  // final DatabaseService db = DatabaseService(uid: AuthService().getUid());
  // int workoutFrequency = 0;
  // int workoutLen = 0;
  // int actualFrequency = 0;
  // int actualLen = 0;

  List<Color> gradientColors = [appBarColor, greyColor];

  @override
  void initState() {
    setState(() {
      log("hello");
      // actualFrequency = getNumWorkoutsThisWeek();
      // actualLen = getDurationThisWeek();
      //getGoal();
    });
    super.initState();
  }

  Exercise findExerciseWithMaxOneRM(List<Exercise> exercises) {
    if (exercises.isEmpty) {
      throw ArgumentError("The list of exercises is empty.");
    }

    return exercises.reduce((currExercise, nextExercise) {
      final double currMaxOneRM = currExercise.bestOneRM();
      final double nextMaxOneRM = nextExercise.bestOneRM();
      return currMaxOneRM >= nextMaxOneRM ? currExercise : nextExercise;
    });
  }

  Exercise findExerciseWithMinOneRM(List<Exercise> exercises) {
    if (exercises.isEmpty) {
      throw ArgumentError("The list of exercises is empty.");
    }

    return exercises.reduce((currExercise, nextExercise) {
      final double currMinOneRM = currExercise.bestOneRM();
      final double nextMinOneRM = nextExercise.bestOneRM();
      return currMinOneRM <= nextMinOneRM ? currExercise : nextExercise;
    });
  }

  // return points for line chart based on exercises
  List<FlSpot> points(List<Exercise> exercises) {
    //log(exercises[2].bestOneRM().toString());
    List<FlSpot> spots = [];
    for (int i = 1; i < exercises.length; i++) {
      spots.add(FlSpot(i.toDouble(), exercises[i].bestOneRM()));
    }
    return spots;
  }

  // return List of exercise
  List<Exercise>? topExercise(
      List<Map<String, List<Exercise>>> exerciseList, int index) {
    return exerciseList[index]["history"];
  }

  // return line chart for exercise
  AspectRatio createChart(List<Exercise>? exercises) {
    List<Color> gradientFade =
        gradientColors.map((e) => e.withOpacity(0.3)).toList();
    return AspectRatio(
        aspectRatio: 2,
        child: SizedBox(
          child: LineChart(
            LineChartData(
              backgroundColor: Colors.black12,
              minX: 0,
              maxX: exercises?.length.toDouble(),
              minY: findExerciseWithMinOneRM(exercises!).bestOneRM(),
              maxY: findExerciseWithMaxOneRM(exercises).bestOneRM() + 10,
              gridData: FlGridData(
                show: true,
                getDrawingHorizontalLine: (value) {
                  return const FlLine(
                    color: Color(0xff37434d),
                    strokeWidth: 1,
                  );
                },
                drawVerticalLine: false,
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: points(exercises),
                  isCurved: true,
                  barWidth: 5,
                  color: appBarColor,
                  gradient: LinearGradient(colors: gradientColors),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(colors: gradientFade),
                  ),
                )
              ],
              titlesData: const FlTitlesData(
                bottomTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true, interval: 1.0)),
                leftTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: true)),
                topTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(5),
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.only(left: 15, bottom: 15),
          margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Section Name
              InkWell(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const GoalSetPage())),
                child: const Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Row(children: [
                    Expanded(flex: 2, child: Text('🎯   Set your goals!')),
                    Padding(
                        padding: EdgeInsets.only(right: 16),
                        child: Icon(Icons.keyboard_arrow_right))
                  ]),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(19.0),
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Calendar(
                          workoutList:
                              Provider.of<WorkoutData>(context, listen: false)
                                  .workoutList)));
            },
            child: Container(
                height: 130,
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 85,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Workouts Per Week",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Column(
                                children: [
                                  Text("Target: ${widget.workoutFrequency}"),
                                  Text("Actual: ${widget.actualFrequency}"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return CircularPercentIndicator(
                            lineWidth: 10,
                            percent: widget.actualFrequency >=
                                    widget.workoutFrequency
                                ? 1.0
                                : widget.actualFrequency /
                                    widget.workoutFrequency,
                            radius: 45,
                            animation: true,
                            animationDuration: 2000,
                            backgroundColor: Colors.grey.shade100,
                            progressColor: appBarColor,
                            circularStrokeCap: CircularStrokeCap.round,
                            center: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  widget.workoutFrequency == 0
                                      ? "0"
                                      : "${((widget.actualFrequency / widget.workoutFrequency) * 100).round()}%",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  ],
                )),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 19.0),
          child: Container(
              height: 130,
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 85,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Duration Per Week",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Column(
                              children: [
                                Text(
                                    "Target: ${widget.workoutFrequency * widget.workoutLen} mins"),
                                Text(
                                    "Actual: ${(widget.actualLen / 60).round()} mins"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return CircularPercentIndicator(
                          lineWidth: 10,
                          percent: (widget.actualLen / 60) /
                                      (widget.workoutFrequency *
                                          widget.workoutLen) >=
                                  1
                              ? 1.0
                              : (widget.actualLen / 60) /
                                  (widget.workoutFrequency * widget.workoutLen),
                          radius: 45,
                          animation: true,
                          animationDuration: 2000,
                          backgroundColor: Colors.grey.shade100,
                          progressColor: appBarColor,
                          circularStrokeCap: CircularStrokeCap.round,
                          center: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.workoutFrequency == 0 ||
                                        widget.workoutLen == 0
                                    ? "0"
                                    : "${((widget.actualLen / 60) / (widget.workoutFrequency * widget.workoutLen) * 100).round()}%",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                ],
              )),
        ),
        Padding(
          padding: const EdgeInsets.all(19.0),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(38, 30, 0, 0),
                  child: Text(
                    "Favourite Exercises",
                    style:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (int i = 0; i < 5; i++)
                        if (topExercise(
                                ExerciseData.initialiseExerciseList(
                                    Provider.of<WorkoutData>(context,
                                            listen: false)
                                        .workoutList),
                                i)!
                            .isNotEmpty)
                          SizedBox(
                            width: 350, // Set a specific width here
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 19.0, vertical: 19),
                              child: LineChartSample2(
                                exercises: topExercise(
                                    ExerciseData.initialiseExerciseList(
                                        Provider.of<WorkoutData>(context,
                                                listen: false)
                                            .workoutList),
                                    i),
                              ),
                            ),
                          ),
                    ],
                  ),
                ),
                const SizedBox(height: 30,)
              ],
            ),
          ),
        )
      ],
    );
  }
}
