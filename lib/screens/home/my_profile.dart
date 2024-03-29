import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gymbros/screens/components/my_textfield.dart';
import 'package:gymbros/screens/home/analytics/analyticsview.dart';
import 'package:gymbros/screens/socialmedia/search_screen.dart';
import 'package:gymbros/screens/workoutTracker/workout_data.dart';
import 'package:gymbros/services/auth_service.dart';
import 'package:gymbros/services/database_storage_service.dart';
import 'package:gymbros/shared/constants.dart';
import 'package:gymbros/shared/image_util.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gymbros/screens/components/my_edit_textfield.dart';
import 'package:provider/provider.dart';

import '../../services/database_service.dart';
import '../calendar/calendar_utils.dart';
import '../workoutTracker/workout.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  Uint8List? _file;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    Provider.of<WorkoutData>(context, listen: false).initialiseWorkoutList();
    getGoal();
  }

  final AuthService _auth = AuthService();
  final CollectionReference userProfiles =
      FirebaseFirestore.instance.collection("userProfiles");

  final DatabaseService db = DatabaseService(uid: AuthService().getUid());
  int workoutFrequency = 0;
  int workoutLen = 0;
  int actualFrequency = 0;
  int actualLen = 0;

  selectImage(BuildContext parentContext) async {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: const Text("Share your workout"),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Take a photo"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(
                    ImageSource.camera,
                  );
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Select from Gallery"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(
                    ImageSource.gallery,
                  );
                  setState(() {
                    _file = file;
                  });
                },
              ),
            ],
          );
        });
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
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
      workoutLen = len;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: const Text('Home Page'),
          flexibleSpace: gradientColor,
          //backgroundColor: appBarColor,
          elevation: 0.0,
          actions: <Widget>[
            TextButton.icon(
              icon: const Icon(
                Icons.person_add,
                color: Colors.white,
              ),
              label: const Text('Find Friends',
                  style: TextStyle(color: Colors.white)),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const SearchScreen())),
            ),
            TextButton.icon(
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
              label: const Text(
                'Log Out',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
          ],
          bottom: const TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 5,
            tabs: [
              Tab(
                icon: Icon(Icons.person),
                text: "Profile",
              ),
              Tab(icon: Icon(Icons.bar_chart), text: "Progress")
            ],
          ),
        ),
        body: TabBarView(
          children: [
            StreamBuilder<DocumentSnapshot>(
              stream: userProfiles.doc(_auth.getUid()).snapshots(),
              builder: (context, snapshot) {
                //get user data
                if (snapshot.hasData) {
                  final userData =
                      snapshot.data!.data() as Map<String, dynamic>;
                  return ListView(children: [
                    const SizedBox(height: 50),
                    Row(children: [
                      const Padding(
                        padding: EdgeInsets.all(10),
                      ),
                      Stack(
                        children: [
                          CircleAvatar(
                              radius: 64,
                              backgroundImage:
                                  NetworkImage(userData["profilephotoURL"])),
                          Positioned(
                              bottom: -15,
                              left: 93,
                              child: IconButton(
                                onPressed: () => changePhoto(),
                                icon: const Icon(Icons.add_a_photo_sharp),
                              ))
                        ],
                      ),
                      Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    child: buildStatColumn(userData['Followers'].length,
                                        "followers"),
                                    onTap: () {}
                                  ),
                                  buildStatColumn(userData['Following'].length,
                                      "following"),
                                ],
                              )
                            ],
                          )),
                    ]),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Text(
                        "Logged in as ${_auth.getEmail()}",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                    MyEditTextField(
                        text: userData["Name"],
                        sectionName: "Username : ",
                        onPressedFunc: () => editField("Name")),
                    MyEditTextField(
                        text: userData["Bio"],
                        sectionName: "Bio : ",
                        onPressedFunc: () => editField("Bio")),
                    MyTextField(
                        text: userData['Email'], sectionName: "Email : ")
                  ]);
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text("Error + ${snapshot.error.toString()}"));
                } else {
                  return const Center(
                    child: Text("Error"),
                  );
                }
              },
            ),
            AnalyticsView(
              actualFrequency: getNumWorkoutsThisWeek(),
              actualLen: getDurationThisWeek(),
              workoutFrequency: workoutFrequency,
              workoutLen: workoutLen,
            )
          ],
        ),
      ),
    );
  }

  //edit function
  Future<void> editField(String field) async {
    String newVal = "";
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.grey[900],
              title: Text("Edit $field",
                  style: const TextStyle(
                    color: Colors.white,
                  )),
              content: TextField(
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Enter new $field",
                  hintStyle: const TextStyle(color: Colors.grey),
                ),
                onChanged: (value) {
                  newVal = value;
                },
              ),
              actions: [
                // cancel Button
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel",
                        style: TextStyle(color: Colors.white))),
                TextButton(
                    onPressed: () => Navigator.of(context).pop(newVal),
                    child: const Text("Save",
                        style: TextStyle(color: Colors.white)))
              ],
            ));
    if (newVal.trim().isNotEmpty) {
      await userProfiles.doc(_auth.getUid()).update({field: newVal});
    }
  }

  Future<void> changePhoto() async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Choose a new image"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    //padding: const EdgeInsets.all(20),
                    child: const Text("Take a photo"),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      Uint8List file = await pickImage(
                        ImageSource.camera,
                      );
                      String photoUrl = await dbStorageMethods()
                          .uploadImageToStorage('profilepics', file, false);
                      if (photoUrl.trim().isNotEmpty) {
                        await userProfiles
                            .doc(_auth.getUid())
                            .update({"profilephotoURL": photoUrl});
                      }
                    },
                  ),
                  TextButton(
                    //padding: const EdgeInsets.all(20),
                    child: const Text("Select from Gallery"),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      Uint8List file = await pickImage(
                        ImageSource.gallery,
                      );
                      String photoUrl = await dbStorageMethods()
                          .uploadImageToStorage('profilepics', file, false);
                      if (photoUrl.trim().isNotEmpty) {
                        await userProfiles
                            .doc(_auth.getUid())
                            .update({"profilephotoURL": photoUrl});
                      }
                    },
                  ),
                ],
              ),
              actions: [
                // cancel Button
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel",
                        style: TextStyle(color: Colors.black))),
              ],
            ));
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
