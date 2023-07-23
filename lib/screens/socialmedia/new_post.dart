import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:gymbros/screens/home/page_toggler.dart';
import 'package:gymbros/screens/socialmedia/tag_friend_search.dart';
import 'package:gymbros/screens/workoutTracker/workout.dart';
import 'package:gymbros/services/auth_service.dart';
import 'package:gymbros/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:gymbros/shared/constants.dart';
import 'package:gymbros/shared/image_util.dart';
import 'package:image_picker/image_picker.dart';

class NewPost extends StatefulWidget {
  final Workout workout;
  const NewPost({Key? key, required this.workout}) : super(key: key);

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<String> _taggedUsers = [];
  String description = "";
  Uint8List? _file;
  bool isLoading = false;
  final DatabaseService db = DatabaseService(uid: AuthService().getUid());
  final TextEditingController _descController = TextEditingController();

  void _removeItem(int index) {
    if (_taggedUsers.isNotEmpty) {
      _listKey.currentState?.removeItem(
        index,
            (context, animation) => _buildItem(_taggedUsers.removeAt(index), animation),
      );
    }
  }

  void _showTagFriendSearch(BuildContext context) async {
    String? taggedFriend = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return const TagFriendSearchScreen();
      }
    );
    if (taggedFriend != null) {
      int index = _taggedUsers.length;
      _taggedUsers.add(taggedFriend);
      _listKey.currentState?.insertItem(index);
    }
  }

  Widget _buildItem(String item, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: Card(
        child: ListTile(
          title: Text(item),
          trailing: IconButton(
            icon: const Icon(Icons.remove_circle),
            onPressed: () => _removeItem(_taggedUsers.indexOf(item)),
          ),
        ),
      ),
    );
  }


  void postImage(String uid, String username, String profImage) async {
    setState(() {
      isLoading = true;
    });
    // start the loading
    try {
      // upload to storage and db
      String res = await db.uploadPost(_descController.text, _file!, uid,
          username, profImage, widget.workout, _taggedUsers);
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

    return StreamBuilder(
        stream: db.userProfiles.doc(AuthService().getUid()).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            return Scaffold(
              appBar: AppBar(
                flexibleSpace: gradientColor,
                leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                title: const Text("Share Workout"),
                centerTitle: false,
                actions: [
                  TextButton(
                      onPressed: () {
                        postImage(db.uid, userData["Name"],
                            userData['profilephotoURL']);
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PageToggler()));
                      },
                      child:
                          const Row(children: [
                            Text("Post",
                            style: TextStyle(color: Colors.white, fontSize: 20), ),
                            Icon(Icons.add, color: Colors.white,)
                          ])
                  )
                ],
              ),
              body: Container(
                  color: backgroundColor,
                  child: Column(children: [
                    isLoading
                        ? const LinearProgressIndicator()
                        : const Padding(padding: EdgeInsets.only(top: 0)),
                    const Divider(),
                    _file == null
                        ? Stack(children: [
                            SizedBox(
                              height: 250.0,
                              width: 250.0,
                              child: Container(
                                  margin: const EdgeInsets.all(15.0),
                                  padding: const EdgeInsets.all(3.0),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black54),
                                      borderRadius: BorderRadius.circular(6)),
                                  child: const Center(
                                    child: Text(
                                        'Select an Image with the upload button above!',
                                        textAlign: TextAlign.center),
                                  )),
                            ),
                            SizedBox(
                              height: 160.0,
                              width: 250.0,
                              child: Center(
                                  child: IconButton(
                                icon: const Icon(Icons.upload),
                                onPressed: () => selectimage(context),
                              )),
                            ),
                          ])
                        : SizedBox(
                            height: 250.0,
                            width: 250.0,
                            child: AspectRatio(
                                aspectRatio: 487 / 451,
                                child: Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.fill,
                                            alignment:
                                                FractionalOffset.topCenter,
                                            image: _file == null
                                                ? Image.asset('assets/log.jpg')
                                                    .image
                                                : MemoryImage(_file!)))))),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(userData['profilephotoURL'])),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: Colors.black54,
                                    )),
                                child: Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: TextField(
                                    controller: _descController,
                                    decoration: const InputDecoration(
                                      hintText: "Write a caption...",
                                      border: InputBorder.none,
                                    ),
                                    maxLines: 4,
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                    Expanded(
                      child: AnimatedList(
                        key: _listKey,
                        initialItemCount: _taggedUsers.length,
                        itemBuilder: (context, index, animation) {
                          return _buildItem(_taggedUsers[index], animation);
                        },
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.40,
                      child: ElevatedButton(
                          onPressed: () => _showTagFriendSearch(context),
                          //Navigator.of(context).push(MaterialPageRoute(
                          //builder: (context) => const SearchScreen())),
                          child: const Row(
                            children: [
                              Text('Tag a GymBro!'),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(CupertinoIcons.person_add),
                              )
                            ],
                          )),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height*0.1,)
                  ])),
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('snapshot error'));
          } else {
            return const Center(child: Text('another Error'));
          }
        });
  }
}
