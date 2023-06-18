import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gymbros/services/authservice.dart';
import '../workoutTracker/workoutHistory.dart';
import 'package:gymbros/screens/workoutTracker/workoutData.dart';
import 'package:provider/provider.dart';
import 'package:gymbros/screens/components/mytextfield.dart';


class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    Provider.of<WorkoutData>(context, listen: false).initialiseWorkoutList();
  }
  final AuthService _auth = AuthService();
  final CollectionReference userProfiles = FirebaseFirestore.instance.collection("userProfiles");



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:Colors.purple[200],
        appBar: AppBar(
          title: Text('Home Page'),
          backgroundColor: Colors.white,
          elevation: 0.0,
          actions: <Widget>[TextButton.icon(
            icon: Icon(Icons.person),
            label: Text('logout'),
            onPressed: () async {
              await _auth.signOut();
            },
          ),
          ],
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: userProfiles.doc(_auth.getUid()).snapshots(),
          builder: (context, snapshot) {
            //get user data
            if (snapshot.hasData) {
              final userData = snapshot.data!.data() as Map<String,dynamic>;
              return ListView(
                  children: [
                  SizedBox(height: 50),
                  Icon(
                    Icons.person,
                    size: 72,
                  ),
                    Text(
                      "Logged in as ${_auth.getEmail()}",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    MyTextField(
                        text: userData["Name"],
                        sectionName: "Username : ",
                        onPressedFunc: () => editField("Name")
            )
                  ]
              );
            } else if(snapshot.hasError) {
              return Center(
                  child: Text("Error + ${snapshot.error.toString()}")
              );
            } else {
              return Center(
                child: Text("Error"),
              );
            }
            },
        ),
    );
  }
  //edit function
  Future<void> editField(String field) async{
    String newVal = "";
    await showDialog(
        context: context ,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Text("Edit + $field",
              style: const TextStyle(color: Colors.white,)
          ),
          content: TextField(
            autofocus:true,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Enter new $field",
              hintStyle: TextStyle(color: Colors.grey),
            ),
            onChanged: (value) {
              newVal = value;
            },
          ),
          actions: [
            // cancel Button
            TextButton(onPressed: ()=> Navigator.pop(context),
                child:Text ("Cancel",style: TextStyle(color: Colors.white)
                )
            ),
            TextButton(onPressed: () => Navigator.of(context).pop(newVal),
                child: Text("Save", style: TextStyle(color: Colors.white)
                )
            )
          ],
        )
    );
    if (newVal.trim().length > 0) {
      await userProfiles.doc(_auth.getUid()).update({field: newVal});
    }
  }
  /*
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<GbProfile?>>.value(
        value:DatabaseService(uid:_auth.getUid()).profiles,
        initialData: [],
        catchError: (_,err) => [GbProfile(name: "Error")],
        child:Scaffold(
        backgroundColor: Colors.purple[100],
        appBar: AppBar(
          title: Text('Home Page'),
          backgroundColor: Colors.white,
          elevation: 0.0,
          actions: <Widget>[
            TextButton.icon(
              icon: Icon(Icons.person),
              label: Text('logout'),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
          ],
        ),
      body: UserProfile(),
        ),
    );
  }

return Scaffold(
      backgroundColor:Colors.purple[200],
      appBar: AppBar(
        title: Text('Home Page'),
        backgroundColor: Colors.white,
          elevation: 0.0,
        actions: <Widget>[TextButton.icon(
          icon: Icon(Icons.person),
          label: Text('logout'),
          onPressed: () async {
            await _auth.signOut();
          },
        ),
        ],
      ),
      body: ListView(
        children: [
          SizedBox(height: 50),

          Icon(
            Icons.person,
            size: 72,
          ),

          Text(
            "Logged in as ${_auth.getEmail()}",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[700]),
          )
        ]
      )
    );
   */
}
