import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gymbros/shared/constants.dart';

class TagFriendSearchScreen extends StatefulWidget {
  const TagFriendSearchScreen({Key? key}) : super(key: key);

  @override
  State<TagFriendSearchScreen> createState() => _TagFriendSearchScreen();
}

class _TagFriendSearchScreen extends State<TagFriendSearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: gradientColor,
          title: Form(
            child: TextFormField(
              controller: searchController,
              decoration:
              const InputDecoration(labelText: 'Search for a user...', labelStyle: TextStyle(color: Colors.white) ),
              onFieldSubmitted: (String _) {
                setState(() {
                  isShowUsers = true;
                });
              },
            ),
          ),
        ),
        body: isShowUsers
            ? FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('userProfiles')
              .where(
            'Name',
            isGreaterThanOrEqualTo: searchController.text,
          )
              .get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              itemCount: (snapshot.data! as dynamic).docs.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    String username = (snapshot.data! as dynamic).docs[index]['Name'];
                    if (username.isNotEmpty) {
                      Navigator.pop(context, username);
                    }
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        (snapshot.data! as dynamic).docs[index]
                        ['profilephotoURL'],
                      ),
                      radius: 16,
                    ),
                    title: Text(
                      (snapshot.data! as dynamic).docs[index]['Name'],
                    ),
                  ),
                );
              },
            );
          },
        )
            : const Center(child: Text("Search for a User")));
  }
}