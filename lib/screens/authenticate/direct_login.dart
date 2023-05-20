import 'package:flutter/material.dart';
import 'package:gymbros/shared/constants.dart';

class DirectLogIn extends StatefulWidget {

  @override
  State<DirectLogIn> createState() => _DirectLogInState();
}

class _DirectLogInState extends State<DirectLogIn> {

  String username = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          leading: IconButton(
            onPressed: () {},
            color: Colors.black,
            icon: const Icon(Icons.arrow_back_outlined),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(39.0, 10.0, 39.0, 100.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[Text(
                    "Log In",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                      fontSize: 30.0,
                    ),
                  ),]
              ),
              const SizedBox(height: 64.0),
              Container(
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "username".toUpperCase(),
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                          fontSize: 15.0,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        decoration: textInputDecoration,
                        onChanged: (val) {
                          setState(() {
                            this.username = val;
                          });
                        },
                      ),
                      const SizedBox(height: 32),
                      Text(
                        "password".toUpperCase(),
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                          fontSize: 15.0,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        decoration: textInputDecoration,
                        obscureText: true,
                        onChanged: (val) {
                          setState(() {
                            this.password = val;
                          });
                        },
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                //TODO: implement sign up
                  onPressed: () async {
                    print(password);
                    print(username);
                  },
                  child: Text(
                    "Log In".toUpperCase(),
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor: MaterialStateProperty.all<Color>(Color(0xff6deb4d)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                            side: BorderSide(color: Color(0xff6deb4d))
                        )
                    ),
                    elevation: MaterialStateProperty.all<double>(0),
                    minimumSize: MaterialStateProperty.all<Size>(Size(332, 56)),
                  )
              ),
            ],
          ),
        )
    );
  }
}
