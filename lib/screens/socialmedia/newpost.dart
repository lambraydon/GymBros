import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gymbros/screens/home/pagetoggler.dart';
import 'package:gymbros/screens/workoutTracker/workout.dart';
import 'package:gymbros/services/authservice.dart';
import 'package:gymbros/services/databaseservice.dart';
import 'package:flutter/material.dart';
import 'package:gymbros/shared/constants.dart';
import 'package:gymbros/shared/imageUtil.dart';
import 'package:image_picker/image_picker.dart';

class NewPost extends StatefulWidget {
  final Workout workout;
  const NewPost({Key? key, required this.workout}) : super(key: key);

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  String description = "";
  Uint8List? _file;
  bool isLoading = false;
  final DatabaseService db = DatabaseService(uid: AuthService().getUid());
  final TextEditingController _descController = TextEditingController();

  void postImage(String uid, String username, String profImage) async {
    setState(() {
      isLoading = true;
    });
    // start the loading
    try {
      // upload to storage and db
      String res = await db.uploadPost(
        _descController.text,
        _file!,
        uid,
        username,
        profImage,
        widget.workout
      );
      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        if (context.mounted) {
          showSnackBar(
            context,
            'Posted!',
          );
        }
        clearImage();
      } else {
        if (context.mounted) {
          showSnackBar(context, res);
        }
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descController.dispose();
  }

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

  @override
  Widget build(BuildContext context) {
    //for avatar to show current users profile picture (implement later)

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: const Text("Share Workout"),
        centerTitle: false,
      ),
      body: Container(
        color: backgroundColor,
        child: StreamBuilder<DocumentSnapshot>(
            stream: db.userProfiles.doc(AuthService().getUid()).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final userData = snapshot.data!.data() as Map<String, dynamic>;
                return Column(children: [
                  isLoading
                      ? const LinearProgressIndicator()
                      : const Padding(padding: EdgeInsets.only(top: 0)),
                  const Divider(),
                  Center(
                      child: IconButton(
                    icon: const Icon(Icons.upload),
                    onPressed: () => selectimage(context),
                  )),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(userData['profilephotoURL'])
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: TextField(
                            controller: _descController,
                            decoration: const InputDecoration(
                              hintText: "Write a caption...",
                              border: InputBorder.none,
                            ),
                            maxLines: 8,
                          )
                      ),
                    ],
                  ),
                  _file == null ? SizedBox(
                      height: 250.0,
                      width: 250.0,
                      child: Container(
                        margin: const EdgeInsets.all(15.0),
                        padding: const EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)
                        ),
                        child: const Center(child:Text('Select an Image with the upload button above!', textAlign: TextAlign.center),)),
                      )
                   :SizedBox(
                      height: 250.0,
                      width: 250.0,
                      child: AspectRatio(
                          aspectRatio: 487 / 451,
                          child:
                          Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.fill,
                                      alignment: FractionalOffset.topCenter,
                                      image: _file == null ? Image.asset('assets/log.jpg').image : MemoryImage(_file!)
                                  )
                              )
                          )
                      )
                  )
                  ,
                  const Divider(),
                  Center(
                      child: TextButton(
                    onPressed: () {
                      postImage(
                          db.uid, userData["Name"], userData['profilephotoURL']
                      );
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PageToggler()));
                    }
                    ,
                    child: const Text("Post",
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 24)),
                  ))
                ]);
              } else if (snapshot.hasError) {
                return const Center(child: Text('snapshot error'));
              } else {
                return const Center(
                  child: Text('another Error')
                );
              }
            }),
      ),
    );
  }
}
