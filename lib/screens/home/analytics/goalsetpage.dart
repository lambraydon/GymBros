import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gymbros/screens/components/my_num_days.dart';
import 'package:gymbros/services/auth_service.dart';
import 'package:gymbros/shared/constants.dart';
import 'package:gymbros/shared/image_util.dart';

class GoalSetPage extends StatefulWidget {
  const GoalSetPage({Key? key}) : super(key: key);

  @override
  State<GoalSetPage> createState() => _GoalSetPageState();
}

class _GoalSetPageState extends State<GoalSetPage> {
  final String uid = AuthService().getUid();
  final CollectionReference userProfiles =
      FirebaseFirestore.instance.collection("userProfiles");

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: userProfiles.doc(uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            return Scaffold(
                appBar: AppBar(
                  flexibleSpace: gradientColor,
                  title: const Text('Set My Goals'),
                  centerTitle: false,
                ),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(padding: EdgeInsets.all(24)),
                    const Padding(
                      padding: EdgeInsets.only(top: 24, left: 24),
                      child: Text(
                        "I aim to workout this many times a week ",
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.only(left: 15, bottom: 15),
                      margin:
                          const EdgeInsets.only(left: 20, right: 20, top: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8)),
                            padding:
                                const EdgeInsets.only(left: 15, bottom: 15),
                            margin: const EdgeInsets.only(
                                left: 20, right: 20, top: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //Section Name
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Workout Frequency :'),

                                    //edit button
                                    IconButton(
                                        onPressed: () {
                                          editFreqField("Workout Frequency");
                                        },
                                        icon: Icon(
                                          Icons.settings,
                                          color: Colors.grey[400],
                                        ))
                                  ],
                                ),
                                (userData['Workout Frequency'] == null)
                                    ? const Text('You have not set a goal')
                                    : Text(
                                        userData['Workout Frequency'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 24, left: 24),
                      child: Text(
                          'I want to work out for at least this long on each session.'),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.only(left: 15, bottom: 15),
                      margin:
                          const EdgeInsets.only(left: 20, right: 20, top: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8)),
                            padding:
                                const EdgeInsets.only(left: 15, bottom: 15),
                            margin: const EdgeInsets.only(
                                left: 20, right: 20, top: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //Section Name
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Workout Length :'),

                                    //edit button
                                    IconButton(
                                        onPressed: () {
                                          editLengthField("Workout Length");
                                        },
                                        icon: Icon(
                                          Icons.settings,
                                          color: Colors.grey[400],
                                        ))
                                  ],
                                ),
                                (userData['Workout Length'] == null)
                                    ? const Text('You have not set a goal')
                                    : Text(
                                        userData['Workout Length'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ));
          } else if (snapshot.hasError) {
            return const Center(child: Text("Shapshot hasError!"));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Future<void> editFreqField(String field) async {
    String newVal = "";
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.grey[900],
              title: Text("Edit $field",
                  style: const TextStyle(
                    color: Colors.white,
                  )),
              content: TextField(
                keyboardType: TextInputType.number,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Enter a number between 1 to 7",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                onChanged: (value) {
                  newVal = value;
                },
              ),
              actions: [
                // cancel Button
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel",
                        style: TextStyle(color: Colors.white))),
                TextButton(
                    onPressed: () => Navigator.of(context).pop(newVal),
                    child: const Text("Save",
                        style: TextStyle(color: Colors.white)))
              ],
            ));
    if (newVal.trim().isNotEmpty) {
      if (int.parse(newVal) > 0 && int.parse(newVal) <= 7) {
        await userProfiles.doc(uid).update({field: newVal});
      } else {
        showSnackBar(context, "Input a number between 1 to 7!");
      }

    }
  }

  Future<void> editLengthField(String field) async {
    String newVal = "";
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Text("Edit $field",
              style: const TextStyle(
                color: Colors.white,
              )),
          content: TextField(
            keyboardType: TextInputType.number,
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: "Enter a number in minutes",
              hintStyle: TextStyle(color: Colors.grey),
            ),
            onChanged: (value) {
              newVal = value;
            },
          ),
          actions: [
            // cancel Button
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel",
                    style: TextStyle(color: Colors.white))),
            TextButton(
                onPressed: () => Navigator.of(context).pop(newVal),
                child: const Text("Save",
                    style: TextStyle(color: Colors.white)))
          ],
        ));
    if (newVal.trim().isNotEmpty) {
      await userProfiles.doc(uid).update({field: newVal});
    }
  }

  Future<void> editScrollableField(String field) async {
    String newVal = "";
    //late FixedExtentScrollController _controller;
    //_controller = FixedExtentScrollController();
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Text("Edit $field",
              style: const TextStyle(
                color: Colors.white,
              )),
          content: ListWheelScrollView.useDelegate(
            itemExtent: 7,
            physics: const FixedExtentScrollPhysics() ,
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: 7,
              builder: (context, index) {
                return MyNumDays(days: index);
              }
            ),
          )
          ,
          actions: [
            // cancel Button
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel",
                    style: TextStyle(color: Colors.white))),
            TextButton(
                onPressed: () => Navigator.of(context).pop(newVal),
                child: const Text("Save",
                    style: TextStyle(color: Colors.white)))
          ],
        ));
    if (newVal.trim().isNotEmpty) {
      if (int.parse(newVal) > 0) {
        await userProfiles.doc(uid).update({field: newVal});
      } else {
        showSnackBar(context, "Input a number greater than 0!");
      }

    }
  }
}
