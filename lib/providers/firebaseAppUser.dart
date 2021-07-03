import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAppUser with ChangeNotifier {
  // stores and provides google account data
  User _firebaseUser;

  set setFirebaseAppUser(User firebaseUser) {
    _firebaseUser = firebaseUser;
  }

  User get getFirebaseAppUser {
    return _firebaseUser;
  }

  void removeFirebaseAppUser() {
    _firebaseUser = null;
  }
}
