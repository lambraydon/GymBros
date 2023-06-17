import 'package:flutter/material.dart';
import 'package:gymbros/services/authservice.dart';
import '../workoutTracker/workoutHistory.dart';
import 'package:gymbros/screens/workoutTracker/workoutData.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    Provider.of<WorkoutData>(context, listen: false).initialiseWorkoutList();
  }
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      appBar: AppBar(
        title: const Text('GymBros'),
        backgroundColor: Colors.white,
        elevation: 0.0,
        actions: <Widget>[
          TextButton.icon(
            icon: const Icon(Icons.person),
            label: const Text('logout'),
            onPressed: () async {
              await _auth.signOut();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {

          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WorkoutHistory())
          );
        },
      ),
    );
  }
}
