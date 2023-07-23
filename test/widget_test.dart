import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gymbros/main.dart';
import 'package:gymbros/screens/authenticate/log_in.dart';
import 'package:gymbros/screens/authenticate/sign_in.dart';
import 'package:gymbros/screens/calendar/calendar.dart';
import 'package:gymbros/screens/components/workout_tile.dart';
import 'package:gymbros/screens/workoutRecommender/workout_recommender.dart';
import 'package:gymbros/screens/workoutTracker/workout.dart';
import './mock.dart';

void main() {
  setupFirebaseAuthMocks();
  // Ensure that Firebase is initialized before running widget tests
  setUpAll(() {
    WidgetsFlutterBinding.ensureInitialized();
    Firebase.initializeApp();
  });

  testWidgets('MyApp loads without errors', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the MaterialApp contains your expected widget (Wrapper in this case).
    expect(find.byType(MyApp), findsOneWidget);
    expect(find.byType(MaterialApp), findsOneWidget);

    // Add more widget tests as needed to test specific UI elements or interactions.
  });

  testWidgets('LogIn widget loads without errors', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const MaterialApp(
        home: LogIn(),
      ),
    );

    // Verify that the LogIn widget contains your expected widgets.
    expect(find.byType(LogIn), findsOneWidget);
    expect(find.text("Achieve your fitness goals today"), findsOneWidget);
    expect(find.byType(TextButton), findsOneWidget);

    // Tap on the "Sign in with email" button.
    await tester.tap(find.text("Sign in with email".toUpperCase()));
    await tester.pumpAndSettle();
  });

  // Tests for Workout Recommender Screen
  group("Workout Recommender Tests", () {
    testWidgets('Workout Recommender loads without error',
        (WidgetTester tester) async {
      // Build the WorkoutRecommender widget
      await tester.pumpWidget(const MaterialApp(
        home: WorkoutRecommender(),
      ));

      expect(find.text('GymBot'), findsOneWidget);
    });

    testWidgets('Initial UI - Generate Workout button',
        (WidgetTester tester) async {
      // Build the WorkoutRecommender widget
      await tester.pumpWidget(const MaterialApp(
        home: WorkoutRecommender(),
      ));

      // Verify the initial UI - Generate Workout button should be visible
      expect(find.text('Generate Workout'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('Generate Workout - Button disappears',
        (WidgetTester tester) async {
      // Build the WorkoutRecommender widget
      await tester.pumpWidget(const MaterialApp(
        home: WorkoutRecommender(),
      ));

      // Tap the Generate Workout button
      await tester.tap(find.text('Generate Workout'));
      await tester.pump();

      // button should disappear and API call should have been completed
      expect(find.text('Generate Workout'), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('Workout Recommender loads without error',
        (WidgetTester tester) async {
      // Build the WorkoutRecommender widget
      await tester.pumpWidget(const MaterialApp(
        home: WorkoutRecommender(),
      ));

      expect(find.text('GymBot'), findsOneWidget);
    });
  });

  // Tests for Workout Calendar Screen
  group("Workout Calendar Tests", () {
    final List<Workout> mockWorkouts = [
      Workout(name: "Workout 1", exercises: []),
      Workout(name: "Workout 2", exercises: []),
      Workout(name: "Workout 3", exercises: []),
    ];

    testWidgets('Initial UI - Calendar and Workout Tiles',
        (WidgetTester tester) async {
      // Build the Calendar widget with mock data
      await tester.pumpWidget(MaterialApp(
        home: Calendar(workoutList: mockWorkouts),
      ));

      // Verify the initial UI - Calendar and Workout Tiles
      expect(find.byType(Calendar), findsOneWidget);
      expect(find.byType(WorkoutTile, skipOffstage: false),
          findsNWidgets(mockWorkouts.length));
    });

    testWidgets('Tap on a day in the calendar', (WidgetTester tester) async {
      // Build the Calendar widget with mock data
      await tester.pumpWidget(MaterialApp(
        home: Calendar(workoutList: mockWorkouts),
      ));

      // Tap on a specific day in the calendar
      await tester.tap(find.text((DateTime.now().day - 1).toString()));
      await tester.pumpAndSettle();

      // Verify that the selected day is shown in the UI
      expect(find.text((DateTime.now().day - 1).toString()), findsOneWidget);

      // Verify that no workoutTiles are displayed on that day
      expect(find.byType(WorkoutTile, skipOffstage: false), findsNothing);
    });

    testWidgets(
        'Tap and select a range of days in the calendar containing workouts',
        (WidgetTester tester) async {
      // Build the Calendar widget with mock data
      await tester.pumpWidget(MaterialApp(
        home: Calendar(workoutList: mockWorkouts),
      ));

      // Tap and select a range of days in the calendar
      await tester.longPress(find.text('15'));
      await tester.pumpAndSettle();

      // Range includes day containing all exercises
      await tester.tap(find.text(DateTime.now().day.toString()));
      await tester.pumpAndSettle();

      // Verify that the selected range is shown in the UI
      expect(find.text('15'), findsOneWidget);
      expect(find.text('20'), findsOneWidget);

      // Verify that the workouts are reflected in the UI
      expect(find.text('Workout 1'),
          findsOneWidget); // Replace 'Workout 1' with the expected workout name for the selected range
    });

    testWidgets(
        'Tap and select a range of days in the calendar not containing workouts',
        (WidgetTester tester) async {
      // Build the Calendar widget with mock data
      await tester.pumpWidget(MaterialApp(
        home: Calendar(workoutList: mockWorkouts),
      ));

      // Tap and select a range of days in the calendar
      await tester.longPress(find.text('15'));
      await tester.pumpAndSettle();

      // Range excludes day containing all exercises
      await tester.tap(find.text((DateTime.now().day - 1).toString()));
      await tester.pumpAndSettle();

      // Verify that the workouts are reflected in the UI
      expect(find.text('Workout 1'), findsNothing);
    });
  });

  testWidgets(
      "Navigating to the sign up page, attempting to sign up without providing information will return and error",
          (WidgetTester tester) async {
        // Testing starts at the root widget in the widget tree
        await tester.pumpWidget(const MyApp());

        await tester.tap(find.text("Sign in with email".toUpperCase()));
        // Wait for all the animations to finish
        await tester.pumpAndSettle();

        await tester.tap(find.byType(ElevatedButton));

        await tester.pumpAndSettle();

        expect(find.byType(SignIn), findsOneWidget);
        expect(find.text("Enter a username"), findsOneWidget);
        expect(find.text("Enter an email"), findsOneWidget);
        expect(find.text("Enter a password longer than 6 chars!"), findsOneWidget);
      });

  testWidgets(
      "Navigating to the sign up page, attempting to sign up without providing information will return and error",
          (WidgetTester tester) async {
        // // Testing starts at the root widget in the widget tree
        // await tester.pumpWidget(const MyApp());
        //
        // await tester.tap(find.text("Log in"));
        // // Wait for all the animations to finish
        // await tester.pumpAndSettle();
        //
        // await tester.tap(find.byType(ElevatedButton));
        //
        // await tester.pumpAndSettle();
        //
        // expect(find.byType(DirectLogIn), findsOneWidget);
        // expect(find.text('Enter a password longer than 6 chars!'), findsOneWidget);
        // expect(find.text("Enter an email"), findsOneWidget);
      }
  );
}
