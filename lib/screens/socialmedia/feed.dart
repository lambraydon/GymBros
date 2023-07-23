import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gymbros/screens/socialmedia/postview.dart';
import 'package:gymbros/shared/constants.dart';

class Feed extends StatelessWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: gradientColor,
          title: const Text("GymBros"),
          /*
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.message))
          ],
           */
        ),
        body: Container(
          color: backgroundColor,
          child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('posts').snapshots(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (ctx, index) => PostView(
                    snap: snapshot.data!.docs[index].data(),
                  ),
                );
              }),
        ));
  }
}
