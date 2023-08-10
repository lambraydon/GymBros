import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gymbros/screens/socialmedia/post_view.dart';
import 'package:gymbros/services/auth_service.dart';
import 'package:gymbros/shared/constants.dart';

class Feed extends StatelessWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CollectionReference userProfiles =
    FirebaseFirestore.instance.collection("userProfiles");
    return StreamBuilder<DocumentSnapshot>(
      stream: userProfiles.doc(AuthService().getUid()).snapshots(),
      builder: (context, snapshot) {
        final userData =
        snapshot.data!.data() as Map<String, dynamic>;
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
                  stream: FirebaseFirestore.instance.collection('posts').orderBy('datePublished', descending: true).snapshots(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                      return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (ctx, index) {
                            var data = snapshot.data!.docs[index].data();
                            if (userData['Following'].contains(data["uid"])) {
                              return PostView(
                                snap: snapshot.data!.docs[index].data(),
                              );
                            }
                          }
                      );
                    }
                  ),
            ));
      }
    );
  }
}
