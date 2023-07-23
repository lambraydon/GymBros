import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gymbros/main.dart';
import 'package:integration_test/integration_test.dart';

void main() async{
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  log("Firebase Init");

  // Tests will go here...
  testWidgets(
    "Not inputting a text and wanting to go to the display page shows "
        "an error and prevents from going to the display page.",
        (WidgetTester tester) async {
      // Testing starts at the root widget in the widget tree
      await tester.pumpWidget(MyApp());

      await tester.tap(find.text("Sign in with email".toUpperCase()));
      // Wait for all the animations to finish
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ElevatedButton));

      await tester.pumpAndSettle();

      // This is the text displayed by an error message on the TextFormField
      expect(find.text('Enter a username'), findsOneWidget);
      expect(find.text('Enter an email'), findsOneWidget);
      expect(find.text('Enter a password longer than 6 chars!'), findsOneWidget);
    },
  );
}
