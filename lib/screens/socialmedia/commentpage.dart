import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gymbros/screens/socialmedia/commentcard.dart';
import 'package:gymbros/services/authservice.dart';
import 'package:gymbros/services/databaseservice.dart';
import '../../shared/constants.dart';
import '../../shared/imageUtil.dart';

class CommentPage extends StatefulWidget {
  final postID;
  const CommentPage({Key? key, required this.postID}) : super(key: key);

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  bool isLoading = false;
  final AuthService _auth = AuthService();
  final _db = DatabaseService(uid: AuthService().getUid());
  final TextEditingController commentEditingController =
      TextEditingController();
  final CollectionReference userProfiles =
  FirebaseFirestore.instance.collection("userProfiles");

  void postComment(String uid, String name, String profilePic) async {
    try {
      String res = await _db.postComment(
        widget.postID,
        commentEditingController.text,
        uid,
        name,
        profilePic,
      );

      if (res != 'success') {
        if (context.mounted) showSnackBar(context, res);
      }
      setState(() {
        commentEditingController.text = "";
      });
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //final User user = Provider.of<UserProvider>(context).getUser;
    return StreamBuilder<DocumentSnapshot>(
        stream: userProfiles.doc(_auth.getUid()).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            return Scaffold(
              appBar: AppBar(
                flexibleSpace: gradientColor,
                title: const Text(
                  'Comments',
                ),
                centerTitle: false,
              ),
              body: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .doc(widget.postID)
                    .collection('comments')
                    .snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (ctx, index) => CommentCard(
                      snap: snapshot.data!.docs[index],
                    ),
                  );
                },
              ),
              // text input
              bottomNavigationBar: SafeArea(
                child: Container(
                  height: kToolbarHeight,
                  margin: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            NetworkImage(userData['profilephotoURL']),
                        radius: 18,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16, right: 8),
                          child: TextField(
                            controller: commentEditingController,
                            decoration: InputDecoration(
                              hintText: 'Comment as ${userData['Name']}',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => postComment(
                          userData['Uid'],
                          userData['Name'],
                          userData['profilephotoURL'],
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 8),
                          child: const Text(
                            'Post',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Error + ${snapshot.error.toString()}"));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
