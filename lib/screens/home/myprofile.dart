import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gymbros/screens/components/mytextfield.dart';
import 'package:gymbros/screens/home/analyticsview.dart';
import 'package:gymbros/screens/socialmedia/searchscreen.dart';
import 'package:gymbros/screens/workoutTracker/workoutData.dart';
import 'package:gymbros/services/authservice.dart';
import 'package:gymbros/services/databaseStorageService.dart';
import 'package:gymbros/shared/constants.dart';
import 'package:gymbros/shared/imageUtil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gymbros/screens/components/myedittextfield.dart';
import 'package:provider/provider.dart';

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
  }

  final AuthService _auth = AuthService();
  final CollectionReference userProfiles =
  FirebaseFirestore.instance.collection("userProfiles");

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
                                  buildStatColumn(userData['Followers'].length,
                                      "followers"),
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
            const AnalyticsView()
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
          title: Text("Edit + $field",
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