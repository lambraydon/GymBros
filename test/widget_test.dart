import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gymbros/main.dart';
import './mock.dart';

void main() {
  setupFirebaseAuthMocks();
  // Ensure that Firebase is initialized before running widget tests
  setUpAll(() {
    WidgetsFlutterBinding.ensureInitialized();
    Firebase.initializeApp();
  });

  testWidgets('MyApp loads without errors', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MyApp(),
      ),
    );

    // Add your widget tests here
    // ...
  });
}
