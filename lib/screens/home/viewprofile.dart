import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gymbros/screens/components/followButton.dart';
import 'package:gymbros/screens/components/mytextfield.dart';
import 'package:gymbros/services/authservice.dart';
import 'package:gymbros/services/databaseservice.dart';
import 'package:gymbros/shared/constants.dart';
import 'package:gymbros/shared/imageUtil.dart';

class ViewProfile extends StatefulWidget {
  final String uid;
  const ViewProfile({Key? key, required this.uid}) : super(key: key);

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  bool isLoading = false;
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  CollectionReference userProfiles =
      FirebaseFirestore.instance.collection("userProfiles");

  @override
  void initState() {
    super.initState();
    updateInfo();
  }

  Future<void> updateInfo() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await userProfiles.doc(widget.uid).get();
      var userData = userSnap.data()! as Map<String, dynamic>;
      followers = userData['Followers'].length;
      following = userData['Following'].length;
      isFollowing = userData['Followers'].contains(AuthService().getUid());
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    DatabaseService _db = DatabaseService(uid: AuthService().getUid());

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('View Profile Page'),
        backgroundColor: appBarColor,
        elevation: 0.0,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: userProfiles.doc(widget.uid).snapshots(),
        builder: (context, snapshot) {
          //get user data
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            return ListView(children: [
              const Padding(
                padding: EdgeInsets.all(15),
              ),
              Row(children: [
                const Padding(
                  padding: EdgeInsets.all(10),
                ),
                CircleAvatar(
                  backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage(
                    userData['profilephotoURL'],
                  ),
                  radius: 40,
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildStatColumn(postLen, "posts"),
                          buildStatColumn(followers, "followers"),
                          buildStatColumn(following, "following"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          isFollowing
                              ? FollowButton(
                                  text: 'Unfollow',
                                  backgroundColor: backgroundColor,
                                  textColor: Colors.black,
                                  borderColor: Colors.grey,
                                  function: () async {
                                    await _db.followUser(
                                      FirebaseAuth.instance.currentUser!.uid,
                                      userData['Uid'],
                                    );

                                    setState(() {
                                      isFollowing = false;
                                      followers--;
                                    });
                                  },
                                )
                              : FollowButton(
                                  text: 'Follow',
                                  backgroundColor: Colors.blue,
                                  textColor: Colors.white,
                                  borderColor: Colors.blue,
                                  function: () async {
                                    await _db.followUser(
                                      FirebaseAuth.instance.currentUser!.uid,
                                      userData['Uid'],
                                    );

                                    setState(() {
                                      isFollowing = true;
                                      followers++;
                                    });
                                  },
                                )
                        ],
                      ),
                    ],
                  ),
                ),
              ]),
              const SizedBox(height: 50),
              MyTextField(text: userData["Name"], sectionName: "Username : "),
              MyTextField(text: userData["Bio"], sectionName: "Bio : "),
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
