import 'package:flutter/material.dart';
import 'package:gymbros/screens/workoutTracker/workout_data.dart';
import 'package:gymbros/screens/wrapper.dart';
import 'package:gymbros/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:gymbros/models/gbuser.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  //Stream Provider Logic to listen for change in auth status
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      StreamProvider<GbUser?>.value(
        value: AuthService().user,
        initialData: null),
      ChangeNotifierProvider(create: (context) =>WorkoutData(),
      )],
        child: const MaterialApp(
          home: Wrapper(),
      ),
    );
  }
}

