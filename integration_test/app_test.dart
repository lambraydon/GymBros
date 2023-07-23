import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gymbros/main.dart';
import 'package:gymbros/screens/authenticate/direct_login.dart';
import 'package:gymbros/screens/authenticate/sign_in.dart';
import 'package:gymbros/screens/workoutTracker/logger.dart';
import 'package:gymbros/screens/workoutTracker/workout.dart';
import 'package:gymbros/screens/workoutTracker/workout_Complete.dart';
import 'package:integration_test/integration_test.dart';
import '../test/mock.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
    Workout testWorkout = Workout(name: "TestWorkout", exercises: []);
  });
  // Tests will go here..
  testWidgets(
      "Navigating to the sign up page, attempting to sign up without providing information will return and error",
      (WidgetTester tester) async {
    // Testing starts at the root widget in the widget tree
    await tester.pumpWidget(MyApp());

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
            // Testing starts at the root widget in the widget tree
            await tester.pumpWidget(MyApp());

            await tester.tap(find.text("Log in"));
            // Wait for all the animations to finish
            await tester.pumpAndSettle();

            await tester.tap(find.byType(ElevatedButton));

            await tester.pumpAndSettle();

            expect(find.byType(DirectLogIn), findsOneWidget);
            expect(find.text('Enter a password longer than 6 chars!'), findsOneWidget);
            expect(find.text("Enter an email"), findsOneWidget);
          }
    );

}
