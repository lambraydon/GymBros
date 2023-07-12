import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gymbros/screens/components/mytextfield.dart';
import 'package:gymbros/screens/socialmedia/searchscreen.dart';
import 'package:gymbros/screens/workoutTracker/workoutData.dart';
import 'package:gymbros/services/authservice.dart';
import 'package:gymbros/services/databaseStorageService.dart';
import 'package:gymbros/shared/constants.dart';
import 'package:gymbros/shared/imageUtil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gymbros/screens/components/myedittextfield.dart';
import 'package:provider/provider.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Uint8List? _file;
  bool isLoading = false;
  @override

  void initState() {
    super.initState();
    Provider.of<WorkoutData>(context, listen: false).initialiseWorkoutList();
  }

  final AuthService _auth = AuthService();
  final CollectionReference userProfiles = FirebaseFirestore.instance.collection("userProfiles");


  selectimage(BuildContext parentContext) async {
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
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Home Page'),
        backgroundColor: appBarColor,
        elevation: 0.0,
        actions: <Widget>[
          TextButton.icon(
            icon: const Icon(Icons.person_add),
            label: const Text('Find Friends'),
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(
                builder: (context) => const SearchScreen()
            )
            ),
          ),
          TextButton.icon(
            icon: const Icon(Icons.person),
            label: const Text('logout'),
            onPressed: () async {
              await _auth.signOut();
            },
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: userProfiles.doc(_auth.getUid()).snapshots(),
        builder: (context, snapshot) {
          //get user data
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            return ListView(children: [
              const SizedBox(height: 50),
              Center(
                child: Stack(
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
              ),
              Text(
                "Logged in as ${_auth.getEmail()}",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[700]),
              ),
              MyEditTextField(
                  text: userData["Name"],
                  sectionName: "Username : ",
                  onPressedFunc: () => editField("Name")),
              MyEditTextField(
                  text: userData["Bio"],
                  sectionName: "Bio : ",
                  onPressedFunc: () => editField("Bio")),
              MyTextField(text: userData['Email'], sectionName: "Email : ")
            ]);
          } else if (snapshot.hasError) {
            return Center(child: Text("Error + ${snapshot.error.toString()}"));
          } else {
            return const Center(
              child: Text("Error"),
            );
          }
        },
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
                      String photoUrl = await dbStorageMethods().uploadImageToStorage('profilepics', file, false);
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
}
