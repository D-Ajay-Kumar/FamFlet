import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../providers/firebaseAppUser.dart';
import '../screens/login_screen.dart';
import '../index.dart';
import '../providers/appUser.dart';
import '../screens/user_registration_screen.dart';
import '../constants.dart';

class GoogleServices {
  // used to sign in and sign out user
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // gives current user and the user after logging in
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  logInCurrentUser(BuildContext context) async {
    // gives true if user is signed in
    if (await _googleSignIn.isSignedIn()) {
      final FirebaseAppUser firebaseAppUser =
          Provider.of<FirebaseAppUser>(context, listen: false);

      firebaseAppUser.setFirebaseAppUser = _firebaseAuth.currentUser;

      // check whether he filled the form after logging in the first time
      // or closed the app without filling it
      final DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(_firebaseAuth.currentUser.uid)
          .get();

      if (!documentSnapshot.exists) {
        newUser = true; // from constants file
      }

      Navigator.of(context).pushReplacementNamed(
        !newUser ? Index.routeName : UserRegistrationScreen.routeName,
      );
    }
    // if the user is not logged in then send them to Login Screen
    else {
      Navigator.of(context).pushReplacementNamed(
        LoginScreen.routeName,
      );
    }
  }

  signInWithGoogle(BuildContext context) async {
    // logging user in

    final GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    final AuthCredential authCredential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken,
    );

    final FirebaseAppUser firebaseAppUser =
        Provider.of<FirebaseAppUser>(context, listen: false);

    // google account user after successfully logging in
    final User firebaseUser =
        (await _firebaseAuth.signInWithCredential(authCredential)).user;

    firebaseAppUser.setFirebaseAppUser = firebaseUser;

    // check whether it's the first time logging in or not
    final DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .get();

    if (!documentSnapshot.exists) {
      newUser = true; // from constants file
    }

    Navigator.of(context).pushReplacementNamed(
      !newUser ? Index.routeName : UserRegistrationScreen.routeName,
    );
  }

  logOutCurrentUser(BuildContext context) async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();

    final FirebaseAppUser firebaseAppUser =
        Provider.of<FirebaseAppUser>(context, listen: false);
    final AppUser appUser = Provider.of<AppUser>(context, listen: false);

    // clearing google user and app user data
    appUser.removeData();
    firebaseAppUser.removeFirebaseAppUser();

    init = true; // from constants file

    Navigator.of(context).pushReplacementNamed(
      LoginScreen.routeName,
    );
  }
}
