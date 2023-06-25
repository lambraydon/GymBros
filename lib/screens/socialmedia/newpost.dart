import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gymbros/services/authservice.dart';
import 'package:gymbros/services/databaseservice.dart';
import 'package:flutter/material.dart';
import 'package:gymbros/shared/imageUtil.dart';
import 'package:image_picker/image_picker.dart';

class NewPost extends StatefulWidget {
  const NewPost({Key? key}) : super(key: key);

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  Uint8List? _file;
  bool isLoading = false;
  final DatabaseService db = DatabaseService(uid: AuthService().getUid());
  final TextEditingController _descController = TextEditingController();

  void postImage(String uid, String username) async {
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
        //profImage,
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

  _selectimage(BuildContext parentContext) async {
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
        backgroundColor: Colors.purple[200],
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {}),
        title: const Text("Share Workout"),
        centerTitle: false,
        actions: [
          TextButton(
              onPressed: () => {},
              child: const Text(
                "Post",
                style: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ))
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: db.userProfiles.doc(AuthService().getUid()).snapshots(),
          builder: (context, snapshot) {
            final userData = snapshot.data!.data() as Map<String,dynamic>;
            return Column(children: [
              isLoading
                  ? const LinearProgressIndicator()
                  : Padding(padding: EdgeInsets.only(top: 0)),
              const Divider(),
              Center(
                  child: IconButton(
                icon: Icon(Icons.upload),
                onPressed: () => _selectimage(context),
              )),
              Row(
                children: [
                  const CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://images.unsplash.com/photo-1687054232652-f12bc731b2a6?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=687&q=80'),
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: "Write a caption...",
                          border: InputBorder.none,
                        ),
                        maxLines: 8,
                      )),
                  SizedBox(
                      height: 45.0,
                      width: 45.0,
                      child: AspectRatio(
                          aspectRatio: 487 / 451,
                          child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.fill,
                                      alignment: FractionalOffset.topCenter,
                                      image: NetworkImage(
                                          'https://images.unsplash.com/photo-1687054232652-f12bc731b2a6?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=687&q=80')
                                      //MemoryImage(_file!)
                                      ))))),
                ],
              ),
              const Divider(),
              Center(
                  child: TextButton(
                    onPressed: () => {postImage(db.uid, userData["Name"])},
                    child: Text(
                        "Post",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 24
                        )
                    ),
                  )
              )
            ]);
          }),
    );
  }
}
