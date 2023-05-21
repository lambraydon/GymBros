import 'package:flutter/material.dart';
import 'package:gymbros/services/authservice.dart';
import 'package:gymbros/shared/constants.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn({ required this.toggleView });

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String username = '';
  String email = '';
  String password = '';
  String error = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          leading: IconButton(
            onPressed: () {
              widget.toggleView();
            },
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
                  "Sign up with email",
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
                  key: _formKey,
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
                        "email".toUpperCase(),
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                          fontSize: 15.0,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        decoration: textInputDecoration,
                        validator: (val) => (val!.isEmpty) ? 'Enter an email' : null,
                        onChanged: (val) {
                          setState(() {
                            setState(() => email = val);
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
                      TextFormField(
                        decoration: textInputDecoration,
                        obscureText: true,
                        validator: (val) => val!.length < 6 ? 'Enter a password longer than 6 chars!' : null,
                        onChanged: (val) {
                          setState(() {
                            setState(() => password = val);
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
                    if(_formKey.currentState!.validate()){
                      dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                      if(result == null) {
                        setState(() {
                          error = "Please provide a valid email";
                        });
                      }
                    }
                  },
                  child: Text(
                    "Sign up".toUpperCase(),
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
