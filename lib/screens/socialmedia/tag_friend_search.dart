import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gymbros/services/auth_service.dart';
import 'package:gymbros/shared/constants.dart';

import '../home/view_profile.dart';

class TagFriendSearchScreen extends StatefulWidget {
  const TagFriendSearchScreen({Key? key}) : super(key: key);

  @override
  State<TagFriendSearchScreen> createState() => _TagFriendSearchScreen();
}

class _TagFriendSearchScreen extends State<TagFriendSearchScreen> {
  final String selfUid = AuthService().getUid();
  String name = "";
  final TextEditingController searchController = TextEditingController();

  void goToViewProfile(String uid) {
    if (uid == selfUid) {
      Navigator.pop(context);
    } else {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ViewProfile(
          uid: uid,
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: gradientColor,
          title: Form(
            child: TextFormField(
              controller: searchController,
              decoration: const InputDecoration(
                  labelText: 'Search for a user...',
                  labelStyle: TextStyle(color: Colors.white)),
              onChanged: (String _) {
                setState(() {
                  name = searchController.text;
                });
              },
            ),
          ),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('userProfiles')
              .orderBy("Name").startAt([name])
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var data = snapshot.data!.docs[index].data();
                if (name.isEmpty) {
                  return InkWell(
                    onTap: () {
                      String username = data['Name'];
                      if (username.isNotEmpty) {
                        Navigator.pop(context, username);
                      }
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          data['profilephotoURL'],
                        ),
                        radius: 16,
                      ),
                      title: Text(
                        data['Name'],
                      ),
                    ),
                  );
                } else if (data['Name']
                    .toString()
                    .toLowerCase()
                    .startsWith(name.toLowerCase())) {
                  return InkWell(
                    onTap: () {
                      String username = data['Name'];
                      if (username.isNotEmpty) {
                        Navigator.pop(context, username);
                      }
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          data['profilephotoURL'],
                        ),
                        radius: 16,
                      ),
                      title: Text(
                        data['Name'],
                      ),
                    ),
                  );
                }
              },
            );
          },
        ));
  }
}
