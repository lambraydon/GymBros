import 'package:flutter/material.dart';

class LogIn extends StatefulWidget {

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30.0, 100.0, 30.0, 100.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 116,
              width: 116,
              child: const Image(
                image: AssetImage('assets/logo.jpg'),
              ),
            ),
            const SizedBox(height: 64.0),
            Text(
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
              margin:  EdgeInsets.fromLTRB(120.5, 0, 120.5, 0),
              width:  double.infinity,
              height:  8,
              decoration:  BoxDecoration (
                borderRadius:  BorderRadius.circular(8),
                color:  Color(0xff62548a),
              ),
            ),
            const SizedBox(height: 64.0),
            ElevatedButton.icon(
                //TODO: implement sign in with Facebook
                onPressed: () {},
                icon: Icon(
                  Icons.facebook,
                ),
                label: Text(
                  "Sign in with Facebook".toUpperCase(),
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor: MaterialStateProperty.all<Color>(Color(0xff4a5998)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                              side: BorderSide(color: Color(0xff4a5998))
                          )
                      ),
                      elevation: MaterialStateProperty.all<double>(0),
                      minimumSize: MaterialStateProperty.all<Size>(Size(283, 56)),
                  )
            ),
            const SizedBox(height: 32.0),
            ElevatedButton.icon(
                //TODO: implement sign in with email
                onPressed: () {},
                icon: Icon(
                  Icons.mail,
                ),
                label: Text(
                  "Sign in with email".toUpperCase(),
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
                  minimumSize: MaterialStateProperty.all<Size>(Size(283, 56)),
                )
            ),
            const SizedBox(height: 32.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Already have an account?",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextButton(
                    //TODO: implement login
                    onPressed: () {},
                    child: Text(
                      "Log in",
                      style: TextStyle(
                        color: Color(0xff6deb4d),
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              side: BorderSide(color: Colors.white)
                          )
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
