import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gymbros/screens/home/view_profile.dart';
import 'package:gymbros/services/auth_service.dart';
import 'package:gymbros/shared/constants.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
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
              decoration:
                  const InputDecoration(labelText: 'Search for a user...'),
              onChanged: (String _) {
                setState(() {
                  name = searchController.text;
                });
              },
            ),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream:
          FirebaseFirestore.instance
              .collection('userProfiles')
              .orderBy("Name").startAt([name]W)
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
                var data =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;
                if (name.isEmpty) {
                  return InkWell(
                    onTap: () => goToViewProfile(data["Uid"]),
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
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ViewProfile(
                          uid: data['Uid'],
                        ),
                      ),
                    ),
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
