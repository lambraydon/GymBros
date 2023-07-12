import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gymbros/screens/components/mytextfield.dart';
import 'package:gymbros/shared/constants.dart';

class ViewProfile extends StatefulWidget {
  final String uid;
  const ViewProfile({Key? key, required this.uid}) : super(key: key);

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  int postLen = 0;
  int followers = 0;
  int following = 0;
  CollectionReference userProfiles =
      FirebaseFirestore.instance.collection("userProfiles");

  @override
  Widget build(BuildContext context) {
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
              Row(children: [
                CircleAvatar(
                  backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage(
                    userData['profilephotoURL'],
                  ),
                  radius: 40,
                ),
                Expanded(
                  flex: 1,
                  child: Column(children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildStatColumn(postLen, "posts"),
                        buildStatColumn(followers, "followers"),
                        buildStatColumn(following, "following"),
                      ],
                    ),
                  ]),
                ),
              ]),
              const SizedBox(height: 50),
              Center(
                child: CircleAvatar(
                    radius: 64,
                    backgroundImage: NetworkImage(userData["profilephotoURL"])),
              ),
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
