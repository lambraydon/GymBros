import 'package:flutter/material.dart';
import 'package:gymbros/screens/home/analytics/goalsetpage.dart';
import 'package:gymbros/screens/home/analytics/lineChart.dart';
import 'package:gymbros/screens/workoutTracker/exercise.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import '../../../services/auth_service.dart';
import '../../../services/database_service.dart';
import '../../../shared/constants.dart';
import '../../calendar/calendar.dart';
import '../../calendar/calendar_utils.dart';
import '../../workoutTracker/gym_exercise_list.dart';
import '../../workoutTracker/workout.dart';
import '../../workoutTracker/workout_data.dart';
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
  int workoutFrequency = 0;
  int workoutLen = 0;
  int actualFrequency = 0;
  int actualLen = 0;
  final DatabaseService db = DatabaseService(uid: AuthService().getUid());

  List<Color> gradientColors = [appBarColor, greyColor];

  @override
  void initState() {
    workoutFrequency = widget.workoutFrequency;
    workoutLen = widget.workoutLen;
    actualFrequency = widget.actualFrequency;
    actualLen = widget.actualLen;
    super.initState();
  }

  // get DateTime representing the start date of the week
  DateTime getStartOfWeek(DateTime dateTime) {
    int difference = dateTime.weekday - DateTime.monday;

    if (difference < 0) {
      difference = -difference;
    }

    DateTime startOfWeek = dateTime.subtract(Duration(days: difference));

    return startOfWeek;
  }

  // get DateTime representing the end date of the week
  DateTime getEndOfWeek(DateTime dateTime) {
    int difference = DateTime.sunday - dateTime.weekday;

    if (difference < 0) {
      difference = -difference;
    }

    DateTime endOfWeek = dateTime.add(Duration(days: difference));

    return endOfWeek;
  }

  // get list of workouts completed this week
  List<Workout> getWorkoutsThisWeek() {
    DateTime start = getStartOfWeek(DateTime.now());
    DateTime end = getEndOfWeek(DateTime.now());
    return CalendarUtils.getEventsForRange(start, end,
        Provider.of<WorkoutData>(context, listen: false).workoutList);
  }

  // get actual workout frequency this week
  int getNumWorkoutsThisWeek() {
    List<Workout> workoutList = getWorkoutsThisWeek();
    return workoutList.length;
  }

  // get actual duration this week
  int getDurationThisWeek() {
    List<Workout> workoutList = getWorkoutsThisWeek();
    int timeInSec = 0;

    for (var workout in workoutList) {
      timeInSec += workout.workoutDurationInSec;
    }

    return timeInSec;
  }

  // get freq and duration goals from db
  void getGoal() async {
    int freq = await db.getWorkoutFrequencyFromDb();
    int len = await db.getWorkoutLengthFromDb();

    setState(() {
      workoutFrequency = freq;
      actualLen = len;
    });
  }

  void syncData() {
    setState(() {
      getGoal();
      actualFrequency= getNumWorkoutsThisWeek();
      actualLen = getDurationThisWeek();
    });
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
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
            onPressed: syncData,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  vertical: 12.0, horizontal: 16.0),
              decoration: BoxDecoration(
                color: appBarColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                "Sync Workout Data",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
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
                                  Text("Target: $workoutFrequency"),
                                  Text("Actual: $actualFrequency"),
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
                            percent: actualFrequency >=
                                    workoutFrequency
                                ? 1.0
                                : actualFrequency /
                                    workoutFrequency,
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
                                  workoutFrequency == 0
                                      ? "0"
                                      : "${((actualFrequency / workoutFrequency) * 100).round()}%",
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "Target: ${workoutFrequency * workoutLen} mins"),
                                Text(
                                    "Actual: ${(actualLen / 60).round()} mins"),
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
                          percent: (actualLen / 60) /
                                      (workoutFrequency *
                                          workoutLen) >=
                                  1
                              ? 1.0
                              : (actualLen / 60) /
                                  (workoutFrequency * workoutLen),
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
                                workoutFrequency == 0 ||
                                        workoutLen == 0
                                    ? "0"
                                    : "${((actualLen / 60) / (workoutFrequency * workoutLen) * 100).round()}%",
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
                  physics: const ClampingScrollPhysics(),
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
