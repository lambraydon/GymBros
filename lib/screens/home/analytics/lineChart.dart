import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gymbros/shared/constants.dart';

import '../../workoutTracker/exercise.dart';

class LineChartSample2 extends StatefulWidget {
  const LineChartSample2({super.key, required this.exercises});

  final List<Exercise>? exercises;

  @override
  State<LineChartSample2> createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<LineChartSample2> {
  List<Color> gradientColors = [appBarColor, greyColor];

  bool showAvg = false;

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
    List<FlSpot> spots = [];
    for (int i = 0; i < exercises.length; i++) {
      spots.add(FlSpot(i.toDouble(), exercises[i].bestOneRM()));
    }
    return spots;
  }

  // return points for line chart based on exercises
  List<FlSpot> avgPoints(List<Exercise> exercises) {
    double total = 0;
    List<FlSpot> spots = [];
    for (int i = 0; i < exercises.length; i++) {
      total += exercises[i].bestOneRM();
    }
    for (int i = 0; i < exercises.length; i++) {
      spots.add(FlSpot(i.toDouble(), (total / exercises.length).toDouble()));
    }

    return spots;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: backgroundColor, borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.exercises![0].name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20.0, color: appBarColor),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(8)),
              child: Stack(
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 1.70,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        right: 18,
                        left: 12,
                        top: 34,
                        bottom: 12,
                      ),
                      child: LineChart(
                        showAvg ? avgData() : mainData(),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 60,
                    height: 30,
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          showAvg = !showAvg;
                        });
                      },
                      child: Text(
                        'avg',
                        style: TextStyle(
                          fontSize: 12,
                          color: showAvg
                              ? Colors.white.withOpacity(0.5)
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                    decoration: BoxDecoration(
                        color: Colors.lightBlueAccent.shade100,
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 6),
                      child: Text("Attempts: ${widget.exercises!.length}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12.0,
                              color: appBarColor)),
                    )),
                const SizedBox(width: 5,),
                Container(
                  decoration: BoxDecoration(
                      color: const Color(0xFFD4AF37),
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 6),
                    child: Text(
                        "PR: ${findExerciseWithMaxOneRM(widget.exercises!).bestOneRM().toString()} kg",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0,
                            color: Color(0xFFB8860B))),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  // Widget bottomTitleWidgets(double value, TitleMeta meta) {
  //   const style = TextStyle(
  //     fontWeight: FontWeight.bold,
  //     fontSize: 16,
  //   );
  //   Widget text;
  //   switch (value.toInt()) {
  //     case 2:
  //       text = const Text('MAR', style: style);
  //       break;
  //     case 5:
  //       text = const Text('JUN', style: style);
  //       break;
  //     case 8:
  //       text = const Text('SEP', style: style);
  //       break;
  //     default:
  //       text = const Text('', style: style);
  //       break;
  //   }
  //
  //   return SideTitleWidget(
  //     axisSide: meta.axisSide,
  //     child: text,
  //   );
  // }
  //
  // Widget leftTitleWidgets(double value, TitleMeta meta) {
  //   const style = TextStyle(
  //     fontWeight: FontWeight.bold,
  //     fontSize: 15,
  //   );
  //   String text;
  //   switch (value.toInt()) {
  //     case 1:
  //       text = '10K';
  //       break;
  //     case 3:
  //       text = '30k';
  //       break;
  //     case 5:
  //       text = '50k';
  //       break;
  //     default:
  //       return Container();
  //   }
  //
  //   return Text(text, style: style, textAlign: TextAlign.left);
  // }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: false,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            strokeWidth: 1,
          );
        },
      ),
      titlesData: const FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 20,
            // getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: widget.exercises?.length.toDouble(),
      minY: findExerciseWithMinOneRM(widget.exercises!).bestOneRM(),
      maxY: findExerciseWithMaxOneRM(widget.exercises!).bestOneRM(),
      lineBarsData: [
        LineChartBarData(
          spots: points(widget.exercises!),
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData avgData() {
    return LineChartData(
      gridData: FlGridData(
        show: false,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            strokeWidth: 1,
          );
        },
      ),
      titlesData: const FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 20,
            // getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: widget.exercises?.length.toDouble(),
      minY: findExerciseWithMinOneRM(widget.exercises!).bestOneRM(),
      maxY: findExerciseWithMaxOneRM(widget.exercises!).bestOneRM(),
      lineBarsData: [
        LineChartBarData(
          spots: avgPoints(widget.exercises!),
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
