import 'package:flutter/material.dart';
import 'package:gymbros/screens/authenticate/direct_login.dart';
import 'package:gymbros/screens/authenticate/sign_in.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});


  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30.0, 100.0, 30.0, 100.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 116,
              width: 116,
              child: Image(
                image: AssetImage('assets/logo.jpg'),
              ),
            ),
            const SizedBox(height: 64.0),
            const Text(
              "Achieve your fitness goals today",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal,
                fontSize: 30.0,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 64.0),
            Container(
              // rectangle1k63 (6:97)
              margin:  const EdgeInsets.fromLTRB(120.5, 0, 120.5, 0),
              width:  double.infinity,
              height:  8,
              decoration:  BoxDecoration (
                borderRadius:  BorderRadius.circular(8),
                color:  const Color(0xff62548a),
              ),
            ),
            const SizedBox(height: 64.0),
            ElevatedButton.icon(
                //TODO: implement sign in with Facebook
                onPressed: () {},
                icon: const Icon(
                  Icons.facebook,
                ),
                label: Text(
                  "Sign in with Facebook".toUpperCase(),
                  style: const TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor: MaterialStateProperty.all<Color>(const Color(0xff4a5998)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                              side: const BorderSide(color: Color(0xff4a5998))
                          )
                      ),
                      elevation: MaterialStateProperty.all<double>(0),
                      minimumSize: MaterialStateProperty.all<Size>(const Size(283, 56)),
                  )
            ),
            const SizedBox(height: 32.0),
            ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignIn())
                  );
                },
                icon: const Icon(
                  Icons.mail,
                ),
                label: Text(
                  "Sign in with email".toUpperCase(),
                  style: const TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor: MaterialStateProperty.all<Color>(const Color(0xff6deb4d)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                          side: const BorderSide(color: Color(0xff6deb4d))
                      )
                  ),
                  elevation: MaterialStateProperty.all<double>(0),
                  minimumSize: MaterialStateProperty.all<Size>(const Size(283, 56)),
                )
            ),
            const SizedBox(height: 32.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  "Already have an account?",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DirectLogIn())
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          const RoundedRectangleBorder(
                              side: BorderSide(color: Colors.white)
                          )
                      ),
                    ),
                  child: const Text(
                    "Log in",
                    style: TextStyle(
                      color: Color(0xff6deb4d),
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
    )
    );
  }
}
