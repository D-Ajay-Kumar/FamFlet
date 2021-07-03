import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_core/firebase_core.dart';

import '../services/googleServices.dart';
import '../constants.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    // checks whether phone has internet connection or not
    // prompts a dialog and exits app if doesn't
    Timer.run(() {
      try {
        InternetAddress.lookup('google.com').then((result) {
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            navigateUser();
          } else {
            _showDialog(); // show dialog
          }
        }).catchError((error) {
          _showDialog(); // show dialog
        });
      } on SocketException catch (_) {
        _showDialog();
      }
    });

    super.initState();
  }

  void _showDialog() async {
    // dialog implementation
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Internet needed!"),
        content: Text("Please check your connection and try again."),
        actions: <Widget>[
          FlatButton(
            child: Text(
              "EXIT",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            onPressed: () {
              SystemNavigator.pop();
            },
          ),
        ],
      ),
    );
  }

  void navigateUser() async {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        appId: '1:1024911830570:android:853b75cabc23db0ebf5d53',
        projectId: 'famflet',
        apiKey: 'AIzaSyCNt-Xhf1yBzBwbWRhixryNZvXwEJPpEng',
        messagingSenderId: '1024911830570',
      ),
    );

    // tries to log in the user if he didnt logout else sends to Login Screen
    GoogleServices().logInCurrentUser(context);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    final height = mediaQuery.height;
    final width = mediaQuery.width;

    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(
          horizontal: width * 0.05,
        ),
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(
              height: height * 0.05,
            ),
            Center(
              child: Text(
                quotes[Random().nextInt(quotes.length)],
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
