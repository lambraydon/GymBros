import 'dart:developer';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:gymbros/screens/workoutRecommender/recommended_workout_tile.dart';
import 'package:gymbros/screens/workoutRecommender/recommended_model.dart';
import 'package:gymbros/shared/constants.dart';
import 'package:gymbros/shared/custom_text_button.dart';
import '../../services/gpt_api_service.dart';
import '../workoutTracker/set.dart';
import '../workoutTracker/exercise.dart';
import '../workoutTracker/workout.dart';
import 'package:http/http.dart' as http;

class WorkoutRecommender extends StatefulWidget {
  const WorkoutRecommender({Key? key}) : super(key: key);

  @override
  State<WorkoutRecommender> createState() => _WorkoutRecommenderState();
}

class _WorkoutRecommenderState extends State<WorkoutRecommender> {
  TextEditingController inputController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  bool _isLoading = false;
  bool _showNewWidget = false;
  bool _showWorkoutTile = false;

  // Textstyles
  FontWeight weight = FontWeight.normal;
  double size = 16;
  Color filled = Colors.white;
  Color text = Colors.black;

  // HintText
  String hintText =
      'Recommend me a one hour long workout targeting the back, shoulders and triceps';

  RecommenderModel model = RecommenderModel(
      workout: Workout(name: "Test Workout", exercises: []),
      description: "Test");

  // Default Workout Object if error occurs
  Workout workout = Workout(name: "Morning Workout", exercises: [
    Exercise(name: "Lateral Raise", sets: [
      Set(index: 1, weight: 10, reps: 10, isCompleted: true),
      Set(index: 2, weight: 10, reps: 10, isCompleted: true)
    ]),
    Exercise(name: "Bench Press", sets: [
      Set(index: 1, weight: 10, reps: 10, isCompleted: true),
      Set(index: 2, weight: 10, reps: 10, isCompleted: true)
    ])
  ]);

  RecommendedWorkoutTile workoutTile = RecommendedWorkoutTile(
      workout: Workout(name: "Test Workout", exercises: []));

  // Default workout description if error occurs
  String description =
      "A comprehensive full-body workout that targets all major muscle groups. This workout is designed to improve strength, endurance, and overall fitness.";

  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }

  void changeTheme() {
    weight = FontWeight.bold;
    size = 15;
    filled = Colors.lightBlueAccent;
    text = Colors.blue.shade800;
  }

  void _onGenerateWorkoutPressed() async {
    setState(() {
      _focusNode.unfocus();

      if (inputController.text.isEmpty) {
        inputController.text = hintText;
      }
      changeTheme();
      _isLoading = true;
    });

    // API call to GPT model
    try {
      model = await GPTApiService(httpClient: http.Client()).sendMessage(
          message: inputController.text, modelId: "gpt-3.5-turbo");
      log(model.description);
      //log(model.workout.toJson().toString());
    } catch (error) {
      log("reached here error");
      log(error.toString());
    }

    setState(() {
      description =
          "${model.description}\n\nClick on the tile below to begin your workout!";
      workoutTile = RecommendedWorkoutTile(workout: model.workout);
      _isLoading = false;
      _showNewWidget = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GestureDetector(
        onTap: () {
          _focusNode.unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('GymBot'),
            backgroundColor: appBarColor,
            actions: [
              CustomTextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  buttonText: "back",
                  color: appBarColor)
            ],
          ),
          body: ListView(children: [
            Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const ClipOval(
                    child: Image(
                      image: AssetImage("assets/chatbot.png"),
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: TextField(
                      controller: inputController,
                      focusNode: _focusNode,
                      style: TextStyle(
                          fontSize: size, fontWeight: weight, color: text),
                      maxLines: null,
                      decoration: InputDecoration(
                        fillColor: filled,
                        filled: true,
                        hintText: hintText,
                        hintMaxLines: 4,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.all(15.0),
                      ),
                      keyboardType: TextInputType.name,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Visibility(
                    visible: !_isLoading && !_showNewWidget,
                    child: TextButton(
                      onPressed: _onGenerateWorkoutPressed,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: appBarColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          "Generate Workout",
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
                  if (_isLoading)
                    const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Colors.blue,
                      ),
                    ),
                  AnimatedOpacity(
                    opacity: _showNewWidget ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeIn,
                    child: _showNewWidget
                        ? Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                children: [
                                  // Padding(
                                  //   padding:
                                  //       const EdgeInsets.fromLTRB(0, 0, 0, 6.0),
                                  //   child: Row(
                                  //     children: [
                                  //       ClipOval(
                                  //         child: Image.network(
                                  //           'https://cdn-icons-png.flaticon.com/128/8943/8943377.png',
                                  //           // Replace with your image URL
                                  //           width: 40, // Set your desired width
                                  //           height: 40, // Set your desired height
                                  //           fit: BoxFit
                                  //               .cover, // Set the image fitting mode
                                  //         ),
                                  //       ),
                                  //       const SizedBox(
                                  //         width: 8,
                                  //       ),
                                  //       const Text(
                                  //         "Gymbot:",
                                  //         style: TextStyle(
                                  //             fontWeight: FontWeight.bold,
                                  //             fontSize: 17,
                                  //             color: appBarColor),
                                  //       )
                                  //     ],
                                  //   ),
                                  // ),
                                  Column(
                                    children: [
                                      AnimatedTextKit(
                                        isRepeatingAnimation: false,
                                        repeatForever: false,
                                        animatedTexts: [
                                          TyperAnimatedText(description,
                                              textStyle: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15))
                                        ],
                                        onFinished: () {
                                          setState(() {
                                            _showWorkoutTile = true;
                                          });
                                        },
                                      ),
                                      AnimatedOpacity(
                                        opacity: _showWorkoutTile ? 1.0 : 0.0,
                                        duration:
                                            const Duration(milliseconds: 800),
                                        curve: Curves.easeIn,
                                        child: _showWorkoutTile
                                            ? workoutTile
                                            : const SizedBox.shrink(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
